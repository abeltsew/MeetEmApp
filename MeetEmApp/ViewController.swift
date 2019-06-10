//
//  ViewController.swift
//  MeetEmApp
//
//  Created by Abel Tsegaye on 5/22/19.
//  Copyright © 2019 Abel Tsegaye. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    let locationManager = CLLocationManager()
    // var currentLocation = CLLocationCoordinate2D(latitude: 8.989182, longitude: 38.759237)
    var initial = 0
    
    var currentLocation = CLLocationCoordinate2D()
    
    @IBAction func centerPressed(_ sender: Any) {
        viewCenter(pos: currentLocation)
    }
    
    @IBOutlet weak var google_map: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() && Auth.auth().currentUser != nil {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
        
        
        
        // Do any additional setup after loading the view.
        //let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude , zoom: 16.0)
        //let mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        // google_map.camera = camera
        //self.show_marker(position: google_map.camera.target)
        self.google_map.delegate = self
        
    }
    
    func addLocation(position: CLLocationCoordinate2D) {
        var userDB = ""
        if let userEmail = Auth.auth().currentUser?.email {
            
            let newString = userEmail.replacingOccurrences(of: ".", with: "-")
             userDB = String("loc_\(newString)")
        }
       
       // print(userDB)
        
        let myDatabase = Database.database().reference().child(userDB)
        
        
        let record = ["user_email": Auth.auth().currentUser?.email,
                      "latitude": "\(position.latitude)",
            "longitude": "\(position.longitude)",
            "device_udid": UIDevice.current.identifierForVendor!.uuidString,
            "device_name": UIDevice.current.name,
            "timestamp": "\(Date())"
            
        ]
        
        myDatabase.childByAutoId().setValue(record)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if Auth.auth().currentUser != nil {
        if let location = locations.first {
            print(location.coordinate)
            show_marker(position: location.coordinate)
            currentLocation = location.coordinate
            
            // currentLocation = location.coordinate
            if initial == 0 { // set first view based on current loction
                viewCenter(pos: location.coordinate)
                initial += 1
            }
        }
    }
    }
    
    func viewCenter (pos: CLLocationCoordinate2D){
        let camera = GMSCameraPosition.camera(withLatitude: pos.latitude, longitude: pos.longitude , zoom: 16.0)
        google_map.camera = camera
    }
    
    
    func show_marker(position: CLLocationCoordinate2D)  {
        
        if Auth.auth().currentUser != nil {
            
        let marker = GMSMarker()
        marker.position = position
         addLocation(position: position)
        
        //print("\(position.latitude)")
        
        //marker.title = "Addis"
        //marker.snippet = "Capital of Addis"
        marker.map = google_map
        }
    }
}
extension ViewController : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("clicked on Markert")
    }
}

