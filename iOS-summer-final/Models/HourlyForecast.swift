//
//  HourlyForecast.swift
//  iOS-summer-final
//
//  Created by Ernoul on 13/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit
import SwiftyJSON

class HourlyForecast {
    
    var hourlySummary: String?
    var hourlyForecast: [(time: Double, icon: String, humidity: Double, temperature: Double)] = []
    
    init(json: JSON) {
        self.hourlySummary = json["hourly"]["summary"].stringValue
        for hourlyData in json["hourly"]["data"].arrayValue {
            self.hourlyForecast.append((time: hourlyData["time"].doubleValue,
                                        icon: hourlyData["icon"].stringValue,
                                        humidity: hourlyData["humidity"].doubleValue,
                                        temperature: hourlyData["temperature"].doubleValue))
            
        }
    }

}
