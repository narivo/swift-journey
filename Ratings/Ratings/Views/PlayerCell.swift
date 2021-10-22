//
//  PlayerCell.swift
//  Ratings
//
//  Created by MadiApps on 12/07/2021.
//

import UIKit

class PlayerCell: UITableViewCell {
    
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 1:
    var player: Player? {
      didSet {
        guard let player = player else { return }

        gameLabel.text = player.game
        nameLabel.text = player.name
        ratingImageView.image = image(forRating: player.rating)
      }
    }

    // 2:
    private func image(forRating rating: Int) -> UIImage? {
      let imageName = "\(rating)Stars"
      return UIImage(named: imageName)
    }
}
