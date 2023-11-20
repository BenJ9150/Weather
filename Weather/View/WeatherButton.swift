//
//  WeatherButton.swift
//  Weather
//
//  Created by Benjamin LEFRANCOIS on 17/11/2023.
//

import SwiftUI

struct WeatherButton: View {

    let title: String
    let action: (() -> Void)

    var body: some View {
        Button(title) {
            action()
        }
        .frame(width: 280, height: 50)
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .font(.system(size: 20, weight: .bold))
        .foregroundStyle(.white)
        .padding(.bottom)
    }
}
