import UIKit

class PlayerDetailsViewController: UITableViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    
    var player: Player?
    
    var game = "" {
      didSet {
        detailLabel.text = game
      }
    }
    
    override func viewDidLoad() {
      nameTextField.becomeFirstResponder()
      game = "Chess"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
      if segue.identifier == "SavePlayer",
         let playerName = nameTextField.text,
         let gameName = detailLabel.text {
         player = Player(name: playerName, game: gameName, rating: 1)
      }
        
      if segue.identifier == "PickGame",
        let gamePickerViewController = segue.destination as? GamePickerViewController {
        gamePickerViewController.gamesDataSource.selectedGame = game
      }
    }
    
    required init?(coder aDecoder: NSCoder) {
      print("init PlayerDetailsViewController")
      super.init(coder: aDecoder)
    }

    deinit {
      print("deinit PlayerDetailsViewController")
    }
}

extension PlayerDetailsViewController {
  @IBAction func unwindWithSelectedGame(segue: UIStoryboardSegue) {
    if let gamePickerViewController = segue.source as? GamePickerViewController,
       let selectedGame = gamePickerViewController.gamesDataSource.selectedGame {
       game = selectedGame
    }
  }
}
