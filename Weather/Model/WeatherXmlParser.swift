//
//  WeatherXmlParser.swift
//  Weather
//
//  Created by Benjamin LEFRANCOIS on 20/11/2023.
//

import Foundation

class WeatherXmlParser: XMLParser {

    // MARK: Public property

    var weatherData = WeatherData()

    // MARK: Private properties

    private var textBuffer: String = ""
    private var nextForecastday: Forecastday?

    // MARK: Init

    override init(data: Data) {
        super.init(data: data)
        self.delegate = self
    }
}

// MARK: XML Parser Delegate

extension WeatherXmlParser: XMLParserDelegate {

    // swiftlint:disable cyclomatic_complexity

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        switch elementName {
        case "day":
            nextForecastday = Forecastday()
        case "name":
            textBuffer = ""
        case "region":
            textBuffer = ""
        case "country":
            textBuffer = ""
        case "is_day":
            textBuffer = ""
        case "temp_c":
            textBuffer = ""
        case "maxtemp_c":
            textBuffer = ""
        case "mintemp_c":
            textBuffer = ""
        case "avgtemp_c":
            textBuffer = ""
        case "maxwind_kph":
            textBuffer = ""
        case "totalprecip_mm":
            textBuffer = ""
        case "icon":
            textBuffer = ""
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {

        switch elementName {
        case "day":
            if let forecastday = nextForecastday {
                weatherData.forecast.forecastday.append(forecastday)
                nextForecastday = nil
            }
        case "name":
            weatherData.location.name = textBuffer
        case "region":
            weatherData.location.region = textBuffer
        case "country":
            weatherData.location.country = textBuffer
        case "is_day":
            if let value = Int(textBuffer) {
                weatherData.current.is_day = value
            }
        case "temp_c":
            if let value = Double(textBuffer) {
                weatherData.current.temp_c = value
            }
        case "maxtemp_c":
            if let value = Double(textBuffer), nextForecastday != nil {
                nextForecastday!.day.maxtemp_c = value
            }
        case "mintemp_c":
            if let value = Double(textBuffer), nextForecastday != nil {
                nextForecastday!.day.mintemp_c = value
            }
        case "avgtemp_c":
            if let value = Double(textBuffer), nextForecastday != nil {
                nextForecastday!.day.avgtemp_c = value
            }
        case "maxwind_kph":
            if let value = Double(textBuffer), nextForecastday != nil {
                nextForecastday!.day.maxwind_kph = value
            }
        case "totalprecip_mm":
            if let value = Double(textBuffer), nextForecastday != nil {
                nextForecastday!.day.totalprecip_mm = value
            }
        case "icon":
            if nextForecastday != nil {
                nextForecastday!.day.condition.icon = textBuffer
            } else {
                weatherData.current.condition.icon = textBuffer
            }
        default:
            break
        }
    }

    // swiftlint:enable cyclomatic_complexity

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        textBuffer += string
    }

    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        guard let string = String(data: CDATABlock, encoding: .utf8) else {
            print("CDATA contains non-textual data, ignored")
            return
        }
        textBuffer += string
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        print("on:", parser.lineNumber, "at:", parser.columnNumber)
    }
}
