//
//  HourlyForecastTableViewCell.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit

class HourlyForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    func configure(withData data: (String, String, String, String)) {
        let date = Date(timeIntervalSince1970: Double(data.0)!)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"
        let time = timeFormatter.string(from: date)
        
        var humidity = Double(data.2)! * 100
        humidity.round()
        var temp = Double(data.3)!
        temp.round()
        
        self.time.text = time
        self.humidity.text = String(format: "%.0f", humidity) + "%"
        self.temperature.text = String(format: "%.0f", temp) + "°C"
        self.icon.image = UIImage(named: data.1)
    }
    
}
