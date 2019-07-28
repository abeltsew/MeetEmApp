//
//  selectViewController.swift
//  MeetEmApp
//
//  Created by Abel Tsegaye on 6/7/19.
//  Copyright © 2019 Abel Tsegaye. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Firebase
import SVProgressHUD

class selectViewController: UIViewController, CLLocationManagerDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         pickedPhone = pickerData[row] as String
    }
    // Add Icon
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> UIImage? {
//        return UIImage(named: "iphone")
//    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    
    
    
    var pickerData = ["All"]
    
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var google_maps: GMSMapView!
    
    var lastLocation : CLLocationCoordinate2D!
    var pickedPhone =  "All"
    
    
    @IBAction func followToggle(_ sender: Any) {
        if lastLocation != nil {
        adjustCamera(position: lastLocation)
        follow = !follow
        } else {
        SVProgressHUD.showError(withStatus: "Unable to locate!!")
        //switchState.isEnabled = false
            
            
            
        }
    }
    
    
    @IBOutlet weak var deviceLable: UILabel!
    
    
    @IBAction func devicePressed(_ sender: Any) {
    }
    
    @IBAction func centerPressed(_ sender: Any) {
        if lastLocation != nil {
       adjustCamera(position: lastLocation)
            
        } else {
          SVProgressHUD.showError(withStatus: "Unable to locate!!")
        }
    }
    
   // let lastLocation : CLLocationCoordinate2D = self.google_maps.camera.target
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
           //create db to get all unique device names
//        var userDB = ""
//        if let userEmail = Auth.auth().currentUser?.email {
//
//            let newString = userEmail.replacingOccurrences(of: ".", with: "-")
//            userDB = String("loc_\(newString)")
//        }
//         let locationDB = Database.database().reference().child(userDB)
//
//        locationDB.observe(.value, with: {(snapshot) in
//
//
//
//            })
        
        //queryOrdered(byChild: "device_name")
        
       // print("location db content: \(locationDB)")
        
     
        
       
        
       picker.delegate = self
       picker.dataSource = self
        
      // pickerData.append("\(UIDevice.current.name) This Device")
        pickerData.append("\(UIDevice.current.name) - This Device")
        deviceLable.text = ""
        
       retriveLocations()
        
        
        // Do any additional setup after loading the view.
    }
    
    func show_marker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        //marker.title = "User name"
        marker.title = Auth.auth().currentUser?.email
        // marker.icon = UIImage(contentsOfFile: "iphone")
        marker.map = google_maps
    }
    
    func adjustCamera(position: CLLocationCoordinate2D){
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 16.0)
        self.google_maps.camera = camera
    }
   
    var initial = 0
    
    var follow : Bool = false
    
    var lastSeenLocations :  [String : CLLocationCoordinate2D] = [:]
    
    func updateLastLocation (deviceName: String) {
        let lastFoundLocation = lastSeenLocations[deviceName]
        
        adjustCamera(position: lastFoundLocation ?? self.google_maps.camera.target)
       show_marker(position: lastFoundLocation ?? self.google_maps.camera.target)
    }
    
    func retriveLocations () {
        
        var userDB = ""
        if let userEmail = Auth.auth().currentUser?.email {
            
            let newString = userEmail.replacingOccurrences(of: ".", with: "-")
            userDB = String("loc_\(newString)")
        }
        
            let locationDB = Database.database().reference().child(userDB)
        
        locationDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let latitude = Double(snapshotValue["latitude"]!)
            let longitude = Double(snapshotValue["longitude"]!)
            let deviceName = String(snapshotValue["device_name"] ?? "unknown") // Unknown returned when some device names fail to return from db
            
            

            // check if selected device existes in Picker or device is unknown and make sure its not current device selectd(to avoide extension THIS Device)
           if (!self.pickerData.contains(deviceName) && deviceName != "unknown") && !(UIDevice.current.name == deviceName) {
                self.pickerData.append(deviceName)
            self.picker.reloadAllComponents()
//
           }
            
            
            // storing last location of all devices
            
                var lastKnownPosition : CLLocationCoordinate2D = self.google_maps.camera.target
                lastKnownPosition.latitude = latitude!
                lastKnownPosition.longitude = longitude!
            
            self.lastSeenLocations.updateValue(lastKnownPosition, forKey: deviceName)
            
            // Updating lable according to the selected device
            
            if self.pickedPhone != "All" {
            self.updateLastLocation(deviceName: self.pickedPhone)
                self.deviceLable.text = "Tracking: \(self.pickedPhone)"
            }else if self.pickedPhone == "All" {
                // Hide lable when all is selected
                self.deviceLable.text = ""
            }
            
            
           
            // Get the coordinates for marker
            
            var plotLocation :CLLocationCoordinate2D = self.google_maps.camera.target
            
            plotLocation.latitude = latitude!
            
            plotLocation.longitude = longitude!
            
            self.lastLocation = plotLocation
           
            
             
            
            
            
            
            //set marker on map for current location out of the DB
            self.show_marker(position: plotLocation)
        
            
            
            // adjusting the camera to follow the selected device
            
            if deviceName == self.pickedPhone || self.pickedPhone.hasSuffix("This Device") {
                
                var selectedDeviceLocation :CLLocationCoordinate2D = self.google_maps.camera.target
                
                selectedDeviceLocation.latitude = latitude!
                selectedDeviceLocation.longitude = longitude!
                
                self.adjustCamera(position: selectedDeviceLocation)
                
                
            }  else {
                // Initiall loading view set here
                
                if self.initial == 0 || self.follow == true {
                self.adjustCamera(position: plotLocation)
                self.initial += 1
                
                
                
            }
                
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
//
//extension selectViewController : GMSMapViewDelegate {
//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        print("View changed set picked phone to all")
//    }
//
//
//}
