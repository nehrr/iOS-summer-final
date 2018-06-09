//
//  City.swift
//  Efreitech - Final
//
//  Created by Pierre-Yves Touzain on 11/05/2018.
//  Copyright © 2018 TYP Studio. All rights reserved.
//

import Foundation
import CoreLocation

struct City {
    var name: String
    var coordinates: CLLocationCoordinate2D
//    var forecast: Forecast?
    
    init(name: String, coordinates: CLLocationCoordinate2D) {
        self.name = name
        self.coordinates = coordinates
    }
}
