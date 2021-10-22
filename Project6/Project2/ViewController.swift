//
//  ViewController.swift
//  Project2
//
//  Created by MadiApps on 27/08/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var titleWithScore = ""
    var questionNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany",
                      "ireland", "italy", "monaco",
                      "nigeria", "poland", "russia",
                      "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showScore))
    }

    @objc func showScore() {
        presentAlert(say: "\(score).", title: "Your score:") { action in }
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        //title = countries[correctAnswer].uppercased()
        titleWithScore = "\(countries[correctAnswer].uppercased()) | score: \(score)"
        title = titleWithScore
        
        questionNum += 1
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String

        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            askQuestion()
        } else {
            title = "Wrong"
            score -= 1
            presentAlert(say: "That's the flag of \(countries[sender.tag].uppercased()).", title: title, askQuestion)
        }
        if questionNum >= 10 {
            presentAlert(say: "Your final score is \(score).", title: title) { action in }
        }
    }
    
    private func presentAlert(say message: String, title: String, _ handler: @escaping (_ action: UIAlertAction) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: handler))
        present(ac, animated: true)
    }
}

