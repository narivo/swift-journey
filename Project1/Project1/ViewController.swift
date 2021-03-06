//
//  ViewController.swift
//  Project1
//
//  Created by MadiApps on 24/08/2021.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var pictures = [String]()
    var numbers = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            var items = try! fm.contentsOfDirectory(atPath: path)
            
            items.sort()
            for item in items {
                if item.hasPrefix("nssl") {
                    // this is a picture to load!
                    self?.pictures.append(item)
                    self?.numbers.append(0)
                }
            }
            
            print(self?.pictures ?? "")
            
            let defaults = UserDefaults.standard
            if let numbersData = defaults.object(forKey: "numbers") as? Data {
                if let numbers = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(numbersData) as? [Int] {
                    self?.numbers = numbers
                }
            }
            
            self?.collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Landscape", for: indexPath) as? LandscapeCell else { fatalError("Could not get instance of LandscapeCell") }
        
        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        cell.label.text = pictures[indexPath.row]
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        
        cell.numbers.text = String(numbers[indexPath.item])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        numbers[indexPath.item] += 1
        
        if let numbersToSave = try? NSKeyedArchiver.archivedData(withRootObject: numbers, requiringSecureCoding: false) {
            
            let defaults = UserDefaults.standard
            defaults.set(numbersToSave, forKey: "numbers")
        }
        
        collectionView.reloadData()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.imageTitle = "Picture \(indexPath.row+1) of \(pictures.count)"
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func share() {
        let vc = UIActivityViewController(activityItems: ["My app"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 180)
    }
}

