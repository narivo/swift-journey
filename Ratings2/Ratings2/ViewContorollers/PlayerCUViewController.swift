//
//  PlayerCUViewController.swift
//  Ratings2
//
//  Created by MadiApps on 29/07/2021.
//

import UIKit

class PlayerCUViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    
    var game = "" {
        didSet {
            detailLabel.text = game
        }
    }
    
    var player: Player?
    
    override func viewDidLoad() {
        game = "Chess"
        nameTextField.becomeFirstResponder()
    }
    
}

extension PlayersViewController {
  @IBAction func cancelToPlayersViewController(_ segue: UIStoryboardSegue) {
  }

  @IBAction func savePlayerDetail(_ segue: UIStoryboardSegue) {
    guard
      let playerDetailsViewController = segue.source as? PlayerCUViewController,
      let player = playerDetailsViewController.player
      else {
        return
    }
    playersDataSource.append(player: player, to: tableView)
    
  }
}
