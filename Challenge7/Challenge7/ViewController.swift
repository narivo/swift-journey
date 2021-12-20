//
//  ViewController.swift
//  Challenge7
//
//  Created by MadiApps on 20/12/2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeNote))
        
        toolbarItems = [spacer, compose]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Notes"
        
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.notes = loadNotes()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath) as? TableViewCell else { fatalError() }
    
        let currentNote = notes[indexPath.row]
        
        let splitted = currentNote.text.components(separatedBy: "\n")        
        let detailSplit = splitted[1..<splitted.count]
        let detailsText = detailSplit.joined(separator: "\n")
        
        cell.titleLabel.text = splitted.first
        cell.detailLabel.text = detailsText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController else { return }
        vc.currentNoteIdx = indexPath.row
        vc.notes = self.notes
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

extension UIViewController {
    
    
    func loadNotes() -> [Note] {
        
        var notes = [Note]()
        
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let savedData = defaults.object(forKey: "notes") as? Data {
            if let savedNotes = try? jsonDecoder.decode([Note].self, from: savedData) {
                notes = savedNotes
            }
        }
        
        return notes
    }
    
    @objc func composeNote() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

