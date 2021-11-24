//
//  Record.swift
//  Challenge4
//
//  Created by MadiApps on 05/11/2021.
//

import Foundation

class Record : Codable {
    var caption: String
    var image: String
    
    init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }
}
