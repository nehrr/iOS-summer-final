//
//  ViewController.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func openMenu() {
        let bool: Bool = tableView.isHidden
        tableView.isHidden = !bool
    }
    
    var myCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "aCell")
        
        for coords in CitiesData.list {
            let pin = MKPointAnnotation()
            pin.coordinate = coords.coordinates
            pin.title = coords.name
            mapView.addAnnotation(pin)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath) as! CityTableViewCell
        let city = CitiesData.list[indexPath.row]
        cell.configure(name: city.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CitiesData.list.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "toDetailsFromCell", sender: indexPath.row)
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
        
        if segue.identifier == "toDetailsFromCell" {
            if let destinationVC = segue.destination as? DetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.aCity = CitiesData.list[indexPath.row]
            }
        }
    }
    
    
}

