//
//  CityInfo.swift
//  WeatherApp
//
//  Created by 安子璠 on 10/29/21.
//

import Foundation

import RealmSwift

class CityInfoModel : Object {
    @objc dynamic var key: String  = ""
    @objc dynamic var type : String = ""
    @objc dynamic var localizedName : String = ""
    @objc dynamic var countryLocalizedName : String = ""
    @objc dynamic var administrativeID : String = ""
    
    override static func primaryKey() -> String? {
        return "key"
    }
    
}
