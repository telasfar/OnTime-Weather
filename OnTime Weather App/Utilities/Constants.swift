//
//  Constants.swift
//  OnTime Weather App

//  Copyright © 2018 Tariq. All rights reserved.
//"http://api.openweathermap.org/data/2.5/weather?lat=0&lon=0&appid=67fe775b50280a120a0df434ca75059f&units=metric"

import Foundation
import UIKit
//vars
let appDelegate = UIApplication.shared.delegate as? AppDelegate

//typealias
typealias complitionHandlerMessage = (_ status:Bool,_ weather:WeatherModel?)->()
typealias complitionHandlerArray = (_ status:Bool,_ weather:[WeatherModel]?)->()
typealias complitionHandlerWeather = (_ status:Bool,_ weather:WeatherResource?)->()


//API
 let API_KEY:String="67fe775b50280a120a0df434ca75059f"

func getMapURL (lat:Double,long:Double,mode:String)->String{
    return "http://api.openweathermap.org/data/2.5/\(mode)?lat=\(lat)&lon=\(long)&appid=\(API_KEY)&units=metric"
}

func getURLByCity(city:String,country:String)->String{
    return "http://api.openweathermap.org/data/2.5/weather?q=\(city),\(country)&appid=\(API_KEY)"
}
