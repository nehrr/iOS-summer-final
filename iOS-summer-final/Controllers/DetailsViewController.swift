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

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var aCity: City?
    var now: Int?
    var timezone: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(aCity)
        self.tableView.tableFooterView = UIView()
        
        let date = Date()
        let calendar = Calendar.current
        self.now = calendar.component(.hour, from: date)
        
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "Header")
        tableView.register(UINib(nibName: "ForecastTextTableViewCell", bundle: nil), forCellReuseIdentifier: "HourlyForecastText")
        tableView.register(UINib(nibName: "ForecastTextTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyForecastText")
        tableView.register(UINib(nibName: "HourlyForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "HourlyForecast")
        tableView.register(UINib(nibName: "DailyForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyForecast")
        tableView.register(UINib(nibName: "ForecastTextTableViewCell", bundle: nil), forCellReuseIdentifier: "ExtraText")
        tableView.register(UINib(nibName: "ExtraInformationTableViewCell", bundle: nil), forCellReuseIdentifier: "ExtraInformation")
        
        self.getData()
        
        if let cityName = aCity?.name {
            navigationItem.title = cityName
        }
        
        if aCity?.forecast == nil {
            print("empty")
        }
    }
    
    func getData() {
        self.tableView.activityStartAnimating(backgroundColor: UIColor.day)
        
        if let cityLat = aCity?.coordinates.latitude, let cityLong = aCity?.coordinates.longitude {
            let url: String = "https://api.darksky.net/forecast/0d387f3d301b383589fe5b5350cf9a77/\(cityLat),\(cityLong)?units=si"
            print(url)
            Alamofire.request(url).responseJSON { response in
                
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let forecast = Forecast(json: json)
                        self.aCity?.forecast = forecast
                        self.timezone = json["timezone"].stringValue
                    }
                    self.tableView.reloadData()
                    self.tableView.activityStopAnimating()
                    
                case .failure(let error):
                    self.doAlert(title: "Error", message: "No data was received, please check your network connection")
                    print(error)
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            if let nb = aCity?.forecast?.hourlyForecast.count {
                return nb > 0 ? 10 : 0
            }
            return 0
        case 3:
            return 1
        case 4:
            return aCity?.forecast?.dailyForecast.count ?? 0
        case 5:
            return 1
        case 6:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! HeaderTableViewCell
            if let temperature = aCity?.forecast?.temperature,
                let icon = aCity?.forecast?.icon,
                let summary = aCity?.forecast?.summary {
                cell.configure(temp: temperature, current: summary, icon: icon)
                cell.layoutMargins = UIEdgeInsets.zero
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyForecastText", for: indexPath) as! ForecastTextTableViewCell
            if let text = aCity?.forecast?.hourlySummary {
                cell.configure(text: text)
            }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyForecast", for: indexPath) as! HourlyForecastTableViewCell
            if let hourlyForecast = aCity?.forecast?.hourlyForecast[indexPath.row], let tz = self.timezone {
                cell.configure(withData: hourlyForecast, timezone: tz)
            }
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyForecastText", for: indexPath) as! ForecastTextTableViewCell
            if let text = aCity?.forecast?.dailySummary {
                cell.configure(text: text)
            }
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyForecast", for: indexPath) as! DailyForecastTableViewCell
            if let dailyForecast = aCity?.forecast?.dailyForecast[indexPath.row] {
                cell.configure(withData: dailyForecast)
            }
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExtraText", for: indexPath) as! ForecastTextTableViewCell
            cell.configure(text: "Extra Information")
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExtraInformation", for: indexPath) as! ExtraInformationTableViewCell
            if let extraData = aCity?.forecast?.extra[indexPath.row] {
                cell.configure(withData: extraData)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let labels = cell.contentView.subviews.compactMap { $0 as? UILabel }
        
        if let now = self.now {
            if now <= 19 && now >= 8 {
                cell.contentView.backgroundColor = UIColor.day
                self.tableView.backgroundColor = UIColor.day
                for label in labels {
                    label.textColor = UIColor.black
                }
            } else {
                cell.backgroundColor = UIColor.night
                self.tableView.backgroundColor = UIColor.night
                for label in labels {
                    label.textColor = UIColor.white
                }
            }
        }
    }
    
}
