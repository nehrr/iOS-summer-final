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
    var windSpeed: Double?
    var pressure: Double?
    var humidity: Double?
    var UVIndex: Double?
    var hourlySummary: String?
    var dailySummary: String?
    var hourlyForecast: [(time: Double, icon: String, humidity: Double, temperature: Double)]?
    var dailyForecast: [(time: Double, icon: String, maxTemp: Double, minTemp: Double)]?
    
    init(json: JSON) {
        for currently in json["currently"].arrayValue {
            self.icon = currently["icon"].stringValue
            self.temperature = currently["temperature"].doubleValue
            self.summary = currently["summary"].stringValue
            self.windSpeed = currently["windSpeed"].doubleValue
            self.pressure = currently["pressure"].doubleValue
            self.humidity = currently["humidity"].doubleValue
            self.UVIndex = currently["uvIndex"].doubleValue
        }
        
        self.hourlySummary = json["hourly"]["summary"].stringValue
        self.dailySummary = json["daily"]["summary"].stringValue
        
        for hourlyData in json["hourly"]["data"].arrayValue {
            self.hourlyForecast?.append((time: hourlyData["time"].doubleValue,
                                         icon: hourlyData["icon"].stringValue,
                                         humidity: hourlyData["humidity"].doubleValue,
                                         temperature: hourlyData["temperature"].doubleValue))
            
        }
        
        for dailyData in json["daily"]["data"].arrayValue {
            self.dailyForecast?.append((time: dailyData["time"].doubleValue,
                                        icon: dailyData["icon"].stringValue,
                                        maxTemp: dailyData["temperatureMax"].doubleValue,
                                        minTemp: dailyData["temperatureMin"].doubleValue))
            
        }
        print(self)
    }
    
}
