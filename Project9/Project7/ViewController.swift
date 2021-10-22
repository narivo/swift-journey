//
//  ViewController.swift
//  Project7
//
//  Created by MadiApps on 08/10/2021.
//

import UIKit

struct Petitions: Codable {
    var results: [Petition]
}

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    var urlString = ""
    var filterText = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = URL(string: self?.urlString ?? "") {
                if let data = try? Data(contentsOf: url) {
                    self?.decode(json: data)
                    return
                }
            }
            self?.showError()
        }
        
    }
    
    func showError() {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Error", message: "Not able to do anything", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    func decode(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = jsonPetitions.results
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = filteredPetitions[indexPath.row].title
        cell.detailTextLabel?.text = filteredPetitions[indexPath.row].body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction
    func credits() {
        let ac = UIAlertController(title: "Credits", message: urlString, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction
    func filter() {
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] _ in
            guard let filterText = ac?.textFields?[0].text else {
                return
            }
            
            self?.filterText = filterText
            self?.performSelector(inBackground: #selector(self?.doFiltering), with: nil)
        })

        present(ac, animated: true)
    }
    
    @objc func doFiltering() {
        if filterText.isEmpty {
            self.filteredPetitions = petitions
        } else {
            let filteredPetitions = self.filteredPetitions.filter { petition in
                return petition.title.contains(filterText)
            }
            self.filteredPetitions = filteredPetitions
        }
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
}

