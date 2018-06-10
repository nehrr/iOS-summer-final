//
//  Extensions.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let night = UIColor(red:0.09, green:0.27, blue:0.44, alpha:1.0)
    static let day = UIColor(red:0.64, green:0.85, blue:0.94, alpha:1.0)
}

extension UIView {
    func activityStartAnimating(backgroundColor: UIColor) {
        let screenSize: CGRect = UIScreen.main.bounds
        
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        let bgImage = UIImageView.init(image: UIImage(named: "rainbow"))
        bgImage.center.x = backgroundView.center.x
        bgImage.center.y = backgroundView.center.y
        bgImage.contentMode = .scaleAspectFit
        backgroundView.addSubview(bgImage)
        
        UIImageView.animate(withDuration: 1.5) {
            bgImage.alpha = 0
            bgImage.transform = bgImage.transform.rotated(by: CGFloat.pi)
        }
        
        self.isUserInteractionEnabled = false
        
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}
