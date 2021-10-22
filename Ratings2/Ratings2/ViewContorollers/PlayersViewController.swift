//
//  PlayersViewController.swift
//  Ratings2
//
//  Created by MadiApps on 29/07/2021.
//

import UIKit

class PlayersViewController: UITableViewController {
    let playersDataSource = PlayersDataSource()
}


extension PlayersViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection rowsInSection: Int) -> Int {
        playersDataSource.numberOfPlayers()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        cell.player = playersDataSource.player(at: indexPath)
        return cell
    }
}
