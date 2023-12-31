//
//  WeatherApiStruct.swift
//  Weather
//
//  Created by Benjamin LEFRANCOIS on 18/11/2023.
//

import Foundation

struct WeatherData: Decodable {

    var location = Location()
    var current = Current()
    var forecast = Forecast()
}

struct Location: Decodable {

    var name = ""
    var region = ""
    var country = ""
}

struct Current: Decodable {

    // swiftlint:disable identifier_name
    var temp_c = 0.0
    var is_day = 1
    // swiftlint:enable identifier_name
    var condition = Condition()
}

struct Condition: Decodable {

    var icon = "loading"
}

struct Forecast: Decodable {

    var forecastday = [Forecastday]()
}

struct Forecastday: Decodable {

    var day = Day()
}

struct Day: Decodable {

    // swiftlint:disable identifier_name
    var avgtemp_c = 0.0
    var maxtemp_c = 0.0
    var mintemp_c = 0.0
    var maxwind_kph = 0.0
    var totalprecip_mm = 0.0
    // swiftlint:enable identifier_name
    var condition = Condition()
}

struct WeatherForecast: Identifiable {

    let id = UUID()
    let dayName: String
    let shortDayName: String
    let image: String
    let average: Double
    let minTemp: Double
    let maxTemp: Double
    let maxWind: Double
    let precip: Double
}
