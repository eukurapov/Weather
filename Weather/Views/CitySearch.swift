//
//  CitySearch.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI

struct CitySearch: View {
    
    @Binding var isShown: Bool
    var onTap: (_ searchResult: String) -> ()
    
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
            TextField("Type city name for search", text: $searchText)
                .padding(.horizontal)
            List {
                HStack {
                    Text(searchText)
                    Spacer()
                }
                .onTapGesture {
                    self.onTap(self.searchText)
                    self.isShown = false
                }
            }
        }
    }
    
}
