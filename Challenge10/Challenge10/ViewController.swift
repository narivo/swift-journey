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
    var datas = [String: CardData]()
    
    var currentCard: CardView? = nil
    var transientCard: CardView? = nil

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
            let visualFormat = "H:|-290-[\(cardKeys[x])\(widthConstraint)]-[\(cardKeys[x+1])\(widthConstraint)]-[\(cardKeys[x+2])\(widthConstraint)]-[\(cardKeys[x+3])\(widthConstraint)]"
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: [], metrics: nil, views: viewsDict))
        }
        
        for x in 0...3 {
            let heightConstraint = "(==150)"
            let visualFormat = "V:|-75-[\(cardKeys[x])\(heightConstraint)]-[\(cardKeys[x+4])\(heightConstraint)]-[\(cardKeys[x+8])\(heightConstraint)]-[\(cardKeys[x+12])\(heightConstraint)]"
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: [], metrics: nil, views: viewsDict))
        }
    }
    
    fileprivate func createAndLinkCardsDatas() {
        var y = 16
        for x in 1...8 {
            let dataX = CardData(id: x, with: y)
            let dataY = CardData(id: y, with: x)
            datas.updateValue(dataX, forKey: cardKeys[x-1])
            datas.updateValue(dataY, forKey: cardKeys[y-1])
            cards[x-1].data = dataX
            cards[x-1].backImage = "king"
            cards[y-1].data = dataY
            cards[y-1].backImage = "king"
            y -= 1
        }
    }
    
    func cardView(_ sender: CardView, didFlip orientation: CardOrientation) {
        if currentCard != nil {
            allowFindCardPair(sender, with: orientation)
        } else {
            initFindingCardPair(sender, with: orientation)
        }
    }
    
    fileprivate func allowFindCardPair(_ sender: CardView, with orientation: CardOrientation) {
        if orientation == .Front {
            transientCard = sender
            debugPrint("Transient cardID = \(String(describing: transientCard?.data?.id))")
            
            if foundCardPair() {
                debugPrint("True !!")
                updateDatasValues()
                verifyGameDone()
            } else {
                wrongCardPairs(sender)
            }
        } else {
            transientCard = nil
            currentCard = nil
        }
    }
    
    fileprivate func initFindingCardPair( _ sender: CardView, with orientation: CardOrientation) {
        if orientation == .Front {
            currentCard = sender
            debugPrint("Current cardID = \(String(describing: currentCard?.data?.id))")
        } else {
            currentCard = nil
        }
    }
    
    fileprivate func updateDatasValues() {
        DispatchQueue.main.async {
            guard let dataX = self.currentCard?.data else { return }
            guard let dataY = self.transientCard?.data else { return }
            dataX.foundPair = true
            dataY.foundPair = true
            self.datas.updateValue(dataX, forKey: "Card\(dataX.id)")
            self.datas.updateValue(dataY, forKey: "Card\(dataY.id)")
        }
    }
    
    fileprivate func verifyGameDone() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.currentCard?.isHidden = true
            self.transientCard?.isHidden = true
            self.currentCard = nil
            self.transientCard = nil
            
            var gameDone = true
            for data in self.datas {
                if data.value.foundPair == false {
                    // all pairs are not found
                    gameDone = false
                }
            }
            
            if gameDone {
                let ac = UIAlertController(title: "You WIN !", message: "The game is done.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Quit", style: .cancel, handler: { _ in exit(0) }))
                self.present(ac, animated: true)
            }
        })
    }
    
    fileprivate func wrongCardPairs(_ sender: CardView) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            self.currentCard?.flip()
            sender.flip()
            self.transientCard = nil
            self.currentCard = nil
        })
    }
    
    fileprivate func foundCardPair() -> Bool {
        return currentCard?.data?.pairID == transientCard?.data?.id
    }
    
}

