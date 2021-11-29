//
//  Country.swift
//  challenge5
//
//  Created by MadiApps on 26/11/2021.
//

import Foundation

struct Countries: Codable {
    var results: [Country]
}

struct Country: Codable {
    var name: String
    var language: String
    var gdpPerCapita: Int
    var geography: String
    var history: String
    var thumbnail: String
}
