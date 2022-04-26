//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by CEVAT UYGUR on 26.04.2022.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Whitehouse Petitions"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showFilter))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // we're OK to parse
                parse(json: data)
                filteredPetitions = petitions
                return
            }
        }
        
        showError()
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "Shown data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showFilter() {
        let ac = UIAlertController(title: "Type to Filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let filterKey = ac?.textFields?[0].text else { return }
            self?.submit(filterKey)
        }
        
        let resetAction = UIAlertAction(title: "Show All", style: .default) { _ in
            self.filteredPetitions = self.petitions
            self.tableView.reloadData()
        }
        
        ac.addAction(submitAction)
        ac.addAction(resetAction)
        present(ac, animated: true)
    }
    
    func submit(_ filterKey: String) {
        let lowerFilterKey = filterKey.lowercased()
        
        filteredPetitions.removeAll(keepingCapacity: true)
        
        for petition in petitions {
            if petition.title.contains(lowerFilterKey) || petition.body.contains(lowerFilterKey) {
                filteredPetitions.append(petition)
                tableView.reloadData()
            } else {
                tableView.reloadData()
            }
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed, please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
