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
    
    @IBOutlet weak var tableView: UITableView!
    
    var aCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "Header")
        tableView.register(UINib(nibName: "ForecastTextTableViewCell", bundle: nil), forCellReuseIdentifier: "HourlyForecastText")
        tableView.register(UINib(nibName: "ForecastTextTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyForecastText")
        tableView.register(UINib(nibName: "HourlyForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "HourlyForecast")
        tableView.register(UINib(nibName: "DailyForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyForecast")
        tableView.register(UINib(nibName: "ForecastTextTableViewCell", bundle: nil), forCellReuseIdentifier: "ExtraText")
        tableView.register(UINib(nibName: "ExtraInformationTableViewCell", bundle: nil), forCellReuseIdentifier: "ExtraInformation")
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
            let url: String = "https://api.darksky.net/forecast/0d387f3d301b383589fe5b5350cf9a77/\(cityLat),\(cityLong)?units=si"
            print(url)
            Alamofire.request(url).responseJSON { response in
                
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let forecast = Forecast(json: json)
                        self.aCity?.update(forecast: forecast)
                    }
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! HeaderTableViewCell
            cell.tempLabel.text = "12"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyForecastText", for: indexPath) as! ForecastTextTableViewCell
            cell.label.text = "Something"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyForecast", for: indexPath) as! HourlyForecastTableViewCell
            cell.humidity.text = "50%"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyForecastText", for: indexPath) as! ForecastTextTableViewCell
            cell.label.text = "Else"
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyForecast", for: indexPath) as! DailyForecastTableViewCell
            cell.day.text = "Wednesday"
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExtraText", for: indexPath) as! ForecastTextTableViewCell
            cell.label.text = "Over"
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExtraInformation", for: indexPath) as! ExtraInformationTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
