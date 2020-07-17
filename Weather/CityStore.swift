//
//  CityStore.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI

class CityStore: ObservableObject {
    
    @Published var cities: [City] = []
    
}
