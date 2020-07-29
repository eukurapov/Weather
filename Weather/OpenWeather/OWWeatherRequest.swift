//
//  OWWeatherRequest.swift
//  Weather
//
//  Created by Eugene Kurapov on 29.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import Foundation

class OWWeatherRequest: OWRequest<OWLocation> {
    
    private(set) var ids: [Int]
    
    override var query: String { "group?id=\(ids.map { String($0) }.joined(separator: ","))" }
    
    init(ids: [Int]) {
        self.ids = ids
        super.init()
    }
    
    override func decode(_ json: Data) -> Set<OWLocation> {
        let result = try? JSONDecoder().decode(OWListResult.self, from: json)
        return Set(result?.list ?? [])
    }

}
