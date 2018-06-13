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

class MainViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITabBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBAction func openMenu() {
        let bool: Bool = tableView.isHidden
        tableView.isHidden = !bool
        
        if !searchBar.isHidden {
            searchBar.isHidden = true
            self.view.endEditing(true)
        }
        
        view.endEditing(true)
    }
    @IBAction func openSearch() {
        let bool: Bool = searchBar.isHidden
        searchBar.isHidden = !bool
        
        if !tableView.isHidden {
            tableView.isHidden = true
        }
    }
    @IBAction func getLocation() {
        lookUpCurrentLocation { geoLoc in
            if let cityName = geoLoc?.locality, let coordinates = geoLoc?.location?.coordinate {
                let aCity = City(name: cityName, coordinates: coordinates)
                
                if !self.cities.contains(where: {$0.name == aCity.name}) {
                    self.cities.append(aCity)
                }
                self.myCity = aCity
                
                let center = CLLocationCoordinate2D(latitude: aCity.coordinates.latitude, longitude: aCity.coordinates.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
                self.mapView.setRegion(region, animated: false)
                
                self.performSegue(withIdentifier: "toDetails", sender: self)
            } else {
                self.doAlert(title: "Error", message: "Could not locate you :(")
            }
        }
    }
    
    var myCity: City?
    var cities = CitiesData.list
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if let selected = tabBar.items?[1] {
            tabBar.selectedItem = selected
        }
        
        tabBar.unselectedItemTintColor = UIColor.white
        
        let logo = UIImage(named: "logo-cloudy")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.tableView.tableFooterView = UIView()
        tableView.allowsSelectionDuringEditing = true
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
            let pin = MKPointAnnotation()
            
            if !mapView.annotations.contains {$0.coordinate.latitude == coords.coordinates.latitude && $0.coordinate.longitude == coords.coordinates.longitude} {
                pin.coordinate = coords.coordinates
                pin.title = coords.name
                mapView.addAnnotation(pin)
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.searchBar.isHidden = true
        self.tableView.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath) as! CityTableViewCell
        let city = cities[indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.27, green:0.62, blue:0.98, alpha:1.0)
        cell.selectedBackgroundView = backgroundView
        cell.configure(name: city.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            if let name = city.title {
                if let cityName = name {
                    myCity = City(name: cityName, coordinates: city.coordinate)
                    mapView.deselectAnnotation(city, animated: false)
                    performSegue(withIdentifier: "toDetails", sender: self)
                }
            }
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
                    self.searchBar.endEditing(true)
                    self.performSegue(withIdentifier: "toDetailsFromSearch", sender: self)
                }
                
                if error != nil {
                    self.doAlert(title: "Error", message: "This city does not exist!")
                }
            }
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 0 {
            mapView.mapType = .hybrid
        }
        
        if item.tag == 1 {
            mapView.mapType = .standard
        }
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

