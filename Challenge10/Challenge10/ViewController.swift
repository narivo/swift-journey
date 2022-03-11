//
//  ViewController.swift
//  Challenge10
//
//  Created by MadiApps on 08/03/2022.
//

import UIKit

class ViewController: UIViewController, CardViewDelegate {
    
    var cards = [CardView]()
    var cardKeys = [String]()
    var viewsDict = [String: UIView]()
    var datas = [CardData]()
    
    var currentCard: CardData? = nil
    var transientCard: CardData? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildCardViews()
        createAndLinkCardsDatas()
    }

    fileprivate func buildCardViews() {
        
        for x in 1...16 {
            let cardKey = "Card\(x)"
            cardKeys.append(cardKey)
            let card = CardView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 150)))
            card.delegate = self
            card.translatesAutoresizingMaskIntoConstraints = false // RTFM
            cards.append(card)
            viewsDict.updateValue(card, forKey: cardKey)
            view.addSubview(card)
        }
        
        layoutCardViews()
    }
    
    fileprivate func layoutCardViews() {
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
    
    fileprivate func createAndLinkCardsDatas() {
        var y = 16
        for x in 1...8 {
            let dataX = CardData(id: x, with: y)
            let dataY = CardData(id: y, with: x)
            datas.append(dataX)
            datas.append(dataY)
            cards[x-1].data = dataX
            cards[y-1].data = dataY
            y -= 1
        }
    }
    
    func cardView(_ sender: CardView, didFlip orientation: CardOrientation) {
        
        if currentCard != nil {
            if orientation == .Front {
                transientCard = sender.data
                debugPrint("Transient cardID = \(String(describing: transientCard?.id))")
            } else {
                transientCard = nil
                currentCard = nil
            }
        } else {
            if orientation == .Front {
                currentCard = sender.data
                debugPrint("Current cardID = \(String(describing: currentCard?.id))")
            } else {
                currentCard = nil
            }
        }
    }
}

