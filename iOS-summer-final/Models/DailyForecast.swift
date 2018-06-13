//
//  DailyForecast.swift
//  iOS-summer-final
//
//  Created by Ernoul on 13/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit
import SwiftyJSON

class DailyForecast {
    
    var dailySummary: String?
    var dailyForecast: [(time: Double, icon: String, maxTemp: Double, minTemp: Double)] = []
    
    init(json: JSON) {
        self.dailySummary = json["daily"]["summary"].stringValue
        for dailyData in json["daily"]["data"].arrayValue {
            self.dailyForecast.append((time: dailyData["time"].doubleValue,
                                       icon: dailyData["icon"].stringValue,
                                       maxTemp: dailyData["temperatureMax"].doubleValue,
                                       minTemp: dailyData["temperatureMin"].doubleValue))
        }
    }

}
