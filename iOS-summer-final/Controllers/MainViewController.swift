//
//  ViewController.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var myCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for coords in CitiesData.list {
            let pin = MKPointAnnotation()
            pin.coordinate = coords.coordinates
            pin.title = coords.name
            mapView.addAnnotation(pin)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let city = view.annotation {
            myCity = City(name: city.title as! String, coordinates: city.coordinate)
            performSegue(withIdentifier: "toDetails", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            if let destinationVC = segue.destination as? DetailsViewController {
                destinationVC.aCity = myCity
            }
        }
    }
    
    
}

