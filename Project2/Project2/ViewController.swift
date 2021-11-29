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
    var highScore = 0
    var presentedHighScore = false
    
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
        
        let defaults = UserDefaults.standard
        
        if let savedHighScore = defaults.object(forKey: "high score") as? Data {
            if let highScore = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedHighScore) as? Int {
                self.highScore = highScore
            }
        }
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
        
        UIView.animate(withDuration: 0.5, delay: 0, options: []) {
            self.button1.transform = CGAffineTransform.identity
            self.button2.transform = CGAffineTransform.identity
            self.button3.transform = CGAffineTransform.identity
            
        }
        
        //title = countries[correctAnswer].uppercased()
        titleWithScore = "\(countries[correctAnswer].uppercased()) | score: \(score)"
        title = titleWithScore
        
        questionNum += 1
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String

        //UIView.animate(withDuration: 1, delay: 0, options: []) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }

        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            if score > highScore {
                highScore = score
                
                if let scoreToSave = try? NSKeyedArchiver.archivedData(withRootObject: highScore, requiringSecureCoding: false) {
                    
                    let defaults = UserDefaults.standard
                    defaults.set(scoreToSave, forKey: "high score")
                }
                
                if presentedHighScore == false {
                    presentAlert(say: "Your new high score is \(score)", title: title) { action in }
                    presentedHighScore = true
                }
            }
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

