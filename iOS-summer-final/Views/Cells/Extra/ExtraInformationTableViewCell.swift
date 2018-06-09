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

    func configure(withData data: (String, String, String, String)) {
        self.type1.text = data.0
        self.data1.text = data.1
        self.type2.text = data.2
        self.data2.text = data.3
    }
    
}
