//
//  CityStore.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI
import Combine

class WeatherFetcher: ObservableObject {
    
    @Published var locations: [OWLocation] = []
    @Published var searchResults: [OWLocation] = []
    
    private var findRequest: OWFindRequest!
    private var findResultCancellable: AnyCancellable?
    
    func findLocations(for request: String) {
        self.findResultCancellable = nil
        findRequest?.stopFetching()
        findRequest = OWFindRequest(searchRequest: request)
        findRequest.fetch()
        findResultCancellable = findRequest?.results.sink { [weak self] results in
            self?.searchResults = results.compactMap( { $0 } )
        }
    }
    
    private var weatherRequest: OWWeatherRequest!
    private var weatherResultCancellable: AnyCancellable?
    
    func fetchLocations() {
        guard !locations.isEmpty else { return }
        self.weatherResultCancellable = nil
        weatherRequest?.stopFetching()
        weatherRequest = OWWeatherRequest(ids: locations.map { $0.id })
        weatherRequest.fetch()
        weatherResultCancellable = weatherRequest?.results.sink { [weak self] results in
            self?.locations = results.compactMap( { $0 } )
        }
    }
    
}
