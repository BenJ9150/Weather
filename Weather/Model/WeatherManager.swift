//
//  WeatherManager.swift
//  Weather
//
//  Created by Benjamin LEFRANCOIS on 18/11/2023.
//

import Foundation

final class WeatherManager: ObservableObject {

    // MARK: Public property

    @Published var weatherData = WeatherData()
    @Published var weatherForecasts = [WeatherForecast]()
}

// MARK: Public method

extension WeatherManager {

    func loadWeatherData(forCity city: String, forecastCount: Int) {
        WeatherApi.shared.getWeatherData(city: city, forecastCount: forecastCount) { result in
            // update weather data
            self.weatherData = result
            // update forecast
            self.weatherForecasts.removeAll()
            var dayIndex = 1
            for forecastDay in result.forecast.forecastday {
                // create new forecast
                let weatherForecast = WeatherForecast(dayName: self.getNameOfDay(addedDays: dayIndex, short: false),
                                                      shortDayName: self.getNameOfDay(addedDays: dayIndex, short: true),
                                                      image: forecastDay.day.condition.icon,
                                                      average: forecastDay.day.avgtemp_c,
                                                      minTemp: forecastDay.day.mintemp_c,
                                                      maxTemp: forecastDay.day.maxtemp_c,
                                                      maxWind: forecastDay.day.maxwind_kph,
                                                      precip: forecastDay.day.totalprecip_mm)
                // add forecast to array
                self.weatherForecasts.append(weatherForecast)
                dayIndex += 1
            }
        }
    }
}

// MARK: Get name of days

extension WeatherManager {

    private func getNameOfDay(addedDays: Int, short: Bool) -> String {
        guard let modifiedDate = Calendar.current.date(byAdding: .day, value: addedDays, to: Date()) else {
            return ""
        }
        return modifiedDate.dayOfWeek(short: short)
    }
}

extension Date {

    func dayOfWeek(short: Bool) -> String {
        let dateFormatter = DateFormatter()
        if short {
            dateFormatter.dateFormat = "EE"
        } else {
            dateFormatter.dateFormat = "EEEE"
        }
        return dateFormatter.string(from: self).uppercased()
    }
}
