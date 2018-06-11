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
    var cities = CitiesData.list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logo-cloudy")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.tableView.tableFooterView = UIView()
        tableView.isHidden = true
        searchBar.isHidden = true
        
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "aCell")
        
        for coords in cities {
            let pin = MKPointAnnotation()
            pin.coordinate = coords.coordinates
            pin.title = coords.name
            mapView.addAnnotation(pin)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        for coords in cities {
            print(coords.name)
            let pin = MKPointAnnotation()
            
            if !mapView.annotations.contains {$0.coordinate.latitude == coords.coordinates.latitude && $0.coordinate.longitude == coords.coordinates.longitude} {
                pin.coordinate = coords.coordinates
                pin.title = coords.name
                mapView.addAnnotation(pin)
            }
        }
        
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath) as! CityTableViewCell
        let city = cities[indexPath.row]
        cell.configure(name: city.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "toDetailsFromCell", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = cities[indexPath.row]
            self.cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let annot = mapView.annotations.first(where: {$0.title == city.name})
            if let annotation = annot {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let city = view.annotation {
            myCity = City(name: city.title as! String, coordinates: city.coordinate)
            performSegue(withIdentifier: "toDetails", sender: self)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = false
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "pin")
        annotationView!.image = pinImage
        
        return annotationView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            if let destinationVC = segue.destination as? DetailsViewController {
                destinationVC.aCity = myCity
            }
        }
        
        if segue.identifier == "toDetailsFromCell" {
            if let destinationVC = segue.destination as? DetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.aCity = cities[indexPath.row]
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
                    
                    if !self.cities.contains(where: {$0.name == aCity.name}) {
                        self.cities.append(aCity)
                    }
                    self.performSegue(withIdentifier: "toDetailsFromSearch", sender: self)
                }
            }
        }
    }
    
}

