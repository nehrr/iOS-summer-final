//
//  Forecast.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit

class Forecast {
    var icon: String?
    var temperature: String?
    var summary: String?
    var windSpeed: String?
    var pressure: String?
    var humidity: String?
    var UVIndex: String?
    var hourlySummary: String?
    var dailySummary: String?
    var hourlyForecast: [(time: String, icon: String, humidity: String, temperature: String)]?
    var dailyForecast: [(time: String, icon: String, humidity: String, temperature: String)]?
    
    init() {
    }
    
}
