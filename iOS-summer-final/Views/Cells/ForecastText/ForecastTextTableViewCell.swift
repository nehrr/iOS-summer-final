//
//  ForecastTextTableViewCell.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit

class ForecastTextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func configure(text: String) {
        self.label.text = text
    }
    
}
