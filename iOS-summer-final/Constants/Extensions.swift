//
//  Extensions.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

extension UIColor {
    static let night = UIColor(red:0.09, green:0.27, blue:0.44, alpha:1.0)
    static let day = UIColor(red:0.64, green:0.85, blue:0.94, alpha:1.0)
    static let overcast = UIColor(red:0.76, green:0.82, blue:0.91, alpha:1.0)
    static let rainy = UIColor(red:0.85, green:0.93, blue:0.98, alpha:1.0)
    static let snow = UIColor(red:0.76, green:0.82, blue:0.91, alpha:1.0)
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
        
        UIImageView.animate(withDuration: 3) {
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

extension UIViewController {
    func doAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in switch action.style {
            case .default:
                print("default")
                self.navigationController?.popToRootViewController(animated: true)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        
        if let adress = place.formattedAddress {
            self.getCoordinateFrom(address: adress) { coordinate, error in
                if let coordinate = coordinate {
                    
                    let aCity = City(name: place.name, coordinates: coordinate)
                    self.myCity = aCity
                    
                    if !self.cities.contains(where: {$0.name == aCity.name}) {
                        self.cities.append(aCity)
                    }
                    self.performSegue(withIdentifier: "toDetailsFromSearch", sender: self)
                }
                
                if error != nil {
                    self.doAlert(title: "Error", message: "This city does not exist!")
                }
            }
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.doAlert(title: "Error", message: "Could not autocomplete :(")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
