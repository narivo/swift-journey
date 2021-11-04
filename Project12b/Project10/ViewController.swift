//
//  ViewController.swift
//  Project10
//
//  Created by MadiApps on 25/10/2021.
//

import UIKit

class ViewController: UICollectionViewController,
                      UICollectionViewDelegateFlowLayout,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {

    var people = [Person]()
    
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let savedData = defaults.object(forKey: "people") as? Data {
            if let people = try? jsonDecoder.decode([Person].self, from: savedData) {
                self.people = people
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("internal error: cell Person does not have class PersonCell")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        
        let pic = UIImage(contentsOfFile: path.path)
        cell.imageView.image = pic

        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        renamePerson(person)
    }
    
    func renamePerson(_ person: Person) {
        
        let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default){ [weak self, weak ac] _ in
            guard let name = ac?.textFields?[0].text else { return }
            person.name = name
            
            self?.save()
            self?.collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "unknown", image: imageName)
        
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
        
        renamePerson(person)
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 180)
    }*/
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let dataToSave = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            
            defaults.set(dataToSave, forKey: "people")
        }
    }

}
