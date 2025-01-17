//
//  LocationListItem.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI

struct LocationListItem: View {
    
    var location: Location
    
    @State var iconImage: UIImage?
    @State var flagImage: UIImage?
    @State var loading = false
    
    private var dateFormatter: RelativeDateTimeFormatter {
        let dateFormatter = RelativeDateTimeFormatter()
        dateFormatter.dateTimeStyle = .named
        dateFormatter.unitsStyle = .short
        return dateFormatter
    }
    
    var body: some View {
        HStack {
            Group {
                if iconImage != nil {
                    Image(uiImage: iconImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.large)
                        .rotationEffect(Angle(degrees: loading ? 360 : 0))
                        .animation(Animation.linear.repeatForever(autoreverses: false))
                }
            }
            .frame(width: 50)
            VStack {
                HStack {
                    Text(location.name).font(.headline)
                    if flagImage != nil {
                        Image(uiImage: flagImage!)
                            .fixedSize()
                    }
                    if location.isCurrent {
                        Image(systemName: "location.circle.fill").imageScale(.small)
                    }
                    Spacer()
                    Text(dateFormatter.localizedString(for: location.lastUpdated, relativeTo: Date()))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("\(String(format: "%.2f", location.weather?.temp ?? 0))°C")
                        .font(Font.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 2)
                        .background(RoundedRectangle(cornerRadius: 3))
                    HStack {
                        Text(location.weather?.condition ?? "")
                        Spacer()
                        HStack {
                            Image(systemName: "location.north")
                                .imageScale(.small)
                                .rotationEffect(Angle(degrees: Double(location.weather?.windDegree ?? 0)))
                            Text(String(format: "%.1f", location.weather?.windSpeed ?? 0))
                        }
                        .padding(.leading, 10)
                    }
                    .font(Font.footnote)
                    .foregroundColor(.gray)
                }
            }
            .padding(.trailing)
            .onAppear() {
                self.loading = true
                self.fetchIconImageData()
                self.fetchFlagImageData()
            }
        }
        .frame(height: 70)
        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 2))
    }
    
    private func fetchIconImageData() {
        iconImage = nil
        if let url = self.location.weather?.conditionIconURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.location.weather?.conditionIconURL {
                            self.iconImage = UIImage(data: imageData)
                            self.loading = false
                        }
                    }
                }
            }
        }
    }
    
    private func fetchFlagImageData() {
        flagImage = nil
        if let url = self.location.countryFlagURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.location.countryFlagURL {
                            self.flagImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}
