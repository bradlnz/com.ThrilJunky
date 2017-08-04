//
//  YourPicksController.swift
//  ThrilJunky
//
//  Created by Lietz on 5/11/16.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Firebase
import MapKit
import Photos
//import GeoFire
import Kingfisher
class YourPicksController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var videosPicked : [RealmObject] = []

 let videosRef = FIRDatabase.database().reference(withPath: "profiles")
    
    
    @IBOutlet weak var pickTable: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidLoad() {
        
        self.pickTable.dataSource = self
        self.pickTable.delegate = self
        
        let currentUser = FIRAuth.auth()?.currentUser
        
        DispatchQueue.main.async {
            self.videosRef.child(currentUser!.uid).child("picks").queryOrdered(byChild: "show").queryEqual(toValue: "true").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
                print(snapshot)
                if snapshot.hasChildren(){

                    for snap in snapshot.children.reversed(){
                        
                        let item = FIRItem(snapshot: snap as! FIRDataSnapshot)

                        let numberFormatter = NumberFormatter()
                        let lat = numberFormatter.number(from: item.latitude)
                        let lng = numberFormatter.number(from: item.longitude)
                        
                        
                        let obj = RealmObject()
                        
                        obj.ActivityCategories = item.ActivityCategories
                        obj.SubActivityCategories = item.SubActivityCategories
                        obj.RefinedActivityCategories = item.RefinedActivityCategories
                        obj.address = item.address
                        obj.createdAt = item.createdAt
                        obj.displayName = item.displayName
                        obj.displayTitle = item.displayTitle
                        obj.imagePath = item.imagePath
                        obj.key = item.key
                        obj.lat = Float(lat!)
                        obj.lng = Float(lng!)
                        obj.videoPath = item.videoPath
                        obj.website = item.website
                      
                        self.videosPicked.append(obj)
                   
                    }
                    
                    self.pickTable.reloadData()
                 
                }
            }
        }

        
    }
    
    @IBAction func closeBtn(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.videosPicked.count
     
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let currentUser = FIRAuth.auth()?.currentUser
            var item = self.videosPicked[indexPath.row]
            self.videosRef.child(item.key).removeValue()
            self.videosRef.child(currentUser!.uid).child("picks").child(item.key).removeValue()
            self.videosRef.child(currentUser!.uid).child("swiped").child(item.key).removeValue()
            self.videosPicked.remove(at: indexPath.row)
            self.pickTable.reloadData()
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        SingletonData.staticInstance.setSelectedObject(self.videosPicked[indexPath.row])
       
     self.performSegue(withIdentifier: "moreInfoBucketSegue", sender: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = self.pickTable.dequeueReusableCell(withIdentifier: "cell")! as! YourPicksCell
        
        let item = self.videosPicked[(indexPath as NSIndexPath).row]
        let url = URL(string: item.imagePath)
        
        cell.pickImage.kf.setImage(with: url)
        cell.pickImage.asCircle()

        cell.pickTitle.text = item.displayTitle
        cell.pickLocation.text = item.address
        
        return cell
    }
    
    

}
