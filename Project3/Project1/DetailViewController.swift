//
//  DetailViewController.swift
//  Project1
//
//  Created by MadiApps on 25/08/2021.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    var imageTitle: String = "no picture"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = imageTitle
        navigationItem.largeTitleDisplayMode = .never
        //navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        //?.jpegData(compressionQuality: 0.8)
        guard let image = imageView.image,
              let imageName = selectedImage else {
            print("No image found")
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let modifiedImage = renderer.image { ctx in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.preferredFont(forTextStyle: .headline),
                .paragraphStyle: paragraphStyle
            ]
            
            let text = "From Storm Viewer"
            let attributedString = NSAttributedString(string: text, attributes: attrs)
            
            attributedString.draw(at: CGPoint(x: 10, y: 20))
        }
        
        if let imageToShare = modifiedImage.jpegData(compressionQuality: 0.8) {
            let vc = UIActivityViewController(activityItems: [imageToShare, imageName], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        } else {
            // error handling
        }
        
    }

}
