//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by 安子璠 on 10/29/21.
//

import Foundation

class CurrentWeatherModel{
    var cityKey : String = ""
    var cityInfoName : String = ""
    var weatherText : String = ""
    var epochTime : Int = Int.min
    var isDayTime : Bool = true
    var temp : Int = Int.min
    var localObservationDateTime: String = ""
    var weatherIcon: Int = Int.min
}
