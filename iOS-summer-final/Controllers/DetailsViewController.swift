//
//  DetailsViewController.swift
//  iOS-summer-final
//
//  Created by Ernoul on 09/06/2018.
//  Copyright © 2018 Ernoul. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailsViewController: UIViewController, UITableViewDataSource {
 
    var aCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.getData()
        
        if let cityName = aCity?.name {
            navigationItem.title = cityName
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        if let cityLat = aCity?.coordinates.latitude, let cityLong = aCity?.coordinates.longitude {
            var url: String = "https://api.darksky.net/forecast/0d387f3d301b383589fe5b5350cf9a77/\(cityLat),\(cityLong)?units=si"
            print(url)
//            Alamofire.request("google.fr").responseJSON { response in
//                
//                switch response.result {
//                    
//                case .success:
//                    if let value = response.result.value {
//                        let json = JSON(value)
//                        for recipe in json["drinks"].arrayValue {
//                            //                                    self.cocktail?.update(recipe)
//                        }
//                    }
//                    //                            self.tableView.reloadData()
//                    
//                case .failure(let error):
//                    print(error)
//                }
//            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
