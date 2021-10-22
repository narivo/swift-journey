//
//  ViewController.swift
//  Challenge2
//
//  Created by MadiApps on 07/10/2021.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItem", for: indexPath)
        cell.textLabel?.text = shoppingItems[indexPath.row]
        
        return cell
    }
    
    @IBAction
    func addShoppingItem() {
        let ac = UIAlertController(title: "Enter Shopping Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submit = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac, weak tableView] _ in
            self?.shoppingItems.insert(ac?.textFields?[0].text ?? "Empty", at: 0)
            tableView?.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        
        ac.addAction(submit)
        present(ac, animated: true)
    }
    
    @IBAction
    func clearShoppingItem() {
        shoppingItems.removeAll()
        tableView?.reloadData()
    }

}

