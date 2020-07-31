//
//  CityStore.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

class WeatherFetcher: ObservableObject {
    
    @Published var searchResults: [OWLocation] = []
    @Published var searchState: SearchState = .notStarted
    
    private var findRequest: OWFindRequest!
    private var findResultCancellable: AnyCancellable?
    
    func findLocations(for request: String) {
        self.searchState = .searching
        self.searchResults.removeAll()
        self.findResultCancellable = nil
        findRequest?.stopFetching()
        findRequest = OWFindRequest(searchRequest: request)
        findRequest.fetch()
        findResultCancellable = findRequest?.results.sink { [weak self] results in
            self?.searchResults = results.compactMap( { $0 } )
            self?.searchState = .completed // does not work as it triggered each time results changed, not when request is completed
        }
    }
    
    func completeSearch() {
        searchResults.removeAll()
        searchState = .notStarted
    }
    
    private var weatherRequest: OWWeatherRequest!
    private var weatherResultCancellable: AnyCancellable?
    
    func fetchLocations(with ids: [Int], in context: NSManagedObjectContext) {
        guard !ids.isEmpty else { return }
        self.weatherResultCancellable = nil
        weatherRequest?.stopFetching()
        weatherRequest = OWWeatherRequest(ids: ids)
        weatherRequest.fetch()
        weatherResultCancellable = weatherRequest?.results.sink { results in
            for owlocation in results {
                Location.from(owlocation, context: context)
            }
        }
    }
    
    enum SearchState {
        case completed, searching, notStarted
    }
    
}
