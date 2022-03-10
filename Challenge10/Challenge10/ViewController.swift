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
            let card = CardView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 150)))
            card.translatesAutoresizingMaskIntoConstraints = false // RTFM
            cards.append(card)
            viewsDict.updateValue(card, forKey: cardKey)
            view.addSubview(card)
        }
        
        for x in stride(from: 0, to: 13, by: 4) {
            let widthConstraint = "(==100)"
            let visualFormat = "H:|[\(cardKeys[x])\(widthConstraint)]-[\(cardKeys[x+1])\(widthConstraint)]-[\(cardKeys[x+2])\(widthConstraint)]-[\(cardKeys[x+3])\(widthConstraint)]"
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: [], metrics: nil, views: viewsDict))
        }
        
        for x in 0...3 {
            let heightConstraint = "(==150)"
            let visualFormat = "V:|[\(cardKeys[x])\(heightConstraint)]-[\(cardKeys[x+4])\(heightConstraint)]-[\(cardKeys[x+8])\(heightConstraint)]-[\(cardKeys[x+12])\(heightConstraint)]"
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: [], metrics: nil, views: viewsDict))
        }
    }


}

