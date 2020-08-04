//
//  MapView.swift
//  Weather
//
//  Created by Eugene Kurapov on 03.08.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit

// struct to wrap UIKit MapView and make it working for SwiftUI
struct MapView: UIViewRepresentable {
    
    // list of MKAnnotation objects to display on map
    var annotations: [MKAnnotation]
    // position to center at when map is shown
    var center: MKAnnotation?
    
    func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.delegate = context.coordinator
        mkMapView.addAnnotations(self.annotations)
        return mkMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let annotation = center {
            let town = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            uiView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: town), animated: true)
            uiView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    // delegate class for MapView
    class Coordinator: NSObject, MKMapViewDelegate {
        
        // generating a view for annotation
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "MapViewAnnotation") ??
                MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapViewAnnotation")
            view.canShowCallout = true
            return view
        }
        
    }
    
}
