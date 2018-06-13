//
//  HeaderTableViewCell.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var currentForecast: UILabel!
    
    func configure(temp: Double, current: String, icon: String) {
        var temp = temp
        temp.round()
        
        self.icon.image = UIImage(named: icon)
        self.tempLabel.text = String(format: "%.0f", temp) + "°C"
        self.currentForecast.text = current
    }
    
}
