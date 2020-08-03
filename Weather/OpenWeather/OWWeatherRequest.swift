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
    
    override var query: String {
        if let ids = self.ids {
            return "group?id=\(ids.map { String($0) }.joined(separator: ","))"
        } else if let location = self.location {
            return "weather?lat=\(location.latitude)&lon=\(location.longitude)"
        }
        return ""
    }
    
    init(ids: [Int]) {
        self.ids = ids
        super.init()
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
