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
    var dailyForecast: [(time: String, icon: String, maxTemp: String, minTemp: String)] = []
    
    init(json: JSON) {
        self.dailySummary = json["daily"]["summary"].stringValue
        for dailyData in json["daily"]["data"].arrayValue {
            self.dailyForecast.append((time: dailyData["time"].stringValue,
                                       icon: dailyData["icon"].stringValue,
                                       maxTemp: dailyData["temperatureMax"].stringValue,
                                       minTemp: dailyData["temperatureMin"].stringValue))
        }
    }

}
