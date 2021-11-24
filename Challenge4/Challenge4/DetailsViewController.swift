//
//  DetailsViewController.swift
//  Challenge4
//
//  Created by MadiApps on 05/11/2021.
//

import UIKit

class DetailsViewController: UIViewController {

    var currentRecord: Record?
    
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let pic = currentRecord?.image {
            let imagePath = getDocumentsDirectory().appendingPathComponent(pic)
            imageView.image = UIImage(contentsOfFile: imagePath.path)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
