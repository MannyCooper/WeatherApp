//
//  DatabaseModel.swift
//  WeatherApp
//
//  Created by 安子璠 on 10/29/21.
//

import Foundation
import RealmSwift

class DatabaseModel {
    
    func addCityinDB(_ cityInfo : CityInfoModel){
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(cityInfo, update: .modified)
            }
        }catch{
            print("DB write Error: \(error)")
        }
    }
    
    func getCityfromDB() -> [CityInfoModel]{
        do{
            let realm = try Realm()
            let citiesInfoArray = realm.objects(CityInfoModel.self)
            return Array(citiesInfoArray)
        }catch{
            print("DB read Error: \(error)")
            return []
        }
    }
    
}
