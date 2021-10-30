//
//  NetworkingModel.swift
//  WeatherApp
//
//  Created by 安子璠 on 10/29/21.
//

import Alamofire
import Foundation
import PromiseKit
import SwiftSpinner
import SwiftyJSON

class NetworkingModel {
    
    // MARK: - SearchBar Networking

    private func getSearchURL(_ searchText: String) -> String {
        return locationSearchURL + "apikey=" + apiKey + "&q=" + searchText
    }

    func getCityInfo(_ searchText: String) -> Promise<[CityInfoModel]> {
        SwiftSpinner.show("Fetching data...")

        return Promise<[CityInfoModel]> { seal -> Void in

            let url = getSearchURL(searchText)
            var citiesInfoArray : [CityInfoModel] = [CityInfoModel]()
            
            AF.request(url).responseJSON { response in
                
                switch response.result {
                    
                case .success(let success):
                    SwiftSpinner.hide()
                    let citiesArray = JSON(success)
                    for (_, city): (String, JSON) in citiesArray {
                        
                        let cityInfo = CityInfoModel()
                        
                        cityInfo.administrativeID = city["AdministrativeArea"]["ID"].stringValue
                        cityInfo.key = city["Key"].stringValue
                        cityInfo.type = city["Type"].stringValue
                        cityInfo.countryLocalizedName = city["Country"]["LocalizedName"].stringValue
                        cityInfo.localizedName = city["LocalizedName"].stringValue

                        citiesInfoArray.append(cityInfo)
                        
                    }
                    
                    seal.fulfill(citiesInfoArray)

                case .failure(let error):
                    SwiftSpinner.show("Failed", animated: false).addTapHandler({
                        SwiftSpinner.hide()
                    }, subtitle: "Tap to hide.")
                    
                    print("Error:\(error)")
                    seal.reject(error)
                }
                
            } // AF
        } // return
    } // end
    
    
    // MARK: - WeatherTable Networking
    
    private func getWeatherURL(_ cityKey: String) -> String {
        return currentConditionURL + cityKey + "?apikey=" + apiKey
    }
    
    private func getCurrentWeather(_ cityInfo : CityInfoModel) -> Promise<CurrentWeatherModel>{
        
        return Promise<CurrentWeatherModel> { seal -> Void in
            
            let cityID = cityInfo.key
            let url = getWeatherURL(cityID)
            
            AF.request(url).responseJSON { response in
                
                switch response.result {
                    
                case .success(let success):
                    let weather = JSON(success)[0]
                    let cityWeather = CurrentWeatherModel()
                    
                    cityWeather.cityKey = cityID
                    cityWeather.cityInfoName = cityInfo.localizedName
                    cityWeather.weatherText = weather["WeatherText"].stringValue
                    cityWeather.epochTime = weather["EpochTime"].intValue
                    cityWeather.isDayTime = weather["IsDayTime"].boolValue
                    cityWeather.temp = weather["Temperature"]["Metric"]["Value"].intValue
                    cityWeather.localObservationDateTime = weather["LocalObservationDateTime"].stringValue
                    cityWeather.weatherIcon = weather["WeatherIcon"].intValue
                    
                    seal.fulfill(cityWeather)

                case .failure(let error):
                    SwiftSpinner.show("Some Failed", animated: false).addTapHandler({
                        SwiftSpinner.hide()
                    }, subtitle: "Tap to hide.")
                    
                    print("Error:\(error)")
                    seal.reject(error)
                }
                
            } // AF
        } // return
    } // end
    
    func getAllCurrentWeather(_ citiesInfoArray : [CityInfoModel]) -> Promise<[CurrentWeatherModel]>{
        
        SwiftSpinner.show("Fetching data...")
        
        var promises: [Promise< CurrentWeatherModel >] = []
                    
        for cityInfo in citiesInfoArray {
            promises.append(getCurrentWeather(cityInfo))
        }
        
        SwiftSpinner.hide()
        
        return when(fulfilled: promises)
        
    }
    
}
