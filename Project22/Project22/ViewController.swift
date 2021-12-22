//
//  ViewController.swift
//  Project22
//
//  Created by MadiApps on 21/12/2021.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconReading: UILabel!
    @IBOutlet var circleView: UIView!
    
    var locationManager: CLLocationManager?
    var beaconDetected = false
    var currentBeaconID = "Unknown" {
        didSet {
            beaconReading.text = currentBeaconID
        }
    }
    
    var beaconRegion1: CLBeaconRegion!
    var beaconRegion2: CLBeaconRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        circleView.layer.borderWidth = 1
        if #available(iOS 13.0, *) {
            circleView.layer.borderColor = UIColor.label.cgColor
        } else {
            circleView.layer.borderColor = UIColor.black.cgColor
        }
        circleView.layer.cornerRadius = 128
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            self.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid1 = UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!
        beaconRegion1 = CLBeaconRegion(proximityUUID: uuid1, major: 0, minor: 0, identifier: "Beacon1")
        
        let uuid2 = UUID(uuidString: "52414449-5553-4E45-5457-4F524B53434F")!
        beaconRegion2 = CLBeaconRegion(proximityUUID: uuid2, major: 123, minor: 256, identifier: "Beacon2")

        locationManager?.startMonitoring(for: beaconRegion1)
        locationManager?.startRangingBeacons(in: beaconRegion1)
        
        locationManager?.startMonitoring(for: beaconRegion2)
        locationManager?.startRangingBeacons(in: beaconRegion2)
    }
    
    func update(_ distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            switch distance {
            case .far:
                self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.circleView.transform = .identity
            default:
                self.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("region: \(region.proximityUUID)")
                
        if let beacon = beacons.first {
            if beaconDetected == false {
                beaconDetected = true
                let ac = UIAlertController(title: "Beacon !", message: "Your first detected beacon", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
            print("beacon \(beacon.proximityUUID)")
            
            if beacon.proximityUUID == beaconRegion1.proximityUUID {
                currentBeaconID = "Beacon1"
            } else if  beacon.proximityUUID == beaconRegion2.proximityUUID {
                currentBeaconID = "Beacon2"
            }
            
            if region.proximityUUID == beacon.proximityUUID {
                update(beacon.proximity)
            }
        }/* else {
            update(.unknown)
        }*/
    }
    
}

