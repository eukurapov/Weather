//
//  LocationSearch.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI

struct LocationSearch: View {
    
    @State var searchText: String = ""
    
    @EnvironmentObject var weatherFetcher: WeatherFetcher
    @Binding var isShown: Bool
    var onTap: (_ searchResult: OWLocation) -> ()
    
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
                TextField("Type full city name for search", text: $searchText)
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
                if weatherFetcher.searchResults.isEmpty && weatherFetcher.searchState == .completed {
                    Text("Could not find a location for your request. Please make sure to input full city name.")
                        .font(.caption)
                } else {
                    ForEach(weatherFetcher.searchResults, id: \.id) { owlocation in
                        HStack {
                            Text("\(owlocation.name), \(owlocation.sys.country)")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.onTap(owlocation)
                            self.weatherFetcher.completeSearch()
                            self.isShown = false
                        }
                    }
                }
            }
        }
    }
    
}

//struct CitySearch_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationSearch(isShown: Binding<Bool>.constant(true), onTap: { _ in return })
//        .environmentObject(WeatherFetcher())
//    }
//}
