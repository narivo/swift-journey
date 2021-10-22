//
//  ViewController.swift
//  Project8
//
//  Created by MadiApps on 14/10/2021.
//

import UIKit

extension Thread {
    class func printCurrent() {
        print("\r⚡️: \(Thread.current)\r" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
    }
}

class ViewController: UIViewController {

    var cluesLabel: UILabel!
    var answerLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var submittedGuess = 0
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.textAlignment = .right
        answerLabel.text = "ANSWERS"
        answerLabel.numberOfLines = 0
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answerLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)

        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            
            cluesLabel.heightAnchor.constraint(equalTo: answerLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.heightAnchor.constraint(equalToConstant: 44),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                letterButton.layer.borderWidth = 0.5
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let textAnswer = currentAnswer.text else {return}
        
        if let answerPos = solutions.firstIndex(of: textAnswer) {
            var parts = answerLabel.text?.components(separatedBy: "\n")
            parts?[answerPos] = textAnswer
            answerLabel.text = parts?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            submittedGuess += 1
            activatedButtons.removeAll()
            
            if submittedGuess == 7 {
                let ac = UIAlertController(title: "Well done", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
            
        } else {
            score -= 1
            
            let ac = UIAlertController(title: "Craap !", message: "That wasn't a good guess !", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Go again", style: .default, handler: badGuessReset))
            present(ac, animated: true)
        }
    }
    
    func resetActivatedButtons() {
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    func badGuessReset(_ ac: UIAlertAction) {
        resetActivatedButtons()
    }
    
    func levelUp(_ ac: UIAlertAction) {
        level += 1
                
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        resetActivatedButtons()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    func loadLevel() {
        
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            
            Thread.printCurrent()
            
            guard let level = self?.level else { return }
            
            if let levelFileUrl = Bundle.main.url(forResource: "level\(level)", withExtension: ".txt") {
                if let levelContents = try? String(contentsOf: levelFileUrl) {
                    var lines = levelContents.components(separatedBy: "\n")
                    lines.shuffle()
                    
                    for (index, line) in lines.enumerated() {
                        let parts = line.components(separatedBy: ": ")
                        let answer = parts[0]
                        let clue = parts[1]
                        
                        clueString += "\(index + 1). \(clue)\n"
                        let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                        solutionString += "\(solutionWord.count) letters\n"
                        self?.solutions.append(solutionWord)
                        
                        let bits = answer.components(separatedBy: "|")
                        letterBits += bits
                    }
                    
                }
            }

            letterBits.shuffle()
            
            DispatchQueue.main.async { [weak self] in
                
                Thread.printCurrent()
                
                self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
                self?.answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if self?.letterButtons.count == letterBits.count {
                    if let count = self?.letterButtons.count {
                        for i in 0..<count{
                            self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                        }
                    }
                }
            }
            
        }

    }
}

