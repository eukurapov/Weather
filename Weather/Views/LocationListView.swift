//
//  LocationListView.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

struct LocationListView: View {
    
    // property wrapper to “observe” coredata request results — i.e. results list updates once something changed in DB
    @FetchRequest(fetchRequest: Location.fetchRequest(.all)) var locations: FetchedResults<Location>
    // helpers to fetch weather using OpenWeather API and to get current user location
    @ObservedObject var weatherFetcher: WeatherFetcher = WeatherFetcher()
    @ObservedObject var locationFetcher = LocationFetcher()
    
    // states to show related sheets
    @State var showLocationSearch: Bool = false
    @State var showWeatherMap: Bool = false
    
    // fix for Navigaitionview being disabled after editor is closed by button
    @Environment(\.presentationMode) var presentationMode
    // context to work with CoreData
    @Environment(\.managedObjectContext) var context
    // edit mode controlled by Edit button in NavigationBar
    @Environment(\.editMode) var editMode
    
    //    @State var selectedItem: Location?
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(locations) { location in self.locationItem(for: location) }
                        .onMove(perform: move)
                        .onDelete(perform: remove)
                }
            }
            .navigationBarTitle("Weather")
            .navigationBarItems(
                leading: EditButton(),
                trailing: trailingNavBarItems)
        }
        .onAppear {
            UITableView.appearance().separatorStyle = .none
            // start receiving user current location
            self.locationFetcher.start()
            // update weather for all locations
            self.updateLocations()
        }
    }
    
    // updates locations list, cancellable is requiered to keep sink return value out of function scope
    @State private var locationCancellable: AnyCancellable?
    private func updateLocations() {
        // fetch weather for all locations in list
        self.weatherFetcher.fetch(Array(self.locations), in: self.context)
        // cancel existing subscription to current location updates if any
        locationCancellable?.cancel()
        // subscribe to current user location updates to request location with weather for new coordinates
        self.locationCancellable = self.locationFetcher.currentLocation.sink { location in
            if let lastLocation = location {
                self.weatherFetcher.fetchCurrentLocationAt(latitude: lastLocation.latitude, longitude: lastLocation.longitude, in: self.context)
            }
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        var orderedLocations = locations.map { $0 }
        orderedLocations.move(fromOffsets: source, toOffset: destination)
        for (index, location) in orderedLocations.enumerated() {
            location.setOrder(index)
        }
    }
    
    private func remove(at offsets: IndexSet) {
        for index in offsets {
            locations[index].remove()
        }
    }
    
    private func locationItem(for location: Location) -> some View {
        LocationListItem(location: location)
            .id(UUID()) // fix for extra animation when moving an item up in a list (see developer.apple.com/forums/thread/133134)
        // some code to add expanding view with forecast later (maybe)
        //          .onTapGesture {
        //                if self.selectedItem != location {
        //                    self.selectedItem = location
        //                } else {
        //                    self.selectedItem = nil
        //                }
        //        }
        //        if self.selectedItem == location {
        //            HStack {
        //                Text("Here could be a feorecast")
        //            }.frame(minHeight: 120)
        //        }
    }
    
    private var trailingNavBarItems: some View {
        HStack {
            // button to show weather locations on map
            Button(
                action: {
                    self.showWeatherMap = true
            },
                label: {
                    Image(systemName: "map")
                        .imageScale(.medium)
                        .padding(.horizontal, 5)
            })
            .sheet(isPresented: $showWeatherMap) {
                NavigationView {
                    MapView(annotations: Array(self.locations), center: self.locations.first(where: { $0.isCurrent }))
                        .edgesIgnoringSafeArea(.all)
                        .navigationBarTitle("Map", displayMode: .inline)
                        .navigationBarItems(trailing: Button("Done", action: { self.showWeatherMap = false }))
                }
            }
            // update locations button
            Button(
                action: {
                    self.updateLocations()
            },
                label: {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.medium)
                        .padding(2)
            })
            // button to show locations search screen
            Button(
                action: {
                    self.showLocationSearch = true
            },
                label: {
                    Image(systemName: "plus").imageScale(.large).padding(2)
            })
            .sheet(isPresented: $showLocationSearch) {
                LocationSearch(isShown: self.$showLocationSearch) { searchResult in
                    Location.from(searchResult, context: self.context, source: .manual)
                }
                .environmentObject(self.weatherFetcher)
            }
        }
    }
    
}




















//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let weatherFetcher = WeatherFetcher()
//        return LocationListView(weatherFetcher: weatherFetcher)
//    }
//}
