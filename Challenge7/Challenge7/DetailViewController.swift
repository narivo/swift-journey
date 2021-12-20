//
//  DetailViewController.swift
//  Challenge7
//
//  Created by MadiApps on 20/12/2021.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {

    var okBarButton: UIBarButtonItem?
    var shareButton: UIBarButtonItem?
    
    var notes = [Note]()
    
    var currentNoteIdx: Int? = nil
    
    @IBOutlet var textView: UITextView!
    
    var currentText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        okBarButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(doneEditing))
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        navigationItem.rightBarButtonItem = shareButton
        
        let remove = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeNote))
        
        toolbarItems = [remove, spacer, compose]

        navigationItem.largeTitleDisplayMode = .never
        
        textView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.notes = loadNotes()
        
        if let noteIdx = currentNoteIdx {
            textView.text = notes[noteIdx].text
        }
        
        currentText = textView.text
        
        formatTextView()
    }
    
    @objc func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            navigationItem.rightBarButtonItem = shareButton
            textView.contentInset = .zero
        } else {
            navigationItem.rightBarButtonItem = okBarButton
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    @objc func doneEditing() {
        view.endEditing(true)
        
        if let noteIdx = currentNoteIdx {
            notes.remove(at: noteIdx)
            notes.insert(Note(text: textView.text), at: noteIdx)
        } else {
            notes.append(Note(text: textView.text))
        }
        
        saveToDefaults()
    }
    
    @objc func shareNote() {
        
        let vc = UIActivityViewController(activityItems: [textView.text ?? ""], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
    
    @objc func deleteNote() {
        
        if let noteIdx = currentNoteIdx {
            notes.remove(at: noteIdx)
        } else {
            notes.removeLast()
        }
        
        saveToDefaults()
        
        navigationController?.popViewController(animated: true)
    }
    
    func saveToDefaults() {
        
        let jsonEncoder = JSONEncoder()
        
        if let dataToSave = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            
            defaults.set(dataToSave, forKey: "notes")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        formatTextView()
    }
    
    func formatTextView() {
                
        let splitted = textView.text.components(separatedBy: "\n")
        let detailSplit = splitted[1..<splitted.count]
        
        var detailsText = detailSplit.joined(separator: "\n")
        detailsText = "\n\(detailsText)"
        
        let titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        let detailsFont = UIFont.systemFont(ofSize: 17)
        
        if let first = splitted.first {
            if #available(iOS 13.0, *) {
                
                let firstAttributes: [NSAttributedString.Key: Any] = [
                    .font: titleFont,
                    .foregroundColor: UIColor.label
                ]
                let secondAttributes: [NSAttributedString.Key: Any] = [
                    .font: detailsFont,
                    .foregroundColor: UIColor.label
                ]
                
                let text = NSMutableAttributedString(string: first, attributes: firstAttributes)
                let details = NSAttributedString(string: detailsText, attributes: secondAttributes)
                text.append(details)
                textView.attributedText = text
                
            } else {
                let firstAttributes: [NSAttributedString.Key: Any] = [
                    .font: titleFont,
                    .foregroundColor: UIColor.black
                ]
                let secondAttributes: [NSAttributedString.Key: Any] = [
                    .font: detailsFont,
                    .foregroundColor: UIColor.black
                ]
                
                let text = NSMutableAttributedString(string: first, attributes: firstAttributes)
                let details = NSAttributedString(string: detailsText, attributes: secondAttributes)
                text.append(details)
                textView.attributedText = text
            }
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
