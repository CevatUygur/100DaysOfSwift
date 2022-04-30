//
//  ViewController.swift
//  HangmanGame
//
//  Created by CEVAT UYGUR on 28.04.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var answerLetterBG: UIColor = .white
    var letterButtons = [UIButton]()
    var remainingStepsLabel: UILabel!
    var allWords = [String]()
    var askedWord = ""
    var usedLetters = ["?"]
    var answerLabelLetters = ["?", "?", "?", "?", "?", "?"] {
        didSet {
            print("Array guncellendi")
            loadView()
        }
    }
    
    var askedWordArray = [String]()
    
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var remainingSteps = 7 {
        didSet {
            remainingStepsLabel.text = "Remaining Steps: \(remainingSteps)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["SAMPLE"]
        }
        
        askedWord = allWords.randomElement()!.uppercased()
        
        askedWordArray.insert(contentsOf: askedWord.map { String($0) }, at: 0)
        
        print(askedWord)
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        remainingStepsLabel = UILabel()
        remainingStepsLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingStepsLabel.textAlignment = .right
        remainingStepsLabel.text = "Remaining Steps: \(remainingSteps)"
        remainingStepsLabel.textColor = .black
        remainingStepsLabel.font = UIFont.systemFont(ofSize: 21)
        view.addSubview(remainingStepsLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let answerView = UIView()
        answerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(answerView)
        
        let enterAnswer = UIButton(type: .system)
        enterAnswer.translatesAutoresizingMaskIntoConstraints = false
        enterAnswer.setTitle("ENTER YOUR ANSWER", for: .normal)
        enterAnswer.addTarget(self, action: #selector(promptForAnswer), for: .touchUpInside)
        view.addSubview(enterAnswer)
        
        
        NSLayoutConstraint.activate([
            remainingStepsLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            remainingStepsLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            
            answerView.widthAnchor.constraint(equalToConstant: 330),
            answerView.heightAnchor.constraint(equalToConstant: 55),
            answerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerView.topAnchor.constraint(equalTo: remainingStepsLabel.bottomAnchor, constant: 100),
            
            enterAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterAnswer.topAnchor.constraint(equalTo: answerView.bottomAnchor, constant: 50),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.heightAnchor.constraint(equalToConstant: 250),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: enterAnswer.bottomAnchor, constant: 50),
            
            // more constraint to be added here!
        ])
        
        let widthLetterButton = 50
        let heightLetterButton = 50
    
        let widthAnswerLetter = 55
        let heightAnswerLetter = 55
        
        for row in 0..<5 {
            for column in 0..<6 {
                if row == 4 && column > 1 {
                    // nothing
                } else {
                    let letterButton  = UIButton(type: .system)
                    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                    letterButton.setTitle(letters[row * 6 + column], for: .normal)
                    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

                    let frame = CGRect(x: column * widthLetterButton, y: row * heightLetterButton, width: widthLetterButton, height: heightLetterButton)
                    letterButton.frame = frame
                    letterButton.layer.borderColor = UIColor.lightGray.cgColor
                    letterButton.layer.borderWidth = 1
                    if usedLetters.contains(letters[row * 6 + column]) {
                        letterButton.layer.opacity = 0.6
                        letterButton.isEnabled = false
                        
                    }
                    buttonsView.addSubview(letterButton)
                    letterButtons.append(letterButton)
                }
            }
        }
        
        for item in 0..<6 {
            let answerLetter = UILabel(frame: CGRect(x: item * widthAnswerLetter, y: 0, width: widthAnswerLetter, height: heightAnswerLetter))
            answerLetter.text = answerLabelLetters[item]
            answerLetter.font = UIFont.systemFont(ofSize: 42)
            answerLetter.textAlignment = .center
            answerLetter.layer.borderColor = UIColor.lightGray.cgColor
            answerLetter.layer.borderWidth = 1
            
            answerLetter.backgroundColor = answerLetterBG
            answerLetter.textColor = .black
            answerView.addSubview(answerLetter)
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        usedLetters.insert(String(sender.currentTitle!), at: 0)
        remainingSteps -= 1
        sender.layer.opacity = 0.6
        sender.isEnabled = false
        
        for letterIndex in 0..<6 {
            if sender.currentTitle == askedWordArray[letterIndex] {
                answerLabelLetters[letterIndex] = askedWordArray[letterIndex]
                sender.layer.opacity = 0.6
                sender.isEnabled = false
            }
        }
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let upperAnswer = Array(answer.uppercased())
        
        if upperAnswer.count == 6 {
            for letterIndex in 0..<6 {
                if String(upperAnswer[letterIndex]) != askedWordArray[letterIndex] {
                    showErrorMessage(errorTitle: "Wrong Answer", errorMessage: "You couldn't find the right solution.")
                    for letterIndex in 0..<6 {
                        if answerLabelLetters[letterIndex] == "?" {
                            answerLabelLetters[letterIndex] = askedWordArray[letterIndex]
                            answerLetterBG = .red
                            //sender.layer.opacity = 0.6
                            //sender.isEnabled = false
                            print("?")
                        } else {
                            answerLetterBG = .green
                        }
                    }
                    
                    break
                } else {
                    continue
                }
            }
        } else {
            showErrorMessage(errorTitle: "Wrong Answer", errorMessage: "You couldn't find the right solution.")
            for letterIndex in 0..<6 {
                if answerLabelLetters[letterIndex] == "?" {
                    answerLetterBG = .red
                    answerLabelLetters[letterIndex] = askedWordArray[letterIndex]
                    //sender.layer.opacity = 0.6
                    //sender.isEnabled = false
                    print("Red")
                } else {
                    answerLetterBG = .green
                    print("Green")
                }
            }
        }
        
        showErrorMessage(errorTitle: "Congratulations", errorMessage: "You found the right solution.")
//        for letterIndex in 0..<6 {
//            if answerLabelLetters[letterIndex] == "?" {
//                answerLabelLetters[letterIndex] = askedWordArray[letterIndex]
//                answerLetterBG = .green
//                //sender.layer.opacity = 0.6
//                //sender.isEnabled = false
//                print("?")
//            } else {
//                answerLetterBG = .red
//            }
//        }
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // Set the shouldAutorotate to False
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }

}

