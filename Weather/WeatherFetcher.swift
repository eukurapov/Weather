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
    
    private var findRequest: OWFindRequest!
    private var resultCancellable: AnyCancellable?
    
    func fetchLocations(for request: String) {
        self.resultCancellable = nil
        findRequest?.stopFetching()
        findRequest = OWFindRequest(searchRequest: request)
        findRequest.fetch()
        resultCancellable = findRequest?.results.sink { [weak self] results in
            self?.locations = results.compactMap( { $0 } )
        }
    }
    
}
