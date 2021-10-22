//
//  ViewController.swift
//  Challenge3
//
//  Created by MadiApps on 21/10/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var countLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var triesLeftLabel: UILabel!
    @IBOutlet var guessWordLabel: UILabel!
    @IBOutlet var userInputTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var triesLeft = 7 {
        didSet {
            triesLeftLabel.text = "Left: \(triesLeft)"
        }
    }
    
    var wordToGuess = "" {
        didSet {
            countLabel.text = "Count: \(wordToGuess.count)"
        }
    }
    var charEntered = ""
    var charsGuessed = [String]()
    var hiddenWord = ""
    
    var currentWord = 0
    var currentLevel = 1 {
        didSet {
            levelLabel.text = "Level \(currentLevel)"
        }
    }
    var wordsInLevel = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadLevel()
    }

    func loadLevel() {
        if let levelUrl = Bundle.main.url(forResource: "level\(currentLevel)", withExtension: ".txt") {
            if let levelFileContent = try? String(contentsOf: levelUrl) {
                wordsInLevel = levelFileContent.components(separatedBy: "\n")
                debugPrint(wordsInLevel)
            }
        }
        nextWordInLevel()
    }
    
    func nextWordInLevel() {
        if currentWord < wordsInLevel.count {
            charsGuessed.removeAll(keepingCapacity: true)
            
            wordToGuess = wordsInLevel[currentWord]
            updateHiddenWord()
        }
    }
    
    func updateHiddenWord() {
        hiddenWord = ""
        
        var match = false
        
        for word in wordToGuess {
            for guess in charsGuessed {
                if String(word) == guess {
                    match = true
                }
            }
            if match {
                hiddenWord.append(word)
            } else {
                hiddenWord.append("?")
            }
            match = false
        }
        
        guessWordLabel.text = hiddenWord
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        guard let enteredText = userInputTextField.text?.uppercased() else { return }
        if enteredText.isEmpty { return }
        
        charEntered = enteredText.first?.description ?? ""
        debugPrint(charEntered)
        
        userInputTextField.text = ""
        
        let trueGuess = wordToGuess.contains(charEntered)
        if trueGuess {
            charsGuessed.append(charEntered)
            updateHiddenWord()
        } else {
            triesLeft -= 1
        }
        
        if triesLeft == 0 {
            let ac = UIAlertController(title: "You lose", message: "7 tries and you died", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(ac, animated: true) { [weak self] in
                self?.submitButton.isHidden = true
            }
        }
        
        if hiddenWord.contains("?") == false {
            currentWord += 1
            
            if currentWord < wordsInLevel.count - 1{
                let ac = UIAlertController(title: "Not done yet ?", message: "you managed to unlock a new word", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go !", style: .default))
                
                present(ac, animated: true) { [weak self] in
                    self?.nextWordInLevel()
                }
            } else {
                let ac = UIAlertController(title: "Woooah", message: "you managed to unlock a whole new level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Rock it !", style: .default))
                
                present(ac, animated: true) { [weak self] in
                    self?.currentLevel += 1
                    self?.currentWord = 0
                    self?.loadLevel()
                }
            }
        }
    }
}

