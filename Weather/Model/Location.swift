//
//  Location.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import CoreData

extension Location: Identifiable {
    
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
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Location> {
        let request = NSFetchRequest<Location>(entityName: "Location")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "order_", ascending: true)]
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
            return location
        }
    }
    
    private static func nextOrder(context: NSManagedObjectContext) -> Int {
        let request = fetchRequest(.all)
        let results = (try? context.fetch(request)) ?? []
        return (results.max(by: { $0.order < $1.order } )?.order ?? 0) + 1
    }
    
    @discardableResult
    static func from(_ owlocation: OWLocation, context: NSManagedObjectContext) -> Location {
        let location = getBy(owlocation.id, context: context)
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
