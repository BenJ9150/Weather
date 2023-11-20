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
                let weatherForecast = WeatherForecast(daysName: self.getNameOfDay(addedDays: dayIndex),
                                                      image: forecastDay.day.condition.icon,
                                                      temperature: forecastDay.day.avgtemp_c)
                self.weatherForecasts.append(weatherForecast)
                dayIndex += 1
            }
        }
    }
}

// MARK: Get name of days

extension WeatherManager {

    private func getNameOfDay(addedDays: Int) -> String {
        guard let modifiedDate = Calendar.current.date(byAdding: .day, value: addedDays, to: Date()) else {
            return ""
        }
        return modifiedDate.dayOfWeek()
    }
}

extension Date {

    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self).uppercased()
    }
}
