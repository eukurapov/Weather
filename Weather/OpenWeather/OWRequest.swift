//
//  OWRequest.swift
//  Weather
//
//  Created by Eugene Kurapov on 27.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import Foundation
import Combine

// base class for OpenWeather API request
class OWRequest<Fetched> where Fetched: Codable, Fetched: Hashable {
    
    private(set) var results = CurrentValueSubject<Set<Fetched>, Never>([])
    
    // to be implemented in subclassed for specific request
    var query: String { "" }
    func decode(_ json: Data) -> Set<Fetched> { Set<Fetched>() }
    
    // request iteration parameters for when it's required to make a request by parts
    var iterationsDone: Int = 0
    // when expected iterations is 0 — only 1 fetch request performed
    var iterationsExpected: Int = 0
    var fetchTimer: Timer?
    var fetchInteval: TimeInterval = 5
    
    private var urlRequest: URLRequest? { Self.authorizedURLRequest(query: query) }
    // keeping URLSession result update out of fetch function scope and cancel if another request comes in
    private var fetchCancellable: AnyCancellable?
    
    func fetch() {
        if let urlRequest = self.urlRequest {
            // create a published for a request and subscribe to result updates
            // errors are ignored
            // results update to be preformed in a main queue to update the UI
            fetchCancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map { [weak self] data, response in
                self?.decode(data) ?? []
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in self?.handleResults(results) }
        }
    }
    
    func stopFetching() {
        fetchCancellable?.cancel()
        fetchTimer?.invalidate()
        iterationsDone = 0
    }
    
    func handleResults(_ results: Set<Fetched>) {
        // if more than 1 iterations required — add new results and plan next iteration after fetchInterval
        // just update results otherwise
        if iterationsExpected != 0 {
            iterationsDone += 1
            self.results.value.formUnion(results)
            if iterationsDone < iterationsExpected {
                fetchTimer = Timer.scheduledTimer(withTimeInterval: fetchInteval, repeats: false) { [weak self] timer in
                    self?.fetch()
                }
            } else {
                iterationsDone = 0
            }
        } else {
            self.results.value = results
        }
    }
    
    // generate OpenWeather request with auth params
    static func authorizedURLRequest(query: String) -> URLRequest? {
        // get credentials from app params
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
