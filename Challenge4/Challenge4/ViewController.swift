//
//  ViewController.swift
//  Challenge4
//
//  Created by MadiApps on 05/11/2021.
//

import UIKit

class ViewController: UITableViewController,
                      UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var records = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "records") as? Data {
            let jsonDecoder = JSONDecoder()
            
            if let records = try? jsonDecoder.decode([Record].self, from: savedData) {
                self.records = records
                
            }
            
        }
        
    }

    @IBAction func takePhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Record") else { fatalError() }
        
        cell.textLabel?.text = records[indexPath.row].caption
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailsViewController else
        {
            return
            
        }
        
        vc.currentRecord = records[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            try? imageData.write(to: imagePath)
        }
        
        let record = Record(caption: "unknown", image: imageName)
        records.append(record)
                
        dismiss(animated: true)
        
        rename(record: record)
        tableView.reloadData()
    }
    
    func rename(record: Record) {
        let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default){
            [weak self, weak ac, weak record] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            record?.caption = newName
            
            self?.tableView.reloadData()
            
            self?.save()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let dataToSave = try? jsonEncoder.encode(records) {
            let defaults = UserDefaults.standard
            defaults.set(dataToSave, forKey: "records")
        }
    }
}

extension UIViewController {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
