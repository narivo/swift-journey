//
//  ViewController.swift
//  Challenge9
//
//  Created by MadiApps on 17/02/2022.
//

import UIKit

class ViewController: UICollectionViewController,
                      UICollectionViewDelegateFlowLayout,
                      UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var memes = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
        
    }
    
    @objc func addMeme() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        memes.append(image)
        collectionView.reloadData()
        dismiss(animated: true)
        // navigate to details VC
        let vc = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailsViewController
        if let detailVC = vc {
            detailVC.image = image
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell else {
            fatalError()
        }
        cell.imageView.image = memes[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // navigate to details VC
        let vc = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailsViewController
        if let detailVC = vc {
            detailVC.image = memes[indexPath.item]
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}

