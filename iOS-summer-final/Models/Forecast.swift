//
//  Forecast.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit
import SwiftyJSON

class Forecast {
    var icon: String?
    var temperature: Double?
    var summary: String?
    var extra: [(String, Double, String, Double)] = []
    var hourlyForecast: HourlyForecast?
    var dailyForecast: DailyForecast?
    
    init(json: JSON) {
        self.icon = json["currently"]["icon"].stringValue
        self.temperature = json["currently"]["temperature"].doubleValue
        self.summary = json["currently"]["summary"].stringValue
        
        self.extra.append(("Humidity", json["currently"]["humidity"].doubleValue, "Wind Speed", json["currently"]["windSpeed"].doubleValue))
        self.extra.append(("Pressure", json["currently"]["pressure"].doubleValue, "UV Index", json["currently"]["uvIndex"].doubleValue))
    }
    
}
