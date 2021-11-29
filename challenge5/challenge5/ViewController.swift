//
//  ViewController.swift
//  challenge5
//
//  Created by MadiApps on 26/11/2021.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let path = Bundle.main.resourcePath!
        
        let url = URL(fileURLWithPath: path)
        let jsonUrl = url.appendingPathComponent("Dataset.txt")
        if let data = try? Data(contentsOf: jsonUrl) {
            /*if let value = String(data: data, encoding: .utf8) {
                print(value)
            }*/
            decode(json: data)
            
            /*countries.forEach { country in
                print(country.name)
            }*/
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryList") else {
            fatalError()
        }
        
        cell.textLabel?.text = countries[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else {
            fatalError()
        }
        
        vc.selectedCountry = countries[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func decode(json: Data) {
        let decoder = JSONDecoder()
        
        do {
            let countries = try decoder.decode(Countries.self, from: json)
            self.countries = countries.results
        } catch {
            print(error)
        }
    }

}

