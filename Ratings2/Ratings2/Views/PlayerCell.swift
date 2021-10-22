//
//  PlayerCell.swift
//  Ratings2
//
//  Created by MadiApps on 29/07/2021.
//

import UIKit

class PlayerCell: UITableViewCell {
    
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    var player: Player? {
        didSet {
            gameLabel.text = player?.game
            nameLabel.text = player?.name
            ratingImageView.image = image(forRating: player?.rating ?? 4)
        }
    }
    
    // 2:
    private func image(forRating rating: Int) -> UIImage? {
      let imageName = "\(rating)Stars"
      return UIImage(named: imageName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
