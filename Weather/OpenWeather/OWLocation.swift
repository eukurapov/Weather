//
//  OWLocation.swift
//  Weather
//
//  Created by Eugene Kurapov on 28.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import Foundation

struct OWListResult: Codable {
    private(set) var list: [OWLocation]
}

// struct to match OpenWeather main response object
struct OWLocation: Codable, Identifiable, Hashable {
    
    private(set) var id: Int
    private(set) var name: String
    private(set) var coord: Coord
    private(set) var main: Condition
    private(set) var wind: Wind
    private(set) var weather: [Description]
    private(set) var sys: Sys
    
    /// - Conform to Hashable (Equitable actually)

    static func == (lhs: OWLocation, rhs: OWLocation) -> Bool {
        lhs.id == rhs.id
    }
 
    /// - Supporting structs
    
    struct Coord: Codable, Hashable {
        private(set) var lat: Double
        private(set) var lon: Double
    }
    
    struct Condition: Codable, Hashable {
        private(set) var temp: Double
        private(set) var feelsLike: Double
        private(set) var tempMin: Double
        private(set) var tempMax: Double
        private(set) var pressure: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
        }
    }
    
    struct Wind: Codable, Hashable {
        private(set) var speed: Double
        private(set) var deg: Int
    }
    
    struct Description: Codable, Hashable {
        private(set) var main: String
        private(set) var description: String
        private(set) var icon: String
        
        var iconUrl: URL? { URL(string: "https://openweathermap.org/img/wn/\(self.icon)@2x.png") }
    }
    
    struct Sys: Codable, Hashable {
        private(set) var country: String
        
        var flagIconUrl: URL? { URL(string: "https://openweathermap.org/images/flags/\(self.country.lowercased()).png") }
    }
    
}
