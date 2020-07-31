//
//  LocationFetcher.swift
//  Weather
//
//  Created by Eugene Kurapov on 31.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    let manager = CLLocationManager()
    @Published var lastLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.distanceFilter = 1000
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.first?.coordinate
    }
    
}
