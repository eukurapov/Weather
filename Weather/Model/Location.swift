//
//  Location.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import CoreData
import MapKit

extension Location: MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var title: String? {
        var title = name
        if let code = countryCode { title += ", \(code)" }
        return title
    }
    
    public var subtitle: String? {
        if let weather = weather {
            var subtitle = "\(weather.temp)°C"
            if let condition = weather.condition { subtitle += ", \(condition)" }
            subtitle += ", \(weather.windDirection) \(weather.windSpeed)m/s"
            return subtitle
        }
        return nil
    }
    
}

extension Location: Identifiable {
    
    enum Source: Int16 { case manual = 1, location }
    
    public var id: Int {
        get { Int(id_) }
        set { id_ = Int64(newValue) }
    }
    
    var order: Int {
        get { Int(order_) }
        set { order_ = Int16(newValue) }
    }
    
    var name: String {
        get { name_ ?? "Unknown" }
        set { name_ = newValue  }
    }
    
    var source: Source? {
        get { Source(rawValue: source_) }
        set {
            if source != .manual {
                source_ = newValue?.rawValue ?? Source.manual.rawValue
            }
        }
    }
    
    var lastUpdated: Date {
        get { return lastUpdated_ ?? Date.distantPast }
        set { lastUpdated_ = newValue }
    }
    
    func setAsCurrent() {
        let request = Location.fetchRequest(NSPredicate(format: "isCurrent = YES"))
        let results = (try? self.managedObjectContext?.fetch(request)) ?? []
        if let current = results.first {
            if current.id != self.id && current.source == .location {
                current.remove()
            } else {
                current.isCurrent = false
            }
        }
        self.isCurrent = true
        try? self.managedObjectContext?.save()
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Location> {
        let request = NSFetchRequest<Location>(entityName: "Location")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "isCurrent", ascending: false), NSSortDescriptor(key: "order_", ascending: true)]
        return request
    }
    
    private static func getBy(_ id: Int, context: NSManagedObjectContext) -> Location {
        let request = fetchRequest(NSPredicate(format: "id_ = %@", NSNumber(value: id)))
        let results = (try? context.fetch(request)) ?? []
        if let location = results.first {
            return location
        } else {
            let location = Location(context: context)
            location.id = id
            location.order = nextOrder(context: context)
            location.isCurrent = false
            return location
        }
    }
    
    private static func nextOrder(context: NSManagedObjectContext) -> Int {
        let request = fetchRequest(.all)
        let results = (try? context.fetch(request)) ?? []
        return (results.max(by: { $0.order < $1.order } )?.order ?? 0) + 1
    }
    
    @discardableResult
    static func from(_ owlocation: OWLocation, context: NSManagedObjectContext, source: Source? = nil) -> Location {
        let location = getBy(owlocation.id, context: context)
        location.lastUpdated = Date()
        // rough solution to rewrite source when current location is also added manually to keep it in place when location is changed
        if source != nil {
            location.source = source
        }
        location.name = owlocation.name
        location.latitude = owlocation.coord.lat
        location.longitude = owlocation.coord.lon
        location.countryCode = owlocation.sys.country
        location.countryFlagURL = owlocation.sys.flagIconUrl
        location.weather = Weather.from(owlocation, context: context)
        location.objectWillChange.send()
        try? context.save()
        return location
    }
    
    func setOrder(_ order: Int) {
        let context = self.managedObjectContext
        self.order = order
        try? context?.save()
    }
    
    func remove() {
        let context = self.managedObjectContext
        context?.delete(self)
        try? context?.save()
    }
    
}
