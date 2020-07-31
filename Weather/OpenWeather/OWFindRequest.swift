//
//  OWFindRequest.swift
//  Weather
//
//  Created by Eugene Kurapov on 28.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import Foundation

class OWFindRequest: OWRequest<OWLocation> {
    
    private(set) var searchRequest: String
    
    override var query: String { "find?q=\(self.searchRequest)" }
    
    init(searchRequest: String) {
        self.searchRequest = searchRequest.replacingOccurrences(of: " ", with: "+")
        super.init()
    }
    
    override func decode(_ json: Data) -> Set<OWLocation> {
        let result = try? JSONDecoder().decode(OWListResult.self, from: json)
        return Set(result?.list ?? [])
    }
    
}
