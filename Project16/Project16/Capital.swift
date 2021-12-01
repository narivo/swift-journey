//
//  Capital.swift
//  Project16
//
//  Created by MadiApps on 29/11/2021.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var url: URL?
    
    init(title: String?, coordinate: CLLocationCoordinate2D, info: String, url urlString: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.url = URL(string: urlString)
    }
}
