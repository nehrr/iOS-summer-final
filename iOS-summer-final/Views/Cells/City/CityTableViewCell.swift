//
//  CityTableViewCell.swift
//  iOS-summer-final
//
//  Created by Ernoul on 10/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name: String) {
        self.name.text = name
    }
    
}
