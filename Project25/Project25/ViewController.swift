//
//  ViewController.swift
//  Project25
//
//  Created by MadiApps on 07/01/2022.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController,
                      UICollectionViewDelegateFlowLayout,
                      UINavigationControllerDelegate,
                      UIImagePickerControllerDelegate,
                      SelfieMultiPeerDelegate {

    var selfieSession = SelfieMultipeerSession()
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Selfie Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showConnectedPeers))
        
        selfieSession.selfieDelegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
            
        }
        
        return cell
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    /*func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
     
}*/

    @objc func showConnectedPeers() {
        let ac = UIAlertController(title: "Connected Peers", message: nil, preferredStyle: .actionSheet)
        for peer in selfieSession.connectedPeers {
            ac.addAction(UIAlertAction(title: "\(peer.displayName)", style: .default) { [weak self] _ in
                let stringToDecode = "ABCDEFG"
                let data = Data(stringToDecode.utf8)
                if let peers = self?.selfieSession.connectedPeers {
                    self?.selfieSession.send(data, toPeers: peers, with: .unreliable)
                }
            })
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        if let imageData = image.pngData() {
            selfieSession.send(imageData, toPeers: selfieSession.connectedPeers, with: .reliable)
        }
    }
    
    func selfie(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else {
                let decodedString = String(decoding: data, as: UTF8.self)
                debugPrint(decodedString)
            }
        }
        
        
            
    }
    
    func selfie(lostPeer peerID: MCPeerID) {
        let ac = UIAlertController(title: "Lost peer", message: "\(peerID.displayName) has disconnected", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
