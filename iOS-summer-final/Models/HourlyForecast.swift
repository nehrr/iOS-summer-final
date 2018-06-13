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
    var hourlyForecast: [(time: String, icon: String, humidity: String, temperature: String)] = []
    
    init(json: JSON) {
        self.hourlySummary = json["hourly"]["summary"].stringValue
        for hourlyData in json["hourly"]["data"].arrayValue {
            self.hourlyForecast.append((time: hourlyData["time"].stringValue,
                                        icon: hourlyData["icon"].stringValue,
                                        humidity: hourlyData["humidity"].stringValue,
                                        temperature: hourlyData["temperature"].stringValue))
            
        }
    }

}
