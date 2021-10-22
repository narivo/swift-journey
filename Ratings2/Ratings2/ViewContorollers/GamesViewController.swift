//
//  GamesViewController.swift
//  Ratings2
//
//  Created by MadiApps on 29/07/2021.
//

import UIKit

class GamesViewController: UITableViewController {

    let gamesDataSource = GamesDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gamesDataSource.numberOfGames()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)

        cell.textLabel?.text = gamesDataSource.gameName(at: indexPath)

        if gamesDataSource.selectedGameIndex == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let index = gamesDataSource.selectedGameIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section:0))
            cell?.accessoryType = .none
        }
        
        gamesDataSource.selectGame(at: indexPath)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        performSegue(withIdentifier: "unwindWithSelectedGame", sender: cell)
    }

}

extension PlayerCUViewController {
    @IBAction func unwindWithSelectedGame(segue: UIStoryboardSegue) {
        if let gamePickerViewController = segue.source as? GamesViewController,
           let selectedGame = gamePickerViewController.gamesDataSource.selectedGame {
            self.game = selectedGame
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PickGame", let gamePickerVC = segue.destination as? GamesViewController {
            gamePickerVC.gamesDataSource.selectedGame = self.game
        }
        
        if segue.identifier == "SavePlayer", let name = nameTextField.text, let game = detailLabel.text {
            self.player = Player(name: name, game: game, rating: 1)
        }
    }
}
