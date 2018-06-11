//
//  ViewController.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func openMenu() {
        let bool: Bool = tableView.isHidden
        tableView.isHidden = !bool
    }
    @IBAction func openSearch() {
        let bool: Bool = searchBar.isHidden
        searchBar.isHidden = !bool
    }
    
    var myCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        tableView.isHidden = true
        searchBar.isHidden = true
        
        searchBar.barTintColor = UIColor.red
        
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "aCell")
        
        for coords in CitiesData.list {
            let pin = MKPointAnnotation()
            pin.coordinate = coords.coordinates
            pin.title = coords.name
            mapView.addAnnotation(pin)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
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
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        if segue.identifier == "toDetailsFromSearch" {
            if let destinationVC = segue.destination as? DetailsViewController {
                destinationVC.aCity = myCity
            }
        }
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            completion(placemarks?.first?.location?.coordinate, error)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            getCoordinateFrom(address: text) { coordinate, error in
                if let coordinate = coordinate {

                    let aCity = City(name: text, coordinates: coordinate)
                    self.myCity = aCity
                    
                    if !CitiesData.list.contains(where: {$0.name == aCity.name}) {
                        CitiesData.list.append(aCity)
                    }
                    self.performSegue(withIdentifier: "toDetailsFromSearch", sender: self)
                }
            }
        }
    }
    
}

