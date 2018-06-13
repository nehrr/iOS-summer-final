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
    var temperature: String?
    var summary: String?
    var extra: [(String, String, String, String)] = []
    var hourlyForecast: HourlyForecast?
    var dailyForecast: DailyForecast?
    
    init(json: JSON) {
        self.icon = json["currently"]["icon"].stringValue
        self.temperature = json["currently"]["temperature"].stringValue
        self.summary = json["currently"]["summary"].stringValue
        
        self.extra.append(("Humidity", json["currently"]["humidity"].stringValue, "Wind Speed", json["currently"]["windSpeed"].stringValue))
        self.extra.append(("Pressure", json["currently"]["pressure"].stringValue, "UV Index", json["currently"]["uvIndex"].stringValue))
    }
    
}
