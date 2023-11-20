//
//  ContentView.swift
//  Weather
//
//  Created by Benjamin LEFRANCOIS on 17/11/2023.
//

import SwiftUI

// MARK: Content view

struct HomeView: View {

    @StateObject var weather = WeatherManager()
    @State private var showingCityAlert = false
    @State private var city = "paris"

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    CurrentDayView()
                    WeatherForecastScrollView()
                    Spacer()
                    WeatherButton(title: "Change city") {
                        showingCityAlert.toggle()
                    }
                }
            }
            .onAppear {
                self.changeCity()
            }
            .environmentObject(weather)
            .alert("Enter your city", isPresented: $showingCityAlert) {
                TextField("My city", text: $city).submitLabel(.done)
                Button("Ok", action: changeCity)
                Button("Cancel", role: .cancel) {}
            }
        }
        .tint(Color("color_button"))
    }

    func changeCity() {
        if city != "" {
            weather.loadWeatherData(forCity: city.lowercased(), forecastCount: 5)
        }
    }
}

// MARK: Preview

#Preview {
    HomeView()
}

// MARK: Background

struct BackgroundView: View {

    @EnvironmentObject var weather: WeatherManager
    let dayColor = Color("color_lightBlue")

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [weather.weatherData.current.is_day == 1 ? .blue : .black,
                                                   weather.weatherData.current.is_day == 1 ? dayColor : .gray]),
                       startPoint: .topLeading,
                       endPoint: .bottomLeading)
        .ignoresSafeArea(edges: .all)
    }
}

// MARK: Current day

struct CurrentDayView: View {

    @EnvironmentObject var weather: WeatherManager

    var body: some View {
        VStack {
            // city
            Text(weather.weatherData.location.name)
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(.white)
            // region
            Text(weather.weatherData.location.region)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
            // country
            Text(weather.weatherData.location.country.uppercased())
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .padding(.bottom)
            // current weather
            VStack(spacing: 10) {
                Image(uiImage: UIImage(named: weather.weatherData.current.condition.icon)!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64)
                Text("\(Int(round(weather.weatherData.current.temp_c)))°")
                    .font(.system(size: 70, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
        .padding(40)
    }
}

// MARK: Weather forecast

struct WeatherForecastView: View {

    let weatherForecast: WeatherForecast

    var body: some View {
        VStack {
            Text(weatherForecast.shortDayName)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
            Image(uiImage: UIImage(named: weatherForecast.image)!)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(Int(round(weatherForecast.average)))°")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}

struct WeatherForecastScrollView: View {

    @EnvironmentObject var weather: WeatherManager

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(weather.weatherForecasts, id: \.id) { forecast in
                        NavigationLink {
                            DetailView(weatherForecast: forecast)
                        } label: {
                            WeatherForecastView(weatherForecast: forecast)
                        }
                    }
                }
                .padding()
                .frame(width: geometry.size.width)
            }
        }
    }
}
