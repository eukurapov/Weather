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
        private(set) var id: Int
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

/*
 
 {
    "message":"accurate",
    "cod":"200",
    "count":4,
    "list":[
       {
          "id":524901,
          "name":"Moscow",
          "coord":{
             "lat":55.7522,
             "lon":37.6156
          },
          "main":{
             "temp":21.97,
             "feels_like":20.82,
             "temp_min":18,
             "temp_max":25,
             "pressure":1019,
             "humidity":57
          },
          "dt":1595858954,
          "wind":{
             "speed":3,
             "deg":160
          },
          "sys":{
             "country":"RU"
          },
          "rain":null,
          "snow":null,
          "clouds":{
             "all":75
          },
          "weather":[
             {
                "id":211,
                "main":"Thunderstorm",
                "description":"гроза",
                "icon":"11d"
             }
          ]
       },
       {
          "id":5601538,
          "name":"Moscow",
          "coord":{
             "lat":46.7324,
             "lon":-117.0002
          },
          "main":{
             "temp":17.22,
             "feels_like":15.24,
             "temp_min":15,
             "temp_max":19.44,
             "pressure":1018,
             "humidity":59
          },
          "dt":1595859376,
          "wind":{
             "speed":2.56,
             "deg":106
          },
          "sys":{
             "country":"US"
          },
          "rain":null,
          "snow":null,
          "clouds":{
             "all":1
          },
          "weather":[
             {
                "id":800,
                "main":"Clear",
                "description":"ясно",
                "icon":"01d"
             }
          ]
       },
       {
          "id":5202009,
          "name":"Moscow",
          "coord":{
             "lat":41.3368,
             "lon":-75.5185
          },
          "main":{
             "temp":25.84,
             "feels_like":25.65,
             "temp_min":24.44,
             "temp_max":26.67,
             "pressure":1014,
             "humidity":61
          },
          "dt":1595859363,
          "wind":{
             "speed":4.1,
             "deg":230
          },
          "sys":{
             "country":"US"
          },
          "rain":null,
          "snow":null,
          "clouds":{
             "all":1
          },
          "weather":[
             {
                "id":800,
                "main":"Clear",
                "description":"ясно",
                "icon":"01d"
             }
          ]
       },
       {
          "id":524894,
          "name":"Moscow",
          "coord":{
             "lat":55.7617,
             "lon":37.6067
          },
          "main":{
             "temp":21.96,
             "feels_like":22.54,
             "temp_min":18,
             "temp_max":25,
             "pressure":1020,
             "humidity":77
          },
          "dt":1595858954,
          "wind":{
             "speed":3,
             "deg":130
          },
          "sys":{
             "country":"RU"
          },
          "rain":null,
          "snow":null,
          "clouds":{
             "all":40
          },
          "weather":[
             {
                "id":520,
                "main":"Rain",
                "description":"небольшой проливной дождь",
                "icon":"09d"
             }
          ]
       }
    ]
 }"%"
 
 */
