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

    @FetchRequest(fetchRequest: Location.fetchRequest(.all)) var locations: FetchedResults<Location>
    @ObservedObject var weatherFetcher: WeatherFetcher = WeatherFetcher()
    
    @ObservedObject var locationFetcher = LocationFetcher()
    
    @State var showCitySearch: Bool = false
    @State var showWeatherMap: Bool = false
    
    @Environment(\.editMode) var editMode
    // fix for Navigaitionview being disabled after editor is closed by button
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    
//    @State var selectedItem: Location?
    
    var body: some View {
         NavigationView {
            VStack {
                List {
                    ForEach(locations) { location in
                        LocationListItem(location: location)
                        .id(UUID()) // fix for extra animation when moving an item up in a list (see developer.apple.com/forums/thread/133134)
//                        .onTapGesture {
//                            if self.selectedItem != location {
//                                self.selectedItem = location
//                            } else {
//                                self.selectedItem = nil
//                            }
//                        }
//                        if self.selectedItem == location {
//                            HStack {
//                                Text("Here could be a feorecast")
//                            }.frame(minHeight: 120)
//                        }
                    }
                    .onMove(perform: move)
                    .onDelete(perform: remove)
                }
            }
            .navigationBarTitle("Weather")
            .navigationBarItems(
                leading: EditButton(),
                trailing: HStack {
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
                    Button(
                        action: {
                            self.updateLocations()
                    },
                        label: {
                            Image(systemName: "arrow.clockwise")
                                .imageScale(.medium)
                                .padding(2)
                    })
                    Button(
                        action: {
                            self.showCitySearch = true
                    },
                        label: {
                            Image(systemName: "plus").imageScale(.large).padding(2)
                    })
                    .sheet(isPresented: $showCitySearch) {
                        LocationSearch(isShown: self.$showCitySearch) { searchResult in
                            Location.from(searchResult, context: self.context, source: .manual)
                        }
                        .environmentObject(self.weatherFetcher)
                    }
            })
        }
        .onAppear {
            self.locationFetcher.start()
            self.updateLocations()
            UITableView.appearance().separatorStyle = .none
        }
    }
    
    @State private var locationCancellable: AnyCancellable?
    
    private func updateLocations() {
        self.weatherFetcher.fetch(Array(self.locations), in: self.context)
        locationCancellable?.cancel()
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
    
}




















//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let weatherFetcher = WeatherFetcher()
//        return LocationListView(weatherFetcher: weatherFetcher)
//    }
//}
