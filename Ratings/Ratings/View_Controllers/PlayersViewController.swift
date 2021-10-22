//
//  PlayersViewController.swift
//  Ratings
//
//  Created by MadiApps on 28/07/2021.
//

import UIKit

class PlayersViewController: UITableViewController {
  var playersDataSource = PlayersDataSource()
    
  @IBAction func cancelToPlayersViewController(_ segue: UIStoryboardSegue) {
    
  }

  @IBAction func savePlayerDetail(_ segue: UIStoryboardSegue) {
    
  }
}

extension PlayersViewController {
    
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    playersDataSource.numberOfPlayers()
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "PlayerCell",
      for: indexPath) as! PlayerCell
    cell.player = playersDataSource.player(at: indexPath)
    return cell
  }
}
