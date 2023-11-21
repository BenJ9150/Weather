//
//  WeatherApi.swift
//  Weather
//
//  Created by Benjamin LEFRANCOIS on 17/11/2023.
//

import Foundation

final class WeatherApi {

    // MARK: Private properties

    #if JSON_API
    private let startOfUrl = "https://api.weatherapi.com/v1/forecast.json?"
    #else
    private let startOfUrl = "https://api.weatherapi.com/v1/forecast.xml?"
    #endif

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
        guard let url = URL(string: startOfUrl + tokenKey + AppSettings.weatherApiToken
                            + cityKey + city + daysKey + String(forecastCount) + endOfUrl) else {
            completionHandler(WeatherData())
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completionHandler(WeatherData())
                return
            }
            DispatchQueue.main.async {
                #if JSON_API
                completionHandler(self.decode(data: data, forecastCount: forecastCount))
                #else
                completionHandler(self.parse(data: data, forecastCount: forecastCount))
                #endif
            }
        }
        task.resume()
    }
}

// MARK: Decode or parse

extension WeatherApi {

    private func decode(data: Data?, forecastCount: Int) -> WeatherData {
        if let data = data, var weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
            // change icon of current day
            weatherData.current.condition.icon =
            getImageName(url: weatherData.current.condition.icon, isDay: weatherData.current.is_day)
            // change icon of forecast days
            var index = 0
            while index < forecastCount {
                weatherData.forecast.forecastday[index].day.condition.icon =
                getImageName(url: weatherData.forecast.forecastday[index].day.condition.icon, isDay: 1)
                index += 1
            }
            return weatherData
        }
        return WeatherData()
    }

    private func parse(data: Data?, forecastCount: Int) -> WeatherData {
        if let data = data {
            let parser = WeatherXmlParser(data: data)
            if parser.parse() {
                // change icon of current day
                parser.weatherData.current.condition.icon =
                getImageName(url: parser.weatherData.current.condition.icon, isDay: parser.weatherData.current.is_day)
                // change icon of forecast days
                var index = 0
                while index < forecastCount {
                    parser.weatherData.forecast.forecastday[index].day.condition.icon =
                    getImageName(url: parser.weatherData.forecast.forecastday[index].day.condition.icon, isDay: 1)
                    index += 1
                }
                return parser.weatherData
            } else {
                if let error = parser.parserError {
                    print(error)
                } else {
                    print("Failed with unknown reason")
                }
            }
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
