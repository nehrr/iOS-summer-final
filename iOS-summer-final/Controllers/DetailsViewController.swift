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
    var now: DateComponents?
    var timezone: String?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "Header")
        tableView.register(UINib(nibName: "ForecastTextTableViewCell", bundle: nil), forCellReuseIdentifier: "HourlyForecastText")
        tableView.register(UINib(nibName: "ForecastTextTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyForecastText")
        tableView.register(UINib(nibName: "HourlyForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "HourlyForecast")
        tableView.register(UINib(nibName: "DailyForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyForecast")
        tableView.register(UINib(nibName: "ForecastTextTableViewCell", bundle: nil), forCellReuseIdentifier: "ExtraText")
        tableView.register(UINib(nibName: "ExtraInformationTableViewCell", bundle: nil), forCellReuseIdentifier: "ExtraInformation")
        
        self.tableView.activityStartAnimating(backgroundColor: UIColor.day)
        self.getData()
        
        if let cityName = aCity?.name {
            navigationItem.title = cityName
        }
        
        if aCity?.forecast == nil {
            print("empty")
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

    }
    
    @objc func refreshData(_ sender: Any) {
        self.getData()
        self.refreshControl.endRefreshing()
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
                        let dailyForecast = DailyForecast(json: json)
                        let hourlyForecast = HourlyForecast(json: json)
                        self.aCity?.forecast = forecast
                        self.aCity?.forecast?.dailyForecast = dailyForecast
                        self.aCity?.forecast?.hourlyForecast = hourlyForecast
                        self.timezone = json["timezone"].stringValue
                    }
                    
                    if let cityTimezone = self.timezone {
                        if let tZ = TimeZone(identifier: cityTimezone) {
                            let date = Date()
                            self.now = Calendar.current.dateComponents(in: tZ, from: date)
                        }
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
            if let nb = aCity?.forecast?.hourlyForecast?.hourlyForecast.count {
                return nb > 0 ? 10 : 0
            }
            return 0
        case 3:
            return 1
        case 4:
            return aCity?.forecast?.dailyForecast?.dailyForecast.count ?? 0
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
            if let text = aCity?.forecast?.hourlyForecast?.hourlySummary {
                cell.configure(text: text)
            }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyForecast", for: indexPath) as! HourlyForecastTableViewCell
            if let hourlyForecast = aCity?.forecast?.hourlyForecast?.hourlyForecast[indexPath.row], let tz = self.timezone {
                cell.configure(withData: hourlyForecast, timezone: tz)
            }
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyForecastText", for: indexPath) as! ForecastTextTableViewCell
            if let text = aCity?.forecast?.dailyForecast?.dailySummary {
                cell.configure(text: text)
            }
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyForecast", for: indexPath) as! DailyForecastTableViewCell
            if let dailyForecast = aCity?.forecast?.dailyForecast?.dailyForecast[indexPath.row] {
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
        
        
        if let hour = self.now?.hour, let weather = aCity?.forecast?.icon {
            if hour <= 19 && hour >= 8 {
                
                switch weather {
                    
                case "clear-day", "clear-night" :
                    cell.contentView.backgroundColor = UIColor.day
                    self.tableView.backgroundColor = UIColor.day
                    for label in labels {
                        label.textColor = UIColor.black
                    }
                    
                case "cloudy", "fog", "partly-cloudy-day", "partly-cloudy-night" :
                    cell.contentView.backgroundColor = UIColor.overcast
                    self.tableView.backgroundColor = UIColor.overcast
                    for label in labels {
                        label.textColor = UIColor.black
                    }
                    
                case "rain", "sleet" :
                    cell.contentView.backgroundColor = UIColor.rainy
                    self.tableView.backgroundColor = UIColor.rainy
                    for label in labels {
                        label.textColor = UIColor.black
                    }
                    
                case "snow" :
                    cell.contentView.backgroundColor = UIColor.white
                    self.tableView.backgroundColor = UIColor.white
                    self.tableView.separatorColor = UIColor.black
                    for label in labels {
                        label.textColor = UIColor.gray
                    }
                    
                default:
                    cell.contentView.backgroundColor = UIColor.day
                    self.tableView.backgroundColor = UIColor.day
                    for label in labels {
                        label.textColor = UIColor.black
                    }
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
