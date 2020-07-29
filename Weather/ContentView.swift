//
//  ContentView.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var weatherFetcher: WeatherFetcher
    
    @Environment(\.editMode) var editMode
    
    @State var showCitySearch: Bool = false
    
    // fix for Navigaitionview being disabled after editor is closed by button
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
         NavigationView {
            List {
                ForEach(weatherFetcher.locations) { location in
                    CityWeather(location: location)
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
                            self.weatherFetcher.fetchLocations()
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
            CitySearch(isShown: self.$showCitySearch) { searchResult in
                self.weatherFetcher.locations.append(searchResult)
            }
            .environmentObject(self.weatherFetcher)
        }
        .onAppear {
            // self.weatherFetcher.fetchLocations(for: "Moscow")
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        self.weatherFetcher.locations.move(fromOffsets: source, toOffset: destination)
    }
    
    private func remove(at offsets: IndexSet) {
        self.weatherFetcher.locations.remove(atOffsets: offsets)
    }
    
}




















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let weatherFetcher = WeatherFetcher()
        return ContentView(weatherFetcher: weatherFetcher)
    }
}
