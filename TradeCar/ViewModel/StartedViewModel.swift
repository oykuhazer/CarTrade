//
//  StartedViewModel.swift
//  TradeCar
//
//  Created by Öykü Hazer Ekinci on 25.10.2023.
//

import Foundation

class StartedViewModel {
    // The data model for the Car Trade app.
    let carTradeData: CarTradeData

    init() {
        // Initialize the CarTradeData model with a welcome message and a video URL.
        carTradeData = CarTradeData(welcomeText: "Welcome to the Car Trade\nAutomotive World!", videoURL: URL(string: "https://www.youtube.com/embed/9rx7-ec0p0A")!)
    }
}
