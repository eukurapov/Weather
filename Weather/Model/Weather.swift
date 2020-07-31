//
//  Weather.swift
//  Weather
//
//  Created by Eugene Kurapov on 30.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import CoreData

extension Weather: Identifiable {
    
    var windDegree: Int {
        get { Int(windDegree_) }
        set { windDegree_ = Int16(newValue) }
    }
    
    var pressure: Int {
        get { Int(pressure_) }
        set { pressure_ = Int64(newValue) }
    }
    
    static func from(_ owlocation: OWLocation, context: NSManagedObjectContext) -> Weather {
        let request = fetchRequest(NSPredicate(format: "location.id_ = %@", NSNumber(value: owlocation.id)))
        let results = (try? context.fetch(request)) ?? []
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
        try? context.save()
        return weather
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Weather> {
        let request = NSFetchRequest<Weather>(entityName: "Weather")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "temp", ascending: false)]
        return request
    }
    
}
