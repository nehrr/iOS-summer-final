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
    var windSpeed: String?
    var pressure: String?
    var humidity: String?
    var UVIndex: String?
    var hourlySummary: String?
    var dailySummary: String?
    var hourlyForecast: [(time: String, icon: String, humidity: String, temperature: String)] = []
    var dailyForecast: [(time: String, icon: String, maxTemp: String, minTemp: String)] = []
    
    init(json: JSON) {
        
        self.icon = json["currently"]["icon"].stringValue
        self.temperature = json["currently"]["temperature"].stringValue
        self.summary = json["currently"]["summary"].stringValue
        self.windSpeed = json["currently"]["windSpeed"].stringValue
        self.pressure = json["currently"]["pressure"].stringValue
        self.humidity = json["currently"]["humidity"].stringValue
        self.UVIndex = json["currently"]["uvIndex"].stringValue
        
        self.hourlySummary = json["hourly"]["summary"].stringValue
        self.dailySummary = json["daily"]["summary"].stringValue
        
        for hourlyData in json["hourly"]["data"].arrayValue {
            self.hourlyForecast.append((time: hourlyData["time"].stringValue,
                                         icon: hourlyData["icon"].stringValue,
                                         humidity: hourlyData["humidity"].stringValue,
                                         temperature: hourlyData["temperature"].stringValue))
            
        }
        
        for dailyData in json["daily"]["data"].arrayValue {
            self.dailyForecast.append((time: dailyData["time"].stringValue,
                                        icon: dailyData["icon"].stringValue,
                                        maxTemp: dailyData["temperatureMax"].stringValue,
                                        minTemp: dailyData["temperatureMin"].stringValue))
            
        }
        
        print(self.dailyForecast)
        print(self.hourlyForecast)
    }
    
}
