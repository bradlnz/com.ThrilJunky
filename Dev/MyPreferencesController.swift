//
//  MyProfileViewController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 15/02/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import AVKit
import MapKit
import Firebase
import AVFoundation
//import MGSwipeTableCell
import FBSDKLoginKit
import FBSDKShareKit
import FBSDKCoreKit
//import PKHUD
//import Kingfisher

class MyPreferencesController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var preferencesView: UIView!

    let user = FIRAuth.auth()?.currentUser

    var ref: FIRDatabaseReference?
    let videosRef = FIRDatabase.database().reference(withPath: "profiles")
    let storage = FIRStorage.storage()
    var videos: Array<FIRDataSnapshot> = []
    var refHandle: FIRDatabaseHandle?
    var isFinishedPlaying : Bool = false
    let closeBtn = UIButton(type: UIButtonType.system) as UIButton
    var objs: [AnyObject?] = []
    var photoLoaded : Bool = false
    var distanceValue : Int = 1
    
    @IBAction func dismissPreferences(_ sender: Any) {
     //   self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBAction func sliderForDistanceChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        distance.text = "\(currentValue) mi"
        
        self.ref = FIRDatabase.database().reference()
        
        
        let userId = FIRAuth.auth()?.currentUser?.uid

        self.ref?.child("profiles").child(userId!).child("maxDistance").updateChildValues(["setDistance" : sender.value])
    }
    
    

    @IBAction func logout(_ sender: Any) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
           
            DispatchQueue.main.async{
                let viewController:UIViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginScreen")
                self.present(viewController, animated: true, completion: nil)
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let remoteConfig = FIRRemoteConfig.remoteConfig()
        
        remoteConfig.fetch(withExpirationDuration: 0, completionHandler: { (status, error) in
            
            print(status)
            remoteConfig.activateFetched()
            
            
            
            let max_distance = remoteConfig.configValue(forKey: "max_radius").numberValue as! Float
            
            SingletonData.staticInstance.setDistance(max_distance)
            
           
            let min_distance = remoteConfig.configValue(forKey: "min_radius").numberValue as! Float
        
            SingletonData.staticInstance.setMinDistance(input: min_distance)
            
    
            if(SingletonData.staticInstance.setDistance != nil) {
                self.distanceSlider.maximumValue = Float(SingletonData.staticInstance.setDistance!)
            }
            
            
            if(SingletonData.staticInstance.minDistance != nil) {
                self.distanceSlider.minimumValue = Float(SingletonData.staticInstance.minDistance!)
            }
            
        })
        
     
        self.preferencesView.isHidden = false
        let currentUser = FIRAuth.auth()?.currentUser
          self.ref = FIRDatabase.database().reference()
        
self.ref!.child("profiles").child(currentUser!.uid).child("maxDistance").queryOrderedByValue().observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            print(snapshot)
            
            if snapshot.hasChildren(){
                for item in snapshot.children {
                    let childSnapshot = item as! FIRDataSnapshot
                    
                    let itemVal = childSnapshot.value as! Int
                    self.distanceValue = Int(itemVal)
                    self.distanceSlider.setValue(Float(self.distanceValue), animated: true)
                    self.distance.text = "\(self.distanceValue) mi"
                }
            }
        }
    }

//    func buttonClicked(){
//        DispatchQueue.main.async {
//            
//            DispatchQueue.main.async {
//                self.present(self.asyncVideoController, animated: true) { () -> Void in
//                }
//            }
//        }
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//   
//        SingletonData.staticInstance.setVideoPlayed(nil)
//        SingletonData.staticInstance.setSelectedVideoItem(nil)
//        SingletonData.staticInstance.setSelectedObject(nil)
//        let item = self.videoItems[indexPath.row]
//      
//
// 
//        
//        let imageURL = URL(string: item.imagePath)
//        SingletonData.staticInstance.setVideoImage(imageURL)
//        //   SingletonData.staticInstance.setSelectedVideoItem("https://1096606134.rsc.cdn77.org/" + ann.videoPath!)
//        SingletonData.staticInstance.setSelectedVideoItem("https://project-316688844667019748.appspot.com.storage.googleapis.com/videos/" + item.videoPath)
//        buttonClicked()
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.videoItems.count
//        
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.yourCollectionTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! YourCollectionTableViewCell
//        let item = self.videoItems[(indexPath as NSIndexPath).row]
//        let url = URL(string: item.imagePath)
//    
//        cell.imgView.kf.setImage(with: url)
//        cell.imgView.asCircle()
//        cell.displayTitle.text = item.displayTitle
//    
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
//        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//        let date = dateFormatter.date(from: item.createdAt)
//        cell.timeSince.text = SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true)
//        
//        return cell
//    }
    
    

    override func viewWillAppear(_ animated: Bool) {
         //  UIApplication.shared.isStatusBarHidden = true
   
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      //   UIApplication.shared.isStatusBarHidden = false
    }


        
      //  if self.photoLoaded == false {
     //   DispatchQueue.main.async {
       
        //    if self.user != nil {
        //        if self.user?.photoURL != nil {
         //           let imgData = try? Data(contentsOf: self.user!.photoURL!)
         //           if imgData != nil {
          //              let img = UIImage(data: imgData!)
           //             let size = CGSize(width: 130, height: 130)
           //             let resizedImage = self.imageResize(img!, sizeChange: size)
                 //       self.profilePicture.image = resizedImage
                      //   self.profilePicture.asCircle()
                     //   self.coverPhoto.image = img
             //            self.photoLoaded = true
             //       }
            ///    }
                
               
          //  }
        //  }
       // }
    


    
     func loadImageFromUrl(_ url: String) -> UIImage?{
        
        // Create Url from string
        let url = URL(string: url)!
        let imgData = try? Data(contentsOf: url)
        let img = UIImage(data: imgData!)
        return img
    }
    

    
    func loadProfilePic(_ image: UIImage) {
        
     //   DispatchQueue.main.async(execute: {
     // //      self.profilePicture.image = image
    //    })
    }
    
    @IBAction func closeProfile(_ sender: AnyObject) {
             DispatchQueue.main.async {
        self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func imageResize (_ image: UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
//    @IBAction func changeProfilePicture(sender: AnyObject) {
//        profilePictureImagePicker.allowsEditing = false
//        profilePictureImagePicker.sourceType = .PhotoLibrary
//        SingletonData.staticInstance.setSelectedPicker("profile")
//        presentViewController(profilePictureImagePicker, animated: true, completion: nil)
//    }
    
    
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        
//          let user = FIRAuth.auth()?.currentUser
//        
//        switch(SingletonData.staticInstance.selectedPicker){
//            case "profile":
//     
//              HUD.show(.Progress)
//                // Create the file metadata
//                let profileImgMetadata = FIRStorageMetadata()
//                profileImgMetadata.contentType = "image/jpeg"
//                let storageImgRef = self.storage.reference()
//                  let photoRef = storageImgRef.child("images/" + user!.uid)
//                
//                   let imageData = UIImageJPEGRepresentation(image, 0.50)
//                // Upload file and metadata to the object 'images/mountains.jpg'
//                let uploadTask = storageImgRef.child("images/" + user!.uid).putData(imageData!, metadata: profileImgMetadata)
//                
//                // Listen for state changes, errors, and completion of the upload.
//                uploadTask.observeStatus(.Pause) { snapshot in
//                    // Upload paused
//                }
//                
//                uploadTask.observeStatus(.Resume) { snapshot in
//                    // Upload resumed, also fires when the upload starts
//                }
//                
//                uploadTask.observeStatus(.Progress) { snapshot in
//                    
//
//                    
//                }
//                
//                uploadTask.observeStatus(.Success) { snapshot in
//                    
//                    HUD.hide()
//                    
//                    photoRef.downloadURLWithCompletion({ (URL, error) in
//                        
//                        if let user = user {
//                            let changeRequest = user.profileChangeRequest()
//                            
//                            changeRequest.photoURL = URL?.absoluteURL
//                            changeRequest.commitChangesWithCompletion { error in
//                                if let error = error {
//                                    // An error happened.
//                                    print(error)
//                                } else {
//                                    // Profile updated.
//                                    print("profile updated.")
//                                    self.coverPhoto.image = image
//                                    let size = CGSizeMake(130, 130)
//                                    let resizedImage = self.imageResize(image, sizeChange: size)
//                                    self.profilePicture.image = resizedImage
//                                }
//                            }
//                        }
//                    })
//                }
//
//            break
//            
//            default:
//            
//            break
//            
//        }
//    
//        
//         dismissViewControllerAnimated(true, completion: nil)
//    }
  
    
    func compressJpeg(_ image: UIImage?) -> Data?{
        var compressedImageData: Data?
        if var imageCompressed = image {
      
                compressedImageData = UIImageJPEGRepresentation(imageCompressed, 0.0)
                imageCompressed = UIImage(data: compressedImageData!)!
      
        }else{
            compressedImageData = nil
        }
        return compressedImageData
    }
    
    
    func ResizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deinit") // never gets called
    }

}
