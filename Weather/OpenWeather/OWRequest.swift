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
        guard let credentials = Bundle.main.object(forInfoDictionaryKey: "OpenWeather API Key") as? String, !credentials.isEmpty
        else {
            print("WARN: No OpenWeather API Key found -- Add your Open Weather API key into info in format appid=<API KEY>")
            return nil
        }
        let openWeatherURL = "https://api.openweathermap.org/data/2.5/"
        let units = "units=metric"
        if let url = URL(string: openWeatherURL + query + "&\(units)&\(credentials)") {
            return URLRequest(url: url)
        }
        return nil
    }
    
}
