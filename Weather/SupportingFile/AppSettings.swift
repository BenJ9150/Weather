//
//  AppSettings.swift
//  Weather
//
//  Created by Benjamin LEFRANCOIS on 20/11/2023.
//

import Foundation

class AppSettings {

    // MARK: Weather API token

    static var weatherApiToken: String = {
        // place the file WeatherApiToken.txt in the SupportingFile directory from Xcode
        // file must appear in Xcode project Navigator
        if let path = Bundle.main.path(forResource: "WeatherApiToken", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                let text = myStrings.joined(separator: "\n")
                return text
            } catch {
                print(error)
            }
        }
        return ""
    }()
}
