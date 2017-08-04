//
//  ActionPicksController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 27/11/16.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import Foundation


import UIKit
import AVFoundation
import AsyncDisplayKit
import UberRides
import Firebase

class ActionPicksController: UIViewController, UITableViewDelegate, UITableViewDataSource, ASVideoNodeDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var items = ["Watch Video Again", "Get Directions", "Ride With Uber", "Share"]
    let button = RideRequestButton()
    let asyncVideoController = AsyncVideoViewController()
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    override func viewDidLoad() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      let item = self.items[indexPath.row]
        
        let object = SingletonData.staticInstance.selectedObject
        let lng = object!.lat
        let lat = object!.lng
        
        let loc =  SingletonData.staticInstance.location
        
        if item == "Watch Video Again" {
        
            let imageURL = URL(string: object!.imagePath)
            SingletonData.staticInstance.setVideoImage(imageURL)
            SingletonData.staticInstance.setSelectedVideoItem("https://project-316688844667019748.appspot.com.storage.googleapis.com/" + object!.videoPath)
            
            self.present(asyncVideoController, animated: true, completion: nil)
        }
        
        if item == "Get Directions" {
            
      
            
            let url = URL(string: "http://maps.apple.com/?saddr=\(loc!.coordinate.latitude),\(loc!.coordinate.longitude)&daddr=\(lng),\(lat)")
                UIApplication.shared.openURL(url!)
            
            
        }
        
        if item == "Ride With Uber" {
        
            let pickupLocation = CLLocation(latitude: loc!.coordinate.latitude, longitude: loc!.coordinate.longitude)
            let dropoffLocation = CLLocation(latitude: CLLocationDegrees(lng), longitude: CLLocationDegrees(lat))
            let dropoffNickname = object?.displayTitle
            
            print(dropoffLocation)
            
            let builder = RideParametersBuilder().setPickupLocation(pickupLocation).setDropoffLocation(dropoffLocation, nickname: dropoffNickname)
             let rideParameters = builder.build()
             self.button.requestBehavior.requestRide(rideParameters)

        }
        
        if item == "Share" {
        
        }
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
  
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
         
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                print(placemark.addressDictionary!)
            } else {
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as! ActionPicksCell
//        
        let item = self.items[(indexPath as NSIndexPath).row]
        
        cell.textLbl.text = item
//        let url = URL(string: item.imagePath)
//        
//        cell.pickImage.kf.setImage(with: url)
//        cell.pickImage.asCircle()
//        
//        cell.pickTitle.text = item.displayTitle
//        cell.pickLocation.text = item.taggedLocation
//        
        return cell
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
}
