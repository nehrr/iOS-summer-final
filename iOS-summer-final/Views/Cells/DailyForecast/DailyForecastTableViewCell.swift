//
//  DailyForecastTableViewCell.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    
    func configure(withData data: (Double, String, Double, Double)) {
        let date = Date(timeIntervalSince1970: data.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: date)
        
        var maxTemp = data.2
        maxTemp.round()
        var minTemp = data.3
        minTemp.round()

        self.day.text = day
        self.maxTemp.text = String(format: "%.0f", maxTemp) + "°C"
        self.minTemp.text = String(format: "%.0f", minTemp) + "°C"
        self.icon.image = UIImage(named: data.1)
    }
    
}
