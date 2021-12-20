//
//  Note.swift
//  Challenge7
//
//  Created by MadiApps on 20/12/2021.
//

import UIKit

class Note: NSObject, Codable {
    var text: String
    
    init(text: String) {
        self.text = text
    }
}
