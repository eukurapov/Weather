//
//  LocationFetcher.swift
//  Weather
//
//  Created by Eugene Kurapov on 31.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import CoreLocation
import Combine

// LocationManager delegate to handle current user location updates
class LocationFetcher: NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    // current location variable available for updates subscription (use sink to get value once it's updated / available)
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
