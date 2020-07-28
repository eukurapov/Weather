//
//  CityWeather.swift
//  Weather
//
//  Created by Eugene Kurapov on 17.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import SwiftUI

struct CityWeather: View {
    
    var location: OWLocation
    
    @State var iconImage: UIImage?
    @State var flagImage: UIImage?
    @State var loading = false
    
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
                    Spacer()
                }
                HStack {
                    Text("\(String(format: "%.2f", location.main.temp))°C")
                        .font(Font.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 2)
                        .background(RoundedRectangle(cornerRadius: 3))
                    HStack {
                        Text(location.weather.first?.description ?? "")
                        Spacer()
                        HStack {
                            Image(systemName: "location.north")
                                .imageScale(.small)
                                .rotationEffect(Angle(degrees: Double(location.wind.deg)))
                            Text(String(format: "%.1f", location.wind.speed))
                        }
                        .padding(.leading, 10)
                    }
                    .font(Font.footnote)
                    .foregroundColor(.gray)
                }
            }
            .onAppear() {
                self.loading = true
                self.fetchIconImageData()
                self.fetchFlagImageData()
            }
        }
        .frame(height: 50)
    }
    
    private func fetchIconImageData() {
        iconImage = nil
        if let url = self.location.weather.first?.iconUrl {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.location.weather.first?.iconUrl {
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
        if let url = self.location.sys.flagIconUrl {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.location.sys.flagIconUrl {
                            self.flagImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}
