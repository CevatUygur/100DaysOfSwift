//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by CEVAT UYGUR on 24.04.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    
    var score = 0 {
        didSet {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score: \(score)", style: .plain, target: self, action: #selector(showScore))
        }
    }
    
    var highestScore = 0 {
        didSet {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Highest Score: \(highestScore)", style: .plain, target: self, action: #selector(showHighestScore))
        }
    }
    
    var correctAnswer = 0
    var numberOfAskedQuestions = 0
    
    var scoreKey = "scoreKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        UserDefaults
        let defaults = UserDefaults.standard
        
        if let decodedHighScore = defaults.integer(forKey: scoreKey) as? Int {
            highestScore = decodedHighScore
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score: \(score)", style: .plain, target: self, action: #selector(showScore))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Highest Score: \(highestScore)", style: .plain, target: self, action: #selector(showHighestScore))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion(action: nil)
    }
    
    func askQuestion(action: UIAlertAction!) {
        numberOfAskedQuestions += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }
    
    func restartGame(action: UIAlertAction!) {
        numberOfAskedQuestions = 0
        score = 0
        
        askQuestion(action: nil)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        
        if sender.tag == correctAnswer {
            score += 1
            
            if score >= highestScore {
                highestScore = score
            }
            
            save()
            
            title = "Correct"
            message = "Your score is \(score)"
        } else {
            if score > 0 {
                score -= 1
            }
            title = "Wrong"
            message = "You selected the flag of \(countries[sender.tag].uppercased()).\n\nYour score is \(score)"
            
        }
        
        let ac = UIAlertController(title: title, message: numberOfAskedQuestions < 10 ? message : "You answered 10.question.\n\(message)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: numberOfAskedQuestions < 10 ? "Continue" : "Restart Game", style: .default, handler: numberOfAskedQuestions < 10 ? askQuestion : restartGame))
        
        present(ac, animated: true)
    }
    
    @objc func showScore() {
        
        let ac = UIAlertController(title: "Score Alert", message: "Your Score is \(score)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: .none))
        
        present(ac, animated: true)
    }
    
    @objc func showHighestScore() {
        
        let ac = UIAlertController(title: "Highest Score Alert", message: "Your Highest Score is \(highestScore)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: .none))
        
        present(ac, animated: true)
    }
    
    //    UserDefaults
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(highestScore, forKey: scoreKey)
        
    }
}
