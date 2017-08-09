//
//  PhotoViewController.swift
//  ThrilJunkyBusiness
//
//  Created by Brad Lietz on 2/7/17.
//  Copyright © 2017 ThrilJunky LLC. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import APESuperHUD

class PhotoViewController: UIViewController {
    
    let storageRef = FIRStorage.storage().reference()
    var user = FIRAuth.auth()?.currentUser!
    let ref =  FIRDatabase.database().reference()
    
    var businessName : String = ""
    var address : String = ""
    var phone : String = ""
    var website : String = ""
    var key : String = ""
    var latitude : Float = 0.0
    var longitude : Float = 0.0
    var aKey : String = ""
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var backgroundImage: UIImage
    
    init(image: UIImage) {
        self.backgroundImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.gray
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
        backgroundImageView.image = backgroundImage
        view.addSubview(backgroundImageView)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(UIImage(named: "icons8-delete_sign_filled"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let addButton = UIButton(frame: CGRect(x:  self.view.frame.width - 40.0, y: 10.0, width: 30.0, height: 30.0))
        addButton.tintColor = UIColor.white
        addButton.setImage(UIImage(named: "icons8-checkmark_filled"), for: UIControlState())
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    func generatePhotoThumbnail(_ image: UIImage) -> UIImage {
        // Create a thumbnail version of the image for the event object.
        let size: CGSize = image.size
        var croppedSize: CGSize
        let ratio: CGFloat = 64.0
        var offsetX: CGFloat = 0.0
        var offsetY: CGFloat = 0.0
        // check the size of the image, we want to make it
        // a square with sides the size of the smallest dimension
        if size.width > size.height {
            offsetX = (size.height - size.width) / 2
            croppedSize = CGSize(width: CGFloat(size.height), height: CGFloat(size.height))
        }
        else {
            offsetY = (size.width - size.height) / 2
            croppedSize = CGSize(width: CGFloat(size.width), height: CGFloat(size.width))
        }
        // Crop the image before resize
        let clippedRect = CGRect(x: CGFloat(offsetX * -1), y: CGFloat(offsetY * -1), width: CGFloat(croppedSize.width), height: CGFloat(croppedSize.height))
        let imageRef: CGImage? = image.cgImage?.cropping(to: clippedRect)
        // Done cropping
        // Resize the image
        let rect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: ratio, height: ratio)
        UIGraphicsBeginImageContext(rect.size)
        UIImage(cgImage: imageRef!).draw(in: rect)
        let thumbnail: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Done Resizing
        return thumbnail!
    }
    
    
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func add() {
        
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Uploading...", presentingView: self.view)
        
        DispatchQueue.main.async {
            
            self.ref.child("businesses").queryOrdered(byChild: "uid").queryEqual(toValue: SingletonData.staticInstance.selectedObject!.key).observe(.value, with: { (snapshot) in
                // Get user value
                
                for item in snapshot.children {
                    let business = BusinessModel(snapshot: item as! FIRDataSnapshot)
                    
                    self.businessName = business.businessName
                    self.address = business.address
                    self.website = business.website
                    self.phone = business.phone
                    self.key = business.uid
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
            let data = UIImageJPEGRepresentation(self.backgroundImage.resized(withPercentage: 0.60)!, 0.40) as Data?
             let a = self.ref.child("videos").childByAutoId().key
              let stoRef = self.storageRef.child("images/\(self.user!.uid)/\(a).jpg")
            self.aKey = a
            let imgMetadata = FIRStorageMetadata()
            imgMetadata.contentType = "image/jpeg"
            let uploadTask = stoRef.put(data!, metadata: imgMetadata) { (metadata, error) in
                
            }
            
            // Listen for state changes, errors, and completion of the upload.
            uploadTask.observe(.pause) { snapshot in
                // Upload paused
            }
            
            uploadTask.observe(.resume) { snapshot in
                // Upload resumed, also fires when the upload starts
            }
            
            uploadTask.observe(.progress) { snapshot in
                
            }
            
            uploadTask.observe(.failure) { snapchat in
                APESuperHUD.showOrUpdateHUD(icon: IconType.sadFace, message: "Incomplete.. Try again", presentingView: self.view, completion: nil)
            }
            
            
            uploadTask.observe(.success) { snapshot in
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
                dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                
                print(dateFormatter.string(from: date))
                let parseDate = dateFormatter.string(from: date)
            
                let image = ["uid": self.user!.uid,
                             "displayTitle": self.businessName,
                             "displayName": self.businessName,
                             "userGenerated": "true",
                             "address": self.address,
                             "videoPath" : "-",
                             "imagePath": "https://project-316688844667019748.appspot.com.storage.googleapis.com/images/\(self.user!.uid)/\(self.aKey).jpg",
                             "latitude": "\(SingletonData.staticInstance.selectedObject!.lat)",
                    // "tags": tags,
                    "longitude": "\(SingletonData.staticInstance.selectedObject!.lng)",
                    "createdAt": parseDate] as [String : Any]
                
                self.ref.updateChildValues(["/videos/\(self.aKey)": image])

   
                APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "Completed", presentingView: self.view, completion: {
                    APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: { _ in
                        // Completed
                    })
                    self.dismiss(animated: true, completion: {
                        
                    })
                    
                })
                
            }
        }
    }
}

