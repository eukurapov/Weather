//
//  OWRequest.swift
//  Weather
//
//  Created by Eugene Kurapov on 27.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import Foundation
import Combine

class OWRequest<Fetched> where Fetched: Codable, Fetched: Hashable {
    
    private(set) var results = CurrentValueSubject<Set<Fetched>, Never>([])
    
    var query: String { "" }
    func decode(_ json: Data) -> Set<Fetched> { Set<Fetched>() }
    
    private var urlRequest: URLRequest? { Self.authorizedURLRequest(query: query) }
    private var fetchCancellable: AnyCancellable?
    
    func fetch() {
        if let urlRequest = self.urlRequest {
            print("fetching \(urlRequest)")
            fetchCancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map { [weak self] data, response in
                self?.decode(data) ?? []
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in self?.results.value = results }
        }
    }
    
    func stopFetching() {
        fetchCancellable?.cancel()
    }
    
    static func authorizedURLRequest(query: String) -> URLRequest? {
        let openWeatherURL = "https://api.openweathermap.org/data/2.5/"
        let units = "units=metric"
        /// - TODO Move to app config
        let credentials = "appid=c5588028674615c78e4c9c91bdb8c303"
        if let url = URL(string: openWeatherURL + query + "&\(units)&\(credentials)") {
            return URLRequest(url: url)
        }
        return nil
    }
    
}
