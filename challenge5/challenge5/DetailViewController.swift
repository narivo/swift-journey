//
//  DetailViewController.swift
//  challenge5
//
//  Created by MadiApps on 26/11/2021.
//

import UIKit

class DetailViewController: UITableViewController {

    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var gdpLabel: UILabel!
    @IBOutlet var geographyLabel: UILabel!
    @IBOutlet var historyLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var selectedCountry: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationItem.largeTitleDisplayMode = .never
        
        guard let selectedCountry = selectedCountry else {
            return
        }

        //print(selectedCountry?.name)
        navigationItem.title = selectedCountry.name
        
        languageLabel.text = selectedCountry.language
        gdpLabel.text = "\(selectedCountry.gdpPerCapita) $/year"
        geographyLabel.text = selectedCountry.geography
        historyLabel.text = selectedCountry.history
        
        let image = UIImage(named: selectedCountry.thumbnail)
        imageView.image = image
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 248
        }
        return UITableView.automaticDimension
    }
    
}
