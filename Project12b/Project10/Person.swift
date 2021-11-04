//
//  Person.swift
//  Project10
//
//  Created by MadiApps on 26/10/2021.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
