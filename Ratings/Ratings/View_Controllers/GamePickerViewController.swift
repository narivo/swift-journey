import UIKit

class GamePickerViewController: UITableViewController {
  let gamesDataSource = GamesDataSource()
}

extension GamePickerViewController {
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    gamesDataSource.numberOfGames()
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)
    cell.textLabel?.text = gamesDataSource.gameName(at: indexPath)
    
    if indexPath.row == gamesDataSource.selectedGameIndex {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }

    return cell
  }
}

extension GamePickerViewController {
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    // 1
    tableView.deselectRow(at: indexPath, animated: true)
    // 2
    if let index = gamesDataSource.selectedGameIndex {
      let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
      cell?.accessoryType = .none
    }
    // 3
    gamesDataSource.selectGame(at: indexPath)
    // 4
    let cell = tableView.cellForRow(at: indexPath)
    cell?.accessoryType = .checkmark
    
    performSegue(withIdentifier: "unwindToPlayerDetails", sender: cell)
  }
}
