//
//  City.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import Foundation

struct City: Identifiable {
    
    var id: UUID = UUID()
    
    var name: String
    var country: String?
    var region: String?
    var latitude: Double?
    var longitude: Double?
    
//    var weather: Weather?
    
}
