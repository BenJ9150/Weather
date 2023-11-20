//
//  WeatherApi.swift
//  Weather
//
//  Created by Benjamin LEFRANCOIS on 17/11/2023.
//

import Foundation

final class WeatherApi {

    // MARK: Private properties

    private let startOfUrl = "https://api.weatherapi.com/v1/forecast.json?"
    private let tokenKey = "key="
    private let cityKey = "&q="
    private let daysKey = "&days="
    private let endOfUrl = "&aqi=no&alerts=no"

    // MARK: Singleton

    static let shared = WeatherApi()
    private init() {}
}

// MARK: Get weather data

extension WeatherApi {

    func getWeatherData(city: String, forecastCount: Int, completionHandler: @escaping (WeatherData) -> Void) {
        if city == "" {
            completionHandler(WeatherData())
            return
        }
        guard let url = URL(string: startOfUrl + tokenKey + AppSettings.weatherApiToken + cityKey + city + daysKey + String(forecastCount) + endOfUrl) else {
            completionHandler(WeatherData())
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completionHandler(WeatherData())
                return
            }
            DispatchQueue.main.async {
                completionHandler(self.parse(data: data, forecastCount: forecastCount))
            }
        }
        task.resume()
    }

    private func parse(data: Data?, forecastCount: Int) -> WeatherData {
        if let data = data, var currentDay = try? JSONDecoder().decode(WeatherData.self, from: data) {
            // change icon of current day
            currentDay.current.condition.icon =
            getImageName(url: currentDay.current.condition.icon, isDay: currentDay.current.is_day)
            // change icon of forecast days
            var index = 0
            while index < forecastCount {
                currentDay.forecast.forecastday[index].day.condition.icon =
                getImageName(url: currentDay.forecast.forecastday[index].day.condition.icon, isDay: 1)
                index += 1
            }
            return currentDay
        }
        return WeatherData()
    }
}

// MARK: Get image

extension WeatherApi {

    private func getImageName(url: String, isDay: Int) -> String {
        if url == "" {
            return "error"
        }
        // //cdn.weatherapi.com/weather/64x64/day/116.png
        guard let name = url.split(separator: "/").last else {
            return "error"
        }
        // remove png
        if name.contains(".png") {
            if isDay == 1 {
                return name.replacingOccurrences(of: ".png", with: "")
            } else {
                return "night_" + name.replacingOccurrences(of: ".png", with: "")
            }
        }
        return "error"
    }
}
