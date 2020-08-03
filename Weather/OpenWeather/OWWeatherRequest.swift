//
//  OWWeatherRequest.swift
//  Weather
//
//  Created by Eugene Kurapov on 29.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import Foundation

class OWWeatherRequest: OWRequest<OWLocation> {
    
    typealias SearchLocation = (latitude: Double, longitude: Double)
    
    private(set) var ids: [Int]?
    private(set) var location: SearchLocation?
    
    private let batchSize: Int = 20 // ids limit in OpanWeather request
    
    override var query: String {
        if let ids = self.ids {
            let intervalStart: Int = iterationsDone * batchSize
            let intervalEnd: Int = min((iterationsDone + 1) * batchSize, ids.count)
            let batch = ids[intervalStart..<intervalEnd]
            return "group?id=\(batch.map { String($0) }.joined(separator: ","))"
        } else if let location = self.location {
            return "weather?lat=\(location.latitude)&lon=\(location.longitude)"
        }
        return ""
    }
    
    init(ids: [Int]) {
        self.ids = ids
        super.init()
        self.iterationsDone = 0
        self.iterationsExpected = ids.count / self.batchSize + 1
    }
    
    init(location: SearchLocation) {
        self.location = location
        super.init()
    }
    
    override func decode(_ json: Data) -> Set<OWLocation> {
        if ids != nil {
            let result = try? JSONDecoder().decode(OWListResult.self, from: json)
            return Set(result?.list ?? [])
        } else if location != nil {
            if let result = try? JSONDecoder().decode(OWLocation.self, from: json) {
                return Set([result])
            }
        }
        return []
    }

}
