//
//  AsyncVideoViewController.swift
//  ThrilJunky
//
//  Created by Lietz on 27/09/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import AVFoundation
import AsyncDisplayKit
import UberRides
import Firebase

class AsyncVideoViewController: UIViewController, ASVideoNodeDelegate {

    var videoNode = ASVideoNode()
    let videosRef = FIRDatabase.database().reference(withPath: "videos")
    let locationsRef = FIRDatabase.database().reference(withPath: "locations")
    let storage = FIRStorage.storage()
    let geofireRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    var videos: Array<FIRItem> = []
    var mostRecentVideos : Array<FIRItem> = []
    var keys : Array<String> = []
    var mostPopularVideos : [FIRItem] = []
    var followingVideosList : [FIRItem] = []
    var refHandle: FIRDatabaseHandle?
  
    
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var blurEffectView : UIVisualEffectView?
    var callButton = UIButton(frame: CGRect(x: 0, y: 0, width: 210, height: 40))
    var websiteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 210, height: 40))
    var getDirectionsButton = UIButton(frame: CGRect(x: 0, y: 00, width: 210, height: 40))
    var closeButton = UIButton(type: UIButtonType.system) as UIButton
   // let voteUpBtn = UIButton(type: UIButtonType.system) as UIButton
   // let voteUpBtnDone = UIButton(type: UIButtonType.system) as UIButton
    //var rideWithUberbutton = RequestButton()
   
    let wouldYouDoThisLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let profileLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let userHint = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let userHintText = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let DisplayTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let Desc = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let imageViewProfile = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let closeBtn = UIButton(type: UIButtonType.system) as UIButton
 //   let tickBtn = UIButton(type: UIButtonType.system) as UIButton
    
    var isFinishedPlaying : Bool = false
    let dateFormatter = DateFormatter()
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        videoNode.delegate = self
        
        let link = SingletonData.staticInstance.selectedVideoItem
        
        if link != nil {
        let asset = AVAsset(url: URL(string: link!)!)

            let origin = CGPoint.zero
            let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            videoNode.asset = asset
            videoNode.shouldAutoplay = true
            videoNode.shouldAutorepeat = false
            videoNode.muted = false
            
            videoNode.frame = CGRect(origin: origin, size: size)
            videoNode.url = SingletonData.staticInstance.videoImage as URL?
        
        }

        
        
        self.profileLabel.textColor = UIColor.white
        self.timeLabel.textColor = UIColor.white
        self.userHint.textColor = UIColor.white
        self.userHintText.textColor = UIColor.white
        self.DisplayTitle.textColor = UIColor.white
        self.DisplayTitle.font = UIFont(name: "HelveticaNeue", size: 22)
        self.DisplayTitle.numberOfLines = 5
        self.DisplayTitle.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
//        self.wouldYouDoThisLabel.textColor = UIColor.white
//        self.wouldYouDoThisLabel.text = "Would you do this?"
        
        DispatchQueue.main.async {
            
            
            let annotation = SingletonData.staticInstance.selectedAnnotation
            let selectedObj = SingletonData.staticInstance.selectedObject
            
            
            
            
            if annotation != nil {
                
                SingletonData.staticInstance.setKey(annotation?.key)
                
                if annotation?.createdAt != nil {
                    self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
                    self.dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                  //  let date = self.dateFormatter.date(from: annotation!.createdAt!)
                    
                  //  self.timeLabel.text = SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true)
                    
                }
                
                if annotation?.displayHint != nil {
                    self.userHintText.text = annotation?.displayHint
                }
                if annotation?.displayName != nil {
                    self.profileLabel.text = annotation?.displayName
                }
                if annotation?.displayMsg != nil {
                    self.Desc.text = annotation?.displayMsg
                }
                if annotation?.displayTitle != nil {
                    self.DisplayTitle.text = annotation?.title
                }
                
            }
            
            if selectedObj != nil {
                
                SingletonData.staticInstance.setKey(selectedObj!.key)
                
                self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
                self.dateFormatter.timeZone = TimeZone.autoupdatingCurrent
              //  let date = self.dateFormatter.date(from: selectedObj!.createdAt)
                
              //  self.timeLabel.text = SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true)
                
           //     self.userHintText.text = selectedObj?.displayHint
                
                self.profileLabel.text = selectedObj?.displayName
                
         //       self.Desc.text = selectedObj?.displayMsg
                
                self.DisplayTitle.text = selectedObj?.displayTitle
                
                
            }
            
            
            
//            self.tickBtn.tintColor = UIColor.white
//            let voteUpImg = UIImage(named: "done")!
//            self.tickBtn.setImage(voteUpImg, for: UIControlState())
//            
//            self.tickBtn.addTarget(self, action: #selector(self.voteUp(_:)), for: UIControlEvents.touchUpInside)
            
            self.closeBtn.tintColor = UIColor.white
            let image = UIImage(named: "close")!
            self.closeBtn.setImage(image, for: UIControlState())
            
            self.closeBtn.addTarget(self, action: #selector(self.voteDown(_:)), for: UIControlEvents.touchUpInside)
            
            
            
//            self.wouldYouDoThisLabel.translatesAutoresizingMaskIntoConstraints = false
//            
//            self.wouldYouDoThisLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
//            
//            self.wouldYouDoThisLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
//            
            
            self.DisplayTitle.translatesAutoresizingMaskIntoConstraints = false
            self.DisplayTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
            self.DisplayTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            self.DisplayTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.DisplayTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.DisplayTitle.textAlignment = NSTextAlignment.center
            
            self.Desc.translatesAutoresizingMaskIntoConstraints = false
            self.Desc.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
            self.Desc.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            
            self.profileLabel.translatesAutoresizingMaskIntoConstraints = false
            self.profileLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
            self.profileLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            
            self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
            self.timeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
            self.timeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            
//            self.tickBtn.translatesAutoresizingMaskIntoConstraints = false
//            self.tickBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
//            self.tickBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            
            
            self.closeBtn.translatesAutoresizingMaskIntoConstraints = false
            self.closeBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
            self.closeBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            
        }
        
        let blurEffectVideoMenu = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectViewVideoMenu = UIVisualEffectView(effect: blurEffectVideoMenu)
        //always fill the view
        blurEffectViewVideoMenu.frame =  CGRect(x: 0, y: UIScreen.main.bounds.height + 100, width: UIScreen.main.bounds.width, height: 150)
        blurEffectViewVideoMenu.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.blurEffectView = blurEffectViewVideoMenu
        
        
        view.addSubnode(videoNode)
        
        self.view.addSubview(self.closeBtn)
       // self.view.addSubview(self.tickBtn)
        self.view.addSubview(self.timeLabel)
        self.view.addSubview(self.profileLabel)
     //   self.view.addSubview(self.wouldYouDoThisLabel)
        self.view.addSubview(self.Desc)
        self.view.addSubview(self.DisplayTitle)
        self.view.addSubview(self.blurEffectView!)
        

    }
    
//    func voteUp(_ sender: UIButton!){
//        
//        self.tickBtn.isEnabled = false
//        var count = 0
//        
//        if !self.isFinishedPlaying {
//            
//            let key = SingletonData.staticInstance.key
//            
//            
//            self.videosRef.child(key!).observe(.value, with: { (snapshot) in
//                
//                var snap = FIRItem(snapshot: snapshot)
//                
//                if(snap != nil){
//                    if count == 0 {
//                        self.videosRef.child(key!).updateChildValues(["voteUp": snap.voteUp + 1])
//                        let videoCount : Float = Float(self.mostPopularVideos.count)
//                        
//                        print(videoCount)
//                        
//                        let votes : Float = Float(snap.voteUp - snap.voteDown)
//                        
//                        print(votes)
//                        
//                        
//                        self.videosRef.child(key!).updateChildValues(["averageVote": votes])
//                        
//                        
//                        count = 1
//                    }
//                }
//                
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//            
//            
//            stopVideo(sender)
//            
//        }
//    }
    
    func voteDown(_ sender: UIButton!){
//        self.closeBtn.isEnabled = false
//        var count = 0
//        
//        if !self.isFinishedPlaying {
//            let key = SingletonData.staticInstance.key
//            var snap : FIRItem?
//            
//            self.videosRef.child(key!).queryLimited(toFirst: 1).observe(.value, with: { (snapshot) in
//                
//                
//                snap = FIRItem(snapshot: snapshot)
//                
//                if(snap != nil){
//                    if count == 0 {
//                        self.videosRef.child(key!).updateChildValues(["voteDown": snap!.voteDown + 1])
//                        let videoCount : Float = Float(self.mostPopularVideos.count)
//                        
//                        print(videoCount)
//                        
//                        let votes : Float = Float(snap!.voteUp - snap!.voteDown)
//                        
//                        print(votes)
//                        
//                        
//                        self.videosRef.child(key!).updateChildValues(["averageVote": votes])
//                        
//                        count = 1
//                    }
//                }
//                
//                
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//            
//            
//        }
        
        stopVideo(sender)
    }
    
    
    func stopVideo(_ sender: UIButton!){
        DispatchQueue.main.async {
            
            self.closeBtn.isEnabled = true
           // self.tickBtn.isEnabled = true
            self.blurEffectView!.removeFromSuperview()
            self.getDirectionsButton.removeFromSuperview()
           // self.rideWithUberbutton.removeFromSuperview()
            self.closeButton.removeFromSuperview()
            self.callButton.removeFromSuperview()
            self.websiteButton.removeFromSuperview()
            
      
           // SingletonData.staticInstance.setSelectedVideoItem(nil)
          //  SingletonData.staticInstance.setSelectedObject(nil)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    func postVideoScreen(){
        DispatchQueue.main.async {
        
//            let loc = SingletonData.staticInstance.location
//            
//            if loc != nil {
//                 //var rideWithUberbutton = RequestButton()
//                self.rideWithUberbutton.setPickupLocation(latitude: loc!.coordinate.latitude, longitude: loc!.coordinate.longitude, nickname: "Pickup")
//            }
            
            let object = SingletonData.staticInstance.selectedAnnotation
            
            self.callButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 320)
            
            
            let locDrop = object?.coordinate
            if locDrop != nil
            {
//                let lat = locDrop?.latitude
//                let lng = locDrop?.longitude
                
//                if lat != nil && lng != nil
//                {
                //                 //var rideWithUberbutton = RequestButton()
                //                self.rideWithUberbutton.setPickupLocation(latitude: loc!.coordinate.latitude, longitude: loc!.coordinate.longitude, nickname: "Pickup")
//                    self.rideWithUberbutton.setDropoffLocation(latitude: lat!, longitude: lng!, nickname: "Dropoff")
//                }
            }
            self.view.backgroundColor = UIColor.clear
            
            self.dismiss(animated: true, completion: {
                
            })
          //  self.blurEffectView = UIVisualEffectView(effect: self.blurEffect)
            //always fill the view
          //  self.blurEffectView!.frame =  UIScreen.main.bounds
          //  self.blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            
            
           // self.getDirectionsButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 290)
          //  self.getDirectionsButton.tintColor = UIColor.white
          //  self.getDirectionsButton.backgroundColor = UIColor.purple
          //  self.getDirectionsButton.setTitle("Get Directions", for: UIControlState())
           // self.getDirectionsButton.addTarget(self, action: #selector(self.routeToVideo(_:)), for: UIControlEvents.touchUpInside)
            
           // self.closeButton.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
          //  self.closeButton.tintColor = UIColor.white
            
           // let image : UIImage = UIImage(named: "close")!
            
           // self.closeButton.setImage(image, for: UIControlState())
          //  self.closeButton.addTarget(self, action: #selector(self.voteDown(_:)), for: UIControlEvents.touchUpInside)
            
//            self.tickBtn.tintColor = UIColor.white
//            let voteUpImg = UIImage(named: "done")!
//            self.tickBtn.setImage(voteUpImg, for: UIControlState())
//            self.tickBtn.addTarget(self, action: #selector(self.voteUp(_:)), for: UIControlEvents.touchUpInside)
            
            
            //                 //var rideWithUberbutton = RequestButton()
            //                self.rideWithUberbutton.setPickupLocation(latitude: loc!.coordinate.latitude, longitude: loc!.coordinate.longitude, nickname: "Pickup")
            //                    self.rideWithUberbutton.setDropoffLocation(latitude: lat!, longitude: lng!, nickname: "Dropoff")
        
//            let uberWrapper = UIView()
//            uberWrapper.addSubview(self.rideWithUberbutton)
//            
//            let horizontalConstraint = NSLayoutConstraint(item: self.rideWithUberbutton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: uberWrapper, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
//            let verticalConstraint = NSLayoutConstraint(item: self.rideWithUberbutton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: uberWrapper, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
//            
//            uberWrapper.addConstraints([horizontalConstraint, verticalConstraint])
//            uberWrapper.frame = CGRect(origin: CGPointMake((UIScreen.mainScreen().bounds.width - 200) / 2, 320), size: self.rideWithUberbutton.intrinsicContentSize())
//            
//            
//            
//        
            
//            self.tickBtn.translatesAutoresizingMaskIntoConstraints = false
//            self.tickBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
//            self.tickBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            
          //  self.profileLabel.translatesAutoresizingMaskIntoConstraints = false
          //  self.profileLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
          //  self.profileLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            
          //  self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
          //  self.timeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
          //  self.timeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            
            
            
          //  self.wouldYouDoThisLabel.translatesAutoresizingMaskIntoConstraints = false
            
           // self.wouldYouDoThisLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
            
           // self.wouldYouDoThisLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            
            
            if SingletonData.staticInstance.userProfileImage != nil {
                
                self.imageViewProfile.isHidden = true
                self.imageViewProfile.layer.cornerRadius = (self.self.imageViewProfile.frame.size.width) / 2
                self.imageViewProfile.clipsToBounds = true
                
                self.imageViewProfile.image = SingletonData.staticInstance.userProfileImage
                
                self.imageViewProfile.isHidden = false
            }
            
            
            
            self.view.addSubview(self.blurEffectView!)
          //  self.view.addSubview(self.wouldYouDoThisLabel)
//            self.view.addSubview(uberWrapper)
            self.view.addSubview(self.profileLabel)
            self.view.addSubview(self.timeLabel)
            self.view.addSubview(self.getDirectionsButton)
            
            self.view.addSubview(self.closeButton)
          //  self.view.addSubview(self.tickBtn)
            //self.view.addSubview(self.voteUpBtnDone)
            self.view.addSubview(self.websiteButton)
            self.view.addSubview(self.callButton)
            
            self.view.addSubview(self.userHint)
            self.view.addSubview(self.userHintText)
            
            self.closeButton.translatesAutoresizingMaskIntoConstraints = false
            self.closeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
            self.closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            
            self.view.addSubview(self.imageViewProfile)
            self.imageViewProfile.translatesAutoresizingMaskIntoConstraints = false
            self.imageViewProfile.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
            self.imageViewProfile.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 20).isActive = true
            
            
            self.userHint.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90).isActive = true
            
            self.userHint.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            
            
            self.userHintText.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110).isActive = true
            
            self.userHintText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            
        }
        
    }

    
    func videoPlaybackDidFinish(_ videoNode: ASVideoNode) {
        postVideoScreen()
    }
    
    
    func callThisPlace(_ sender: AnyObject){
        print(SingletonData.staticInstance.phoneNumber!)
        
        if let url = URL(string: "tel://\(SingletonData.staticInstance.phoneNumber!))") {
            UIApplication.shared.openURL(url)
        }
    }
    func visitWebsite(_ sender: AnyObject){
        if let url = SingletonData.staticInstance.website?.absoluteURL {
            UIApplication.shared.openURL(url)
            
        }
    }
    func routeToVideo(_ sender: AnyObject) {
        
        let object = SingletonData.staticInstance.selectedAnnotation
        let loc = object?.coordinate
        
        if loc != nil
        {
            let lat = loc?.latitude
            let lng = loc?.longitude
            
            if lat != nil && lng != nil
            {
                let geocoder = CLGeocoder()
                let location = CLLocation(latitude: lat!, longitude: lng!)
                
                geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    if let placemarks = placemarks {
                        let placemark = placemarks[0]
                        let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
                        mapItem.openInMaps(launchOptions: nil)
                    }
                })
            }
        }
        
    }
    
    deinit{
        videoNode.asset = nil
    
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

}



