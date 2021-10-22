//
//  DetailController.swift
//  Challenge1
//
//  Created by MadiApps on 01/09/2021.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = UIImage(named: selectedImage)

        title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    @objc func share() {
        let actController = UIActivityViewController(activityItems: [imageView.image!, selectedImage], applicationActivities: [])
        present(actController, animated: true)
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
