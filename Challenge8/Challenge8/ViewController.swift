//
//  ViewController.swift
//  Challenge8
//
//  Created by MadiApps on 05/01/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.bounceOut(duration: 1)
        
        5.times { i in
            print(i)
        }
        
        var array = ["Jac", "Daniels", "Hello"]
        array.remove("Hello")
        print(array)
    }


}

