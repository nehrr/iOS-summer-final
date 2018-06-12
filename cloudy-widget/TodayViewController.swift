//
//  TodayViewController.swift
//  cloudy-widget
//
//  Created by Ernoul on 12/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var randomLabel: UILabel!
    
    @IBAction func goToApp() {
        self.extensionContext?.open(url as URL, completionHandler: { (success) in
            if (!success) {
                print("error: failed to open app from Today Extension")
            }
        })
    }
    
    let url = NSURL(string: "cloudy://")!
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var city: String?
    let random = ["Is the sun shining today in ",
                  "Will I feel the wind today in ",
                  "I hope I won't see snow today in ",
                  "Will I need my umbrella today in ",
                  "Is it foggy out today in ",
                  "Will I need a coat today in ",
                  "Should I wear shorts today in "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
        
        lookUpCurrentLocation { geoLoc in
            //            if let here = geoLoc?.location?.coordinate {
            //                self.location = here
            //                print(self.location)
            //            }
            
            if let city = geoLoc?.locality {
                self.city = city
                self.cityLabel.text = city
            }
        }
        
        for _ in 0..<random.count {
            let rand = Int(arc4random_uniform(UInt32(random.count)))
            self.randomLabel.text = random[rand]
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let _ = locations.last?.coordinate.latitude, let _ = locations.last?.coordinate.longitude {
            //            print("\(lat),\(long)")
        } else {
            //            print("No coordinates")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                    completionHandler(nil)
                }
            })
        }
        else {
            completionHandler(nil)
        }
    }
}
