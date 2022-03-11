//
//  CardData.swift
//  Challenge10
//
//  Created by MadiApps on 11/03/2022.
//

import UIKit

class CardData: NSObject {
    var id: Int
    var desc: String
    var pairID: Int
    
    init(id: Int, describing desc: String = "No description provided", with pairID: Int) {
        self.id = id
        self.desc = desc
        self.pairID = pairID
    }
}
