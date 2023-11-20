//
//  DetailView.swift
//  Weather
//
//  Created by Benjamin LEFRANCOIS on 20/11/2023.
//

import SwiftUI

struct DetailView: View {

    let weatherForecast: WeatherForecast

    var body: some View {
        ZStack {
            BackgroundDetailView()
            DayDetailView(weatherForecast: weatherForecast)
        }
    }
}

// MARK: Preview

struct ContentView_Previews: PreviewProvider {
    static let weatherForecast = WeatherForecast(dayName: "monday",
                                                 shortDayName: "mon",
                                                 image: "113",
                                                 average: 12.0,
                                                 minTemp: 10.0,
                                                 maxTemp: 14.0,
                                                 maxWind: 120.0,
                                                 precip: 0.0)
    static var previews: some View {
        DetailView(weatherForecast: weatherForecast)
    }
}

// MARK: Background

struct BackgroundDetailView: View {

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.blue, Color("color_lightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomLeading)
        .ignoresSafeArea(edges: .all)
    }
}

// MARK: Detail view

struct DayDetailView: View {

    let weatherForecast: WeatherForecast

    var body: some View {
        VStack {
            // day name
            Text(weatherForecast.dayName)
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(.white)
            // image
            Image(uiImage: UIImage(named: weatherForecast.image)!)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 64)
                .padding()
            // Average
            DetailLine(title: "Average", value: weatherForecast.average, unit: "°")
            DetailLine(title: "Min", value: weatherForecast.minTemp, unit: "°")
            DetailLine(title: "Max", value: weatherForecast.maxTemp, unit: "°")
            DetailLine(title: "Max wind", value: weatherForecast.maxWind, unit: " km/h")
            DetailLine(title: "Precipitation", value: weatherForecast.precip, unit: " mm")
        }
        .padding(40)
    }
}

struct DetailLine: View {

    let title: String
    let value: Double
    let unit: String

    var body: some View {
        HStack {
            Text(title + ":")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
            Text("\(Int(round(value)))" + unit)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.bottom, 1)
    }
}
