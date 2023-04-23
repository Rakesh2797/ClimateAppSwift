//
//  WeatherData.swift
//  Clima
//
//  Created by Kota, Venkata | RIEPL on 25/03/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
struct WeatherData: Decodable{
    var name:String
    var main:Main
    var weather:[Weather]
    
}
struct Main:Decodable {
    var temp: Double
}
struct Weather:Decodable {
    var description: String
    var id: Int
}
