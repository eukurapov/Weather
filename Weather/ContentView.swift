//
//  ContentView.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var cityCollection: CityStore
    
    @Environment(\.editMode) var editMode
    
    @State var showCitySearch: Bool = false
    
    // fix for Navigaitionview being disabled after editor is closed by button
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cityCollection.cities) { city in
                    CityWeather(city: city)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        self.cityCollection.cities.remove(at: index)
                    }
                }
                .onMove { indexSet, index in
                    self.cityCollection.cities.move(fromOffsets: indexSet, toOffset: index)
                }
            }
        .navigationBarTitle("Weather")
        .navigationBarItems(leading: EditButton(),
                            trailing: Button(
                                action: {
                                    self.showCitySearch = true
                            },
                                label: {
                                    Image(systemName: "plus").imageScale(.large)
                            }))
        }
        .sheet(isPresented: $showCitySearch) {
            CitySearch(isShown: self.$showCitySearch) { searchResult in
                DispatchQueue.main.async {
                    self.cityCollection.cities.append(City(name: searchResult))
                }
            }
        }
    }
}




















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let cityCollection = CityStore()
        return ContentView(cityCollection: cityCollection)
    }
}
