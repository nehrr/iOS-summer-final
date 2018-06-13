//
//  ExtraInformationTableViewCell.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit

class ExtraInformationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var type1: UILabel!
    @IBOutlet weak var data1: UILabel!
    @IBOutlet weak var type2: UILabel!
    @IBOutlet weak var data2: UILabel!

    func configure(withData data: (String, Double, String, Double)) {
        self.type1.text = data.0
        
        if data.0 == "Humidity" {
            var humidity = data.1 * 100
            humidity.round()
            self.data1.text = String(format: "%.0f", humidity) + "%"
        }
        
        if data.0 == "Pressure" {
            var pressure = data.1
            pressure.round()
            self.data1.text = String(format: "%.0f", pressure) + " hPa"
        }
        
        self.type2.text = data.2
        
        if data.2 == "Wind Speed"{
            var speed = data.3
            speed.round()
            self.data2.text = String(format: "%.0f", speed) + " km/h"
        }
        
        if data.2 == "UV Index" {
            self.data2.text = String(format: "%.0f", data.3)
        }
        
    }
    
}
