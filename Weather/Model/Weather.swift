//
//  Weather.swift
//  Weather
//
//  Created by Eugene Kurapov on 30.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import CoreData

extension Weather: Identifiable {
    
    static func from(_ owlocation: OWLocation, context: NSManagedObjectContext) -> Weather {
        let request = fetchRequest(NSPredicate(format: "location.id = %@", NSNumber(value: owlocation.id)))
        let results = (try? context.fetch(request)) ?? []
        let weather = results.first ?? Weather(context: context)
        weather.temp = owlocation.main.temp
        weather.tempMin = owlocation.main.tempMin
        weather.tempMax = owlocation.main.tempMax
        weather.feelsLike = owlocation.main.feelsLike
        weather.pressure = Int64(owlocation.main.pressure)
        weather.windSpeed = owlocation.wind.speed
        weather.windDegree = Int64(owlocation.wind.deg)
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
