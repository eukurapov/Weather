//
//  Weather.swift
//  Weather
//
//  Created by Eugene Kurapov on 30.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import CoreData

// extension for CoreData generated class to wrap optional values and support generating from OpenWeather API response
extension Weather: Identifiable {
    
    var windDegree: Int {
        get { Int(windDegree_) }
        set { windDegree_ = Int16(newValue) }
    }
    
    var pressure: Int {
        get { Int(pressure_) }
        set { pressure_ = Int64(newValue) }
    }
    
    var windDirection: String {
        switch windDegree {
            case 0..<45, 315..<360: return "N"
            case 45..<135: return "E"
            case 135..<225: return "S"
            case 225..<315: return "W"
            default: return ""
        }
    }
    
    // creates or updates a record in CoreData based on OW response
    static func from(_ owlocation: OWLocation, context: NSManagedObjectContext) -> Weather {
        // fetching related DB record by location id
        let request = fetchRequest(NSPredicate(format: "location.id_ = %@", NSNumber(value: owlocation.id)))
        let results = (try? context.fetch(request)) ?? []
        // create new record if not found
        let weather = results.first ?? Weather(context: context)
        weather.temp = owlocation.main.temp
        weather.tempMin = owlocation.main.tempMin
        weather.tempMax = owlocation.main.tempMax
        weather.feelsLike = owlocation.main.feelsLike
        weather.pressure = owlocation.main.pressure
        weather.windSpeed = owlocation.wind.speed
        weather.windDegree = owlocation.wind.deg
        weather.group = owlocation.weather.first?.main
        weather.condition = owlocation.weather.first?.description
        weather.conditionIconURL = owlocation.weather.first?.iconUrl
        // saving changes seems not required here as it's saved in Location.from(_:context:source)
        //try? context.save()
        return weather
    }
    
    // generate CoreData request with general sorting options and provided predicate
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Weather> {
        let request = NSFetchRequest<Weather>(entityName: "Weather")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "temp", ascending: false)]
        return request
    }
    
}
