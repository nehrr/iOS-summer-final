//
//  AppDelegate.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMapsBase
import GooglePlaces
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var myCity: City?
    let APIKey = "AIzaSyBw_jfQrqEXjInw5fr-Hj8dSyNNcwQo42I"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSPlacesClient.provideAPIKey(APIKey)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.scheme == "cloudy"
        {
            if let userDefaults = UserDefaults(suiteName: "group.nehrr.TodayExtensionSharingDefaults") {
                let cityName = userDefaults.string(forKey: "cityName")
                let latitude = userDefaults.double(forKey: "latitude")
                let longitude = userDefaults.double(forKey: "longitude")
                if let name = cityName {
                    let coords = CLLocationCoordinate2DMake(latitude, longitude)
                    myCity = City(name: name, coordinates: coords)
                }
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let detailController: DetailsViewController = storyboard.instantiateViewController(withIdentifier: "Details") as! DetailsViewController
            detailController.aCity = myCity
            
            //tried to make it add to cities array + center on it but it won't work ¯\_(ツ)_/¯
//            let mainController: MainViewController = storyboard.instantiateViewController(withIdentifier: "Map") as! MainViewController
////            mainController.myCity = myCity
//            if let aCity = myCity {
//                mainController.cities.append(aCity)
//                let center = CLLocationCoordinate2D(latitude: aCity.coordinates.latitude, longitude: aCity.coordinates.longitude)
//                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
//                if let map = mainController.mapView {
//                map.setRegion(region, animated: false)
//                }
//            }
            
            (self.window?.rootViewController as! UINavigationController).pushViewController(detailController, animated: true)
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

