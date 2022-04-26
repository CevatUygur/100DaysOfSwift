//
//  ViewController.swift
//  ShoppingList
//
//  Created by CEVAT UYGUR on 26.04.2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var list = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToList))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(cleanList))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        return cell
        
    }
    
    @objc func cleanList() {
        list.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func addToList() {
        let ac = UIAlertController(title: "Add to shopping list", message: nil, preferredStyle: .alert)
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
        let lowerAnswer = answer.lowercased()
        
        if isOriginal(word: lowerAnswer) {
            if isReal(word: lowerAnswer) {
                list.insert(answer, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            } else {
                showErrorMessage(errorTitle: "Empty Item", errorMessage: "List item can't be empty, try different.")
            }
        } else {
            showErrorMessage(errorTitle: "Already exists", errorMessage: "List item already exists, try different.")
        }
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isOriginal(word: String) -> Bool {
        return !list.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        return word.count > 0
    }
}

