//
//  CityWeather.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI

struct CityWeather: View {
    
    var city: City
    
    var body: some View {
        Text(city.name)
    }
}
