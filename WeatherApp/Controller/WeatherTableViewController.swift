//
//  WeatherTableViewController.swift
//  WeatherApp
//
//  Created by 安子璠 on 10/28/21.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit

class WeatherTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let networkModel = NetworkingModel()
    let databaseModel = DatabaseModel()
        
    var currentWeatherArray : [CurrentWeatherModel] = [CurrentWeatherModel]()
    
    @IBOutlet weak var tblView: UITableView!
//    @IBOutlet weak var lblHint: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshWeatherTable()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: NSInteger = 0
        if currentWeatherArray.count > 0 {
            self.tblView.backgroundView = nil
            numOfSection = 1
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tblView.bounds.size.width, height: self.tblView.bounds.size.height))
            noDataLabel.text = "Please click on '+' button to add a new city"
            noDataLabel.textColor = UIColor.systemGray
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tblView.backgroundView = noDataLabel
        }
        return numOfSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWeatherArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = Bundle.main.loadNibNamed("WeatherTableViewCell", owner: self, options: nil)?.first as! WeatherTableViewCell
        
        cell.selectionStyle = .none
        
        let currentWeather = currentWeatherArray[indexPath.row]
        
        cell.cityName.text = currentWeather.cityInfoName
        cell.cityTime.text = transformTime(currentWeather.localObservationDateTime)
        cell.cityWeather.text = currentWeather.weatherText
        cell.cityTemperature.text = "\(currentWeather.temp)°"
        
        cell.weatherIcon.image = UIImage(named: String(currentWeather.weatherIcon))
        
        if currentWeather.isDayTime{
            cell.cellBackgorund.backgroundColor = UIColor(red: 0.37, green: 0.36, blue: 0.90, alpha: 1.00)
        }else{
            cell.cellBackgorund.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.38, alpha: 1.00)
        }
        
        cell.cellBackgorund.layer.cornerRadius = 20
        cell.cellBackgorund.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
//    @IBAction func addAction(_ sender: Any) {
//        lblHint.isHidden = true
//    }
    
    // MARK: - Update table
    
    func refreshWeatherTable(){
        let citiesInfoArray = databaseModel.getCityfromDB()
        guard citiesInfoArray.count != 0 else { return }
        networkModel.getAllCurrentWeather(citiesInfoArray)
            .done { currentWeatherArray in
                self.currentWeatherArray.removeAll()
                self.currentWeatherArray = currentWeatherArray
                self.tblView.reloadData()
            }
            .catch { error in
                print("WT Network Error:  \(error)")
            }
    }
    
    
    // MARK: - Helper
    
    func transformTime(_ localTime : String) -> String{
//        2021-10-29T16:34:00-07:00
        var formattedTime = ""
        if let match = localTime.range(of: "(?<=T)[^:]+:([^:]+)", options: .regularExpression) {
//            formattedTime = localTime.substring(with: match)
            formattedTime = String(localTime[match])
        }
        
        return String(formattedTime)
    }
    
}
