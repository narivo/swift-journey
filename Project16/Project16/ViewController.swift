//
//  ViewController.swift
//  Project16
//
//  Created by MadiApps on 29/11/2021.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var capitals = [Capital]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCapitals()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(chooseMapType))
        
        mapView.addAnnotations(capitals)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        navigationController?.isToolbarHidden = true
    }
    
    private func initializeCapitals() {
        
        let london = Capital(
            title: "London",
            coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            info: "Home to the 2012 Summer Olympics",
            url: "https://en.wikipedia.org/wiki/London"
        )
        let oslo = Capital(
            title: "Oslo",
            coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75),
            info: "Founded over a thousand years ago.",
            url: "https://en.wikipedia.org/wiki/Oslo"
        )
        let paris = Capital(
            title: "Paris",
            coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508),
            info: "Often called the City of Light.",
            url: "https://en.wikipedia.org/wiki/Paris"
        )
        let rome = Capital(
            title: "Rome",
            coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5),
            info: "Has a whole country inside it.",
            url: "https://en.wikipedia.org/wiki/Rome"
        )
        let washington = Capital(
            title: "Washington DC",
            coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667),
            info: "Named after George himself.",
            url: "https://en.wikipedia.org/wiki/Washington,_D.C."
        )
        
        capitals.append(london)
        capitals.append(oslo)
        capitals.append(paris)
        capitals.append(rome)
        capitals.append(washington)
    }

    @objc func chooseMapType(_ sender: UIBarButtonItem!) {
        let ac = UIAlertController(title: "Change map type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) { [weak mapView] _ in mapView?.mapType = .hybrid })
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) { [weak mapView] _ in mapView?.mapType = .satellite })
        ac.addAction(UIAlertAction(title: "Standard", style: .default) { [weak mapView] _ in mapView?.mapType = .standard })
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default) { [weak mapView] _ in mapView?.mapType = .mutedStandard })
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default) { [weak mapView] _ in mapView?.mapType = .hybridFlyover })
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default) { [weak mapView] _ in mapView?.mapType = .satelliteFlyover })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
        
        present(ac, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Capital") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.pinTintColor = UIColor.red
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? Capital else { return }
        
        let capitalName = annotation.title
        //let capitalInfo = annotation.info
        let url = annotation.url
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Wikiview") as? DetailViewController {
            vc.url = url
            vc.title = capitalName
            
            navigationController?.pushViewController(vc, animated: true)
        }
        /*let ac = UIAlertController(title: capitalName, message: capitalInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
        
        present(ac, animated: true)*/
    }
}

