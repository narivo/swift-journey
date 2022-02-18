//
//  DetailsViewController.swift
//  Challenge9
//
//  Created by MadiApps on 17/02/2022.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage?
    var topText: String?
    var bottomText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
        
        if let image = image {
            imageView.image = image
        }
        
        let ac = UIAlertController(title: "Top", message: "Insert at a top a message", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak ac, weak self] _ in
            if ac?.textFields?[0].text?.isEmpty == false {
                self?.topText = ac?.textFields?[0].text
            } else {
                self?.topText = nil
            }
            self?.showAlertForBottomMessage()
        })
        present(ac, animated: true)
    }
    
    @objc func shareMeme() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
                print("No image found")
                return
            }

        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func showAlertForBottomMessage() {
        let ac = UIAlertController(title: "Bottom", message: "Insert at bottom a message", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak ac, weak self] _ in
            if ac?.textFields?[0].text?.isEmpty == false {
                self?.bottomText = ac?.textFields?[0].text
            } else {
                self?.bottomText = nil
            }
            self?.renderImage()
        })
        present(ac, animated: true)
    }
    
    func renderImage() {
        if let image = self.image {
            let renderer = UIGraphicsImageRenderer(size: image.size)
            let img = renderer.image { ctx in
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .justified
                
                let attrs : [NSAttributedString.Key : Any] = [
                    .font: UIFont.preferredFont(forTextStyle: .title1),
                    .paragraphStyle: paragraphStyle,
                    .foregroundColor: UIColor.white
                ]
                
                image.draw(at: CGPoint(x: 0, y: 0))
                
                if let topText = topText {
                    let attributtedString = NSAttributedString(string: topText, attributes: attrs)
                    attributtedString.draw(at: CGPoint(x: image.size.width/2 - 50, y: 10))
                }
                
                if let bottomText = bottomText {
                    let attributtedString = NSAttributedString(string: bottomText, attributes: attrs)
                    attributtedString.draw(at: CGPoint(x: image.size.width/2 - 50, y: image.size.height - 50))
                }
            }
            self.image = img
            imageView.image = img
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
