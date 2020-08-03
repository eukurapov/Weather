//
//  LocationFetcher.swift
//  Weather
//
//  Created by Eugene Kurapov on 31.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import CoreLocation
import Combine

class LocationFetcher: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    let manager = CLLocationManager()
    
    var currentLocation = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.distanceFilter = self.distanceFilter
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.first?.coordinate,
            (currentLocation.value?.latitude != newLocation.latitude || currentLocation.value?.longitude != newLocation.longitude) {
            currentLocation.value = newLocation
        }
    }
    
    private let distanceFilter: CLLocationDistance = 1000
    
}
