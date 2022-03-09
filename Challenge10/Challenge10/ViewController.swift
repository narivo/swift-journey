//
//  ViewController.swift
//  Challenge10
//
//  Created by MadiApps on 08/03/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var cards = [CardView]()
    var cardKeys = [String]()
    var viewsDict = [String: UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for x in 1...16 {
            let cardKey = "Card\(x)"
            cardKeys.append(cardKey)
            let card = CardView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 300)))
            card.translatesAutoresizingMaskIntoConstraints = false
            cards.append(card)
            viewsDict.updateValue(card, forKey: cardKey)
            view.addSubview(card)
        }
        
        for x in stride(from: 1, to: 13, by: 4) {
            let visualFormat = "H:|[\(cardKeys[x+0])]-[\(cardKeys[x+1])]-[\(cardKeys[x+2])]-[\(cardKeys[x+3])]"
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: [], metrics: nil, views: viewsDict))
        }
        
    }


}

