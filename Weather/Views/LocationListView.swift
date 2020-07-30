//
//  LocationListView.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI
import CoreData

struct LocationListView: View {

    @FetchRequest(fetchRequest: Location.fetchRequest(.all)) var locations: FetchedResults<Location>
    @ObservedObject var weatherFetcher: WeatherFetcher = WeatherFetcher()
    
    @State var showCitySearch: Bool = false
    
    @Environment(\.editMode) var editMode
    // fix for Navigaitionview being disabled after editor is closed by button
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
         NavigationView {
            List {
                ForEach(locations) { location in
                    LocationListItem(location: location)
                    .id(UUID()) // fix for extra animation when moving an item up in a list (see developer.apple.com/forums/thread/133134)
                }
                .onMove(perform: move)
                .onDelete(perform: remove)
            }
            .navigationBarTitle("Weather")
            .navigationBarItems(
                leading: EditButton(),
                trailing: HStack {
                    Button(
                        action: {
                            self.updateLocations()
                    },
                        label: {
                            Image(systemName: "arrow.clockwise")
                                .imageScale(.medium)
                                .padding(.horizontal, 5)
                    })
                    Button(
                        action: {
                            self.showCitySearch = true
                    },
                        label: {
                            Image(systemName: "plus").imageScale(.large)
                    })
            })
        }
        .sheet(isPresented: $showCitySearch) {
            LocationSearch(isShown: self.$showCitySearch) { searchResult in
                Location.from(searchResult, context: self.context)
            }
            .environmentObject(self.weatherFetcher)
        }
        .onAppear {
            self.updateLocations()
        }
    }
    
    private func updateLocations() {
        self.weatherFetcher.fetchLocations(with: self.locations.map( { Int($0.id) } ), in: self.context)
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
