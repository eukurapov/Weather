//
//  CitySearch.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI

struct CitySearch: View {
    
    @EnvironmentObject var weatherFetcher: WeatherFetcher
    @Binding var isShown: Bool
    var onTap: (_ searchResult: OWLocation) -> ()
    
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                Text("Search").font(.headline)
                HStack {
                    Spacer()
                    Button("Done") {
                        self.isShown = false
                    }
                }
            }
            .padding()
            HStack {
                TextField("Type city name for search", text: $searchText)
                Spacer()
                Button(
                    action: {
                        self.weatherFetcher.findLocations(for: self.searchText)
                },
                    label: {
                        Image(systemName: "magnifyingglass")
                })
            }
            .padding(.horizontal)
            List {
                ForEach(weatherFetcher.searchResults, id: \.id) { location in
                    CityWeather(location: location)
                        .onTapGesture {
                            self.onTap(location)
                            self.weatherFetcher.searchResults.removeAll()
                            self.isShown = false
                        }
                }
            }
        }
    }
    
}

struct CitySearch_Previews: PreviewProvider {
    static var previews: some View {
        CitySearch(isShown: Binding<Bool>.constant(true), onTap: { _ in return })
        .environmentObject(WeatherFetcher())
    }
}
