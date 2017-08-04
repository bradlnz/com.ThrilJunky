////
////  VideoPlayerViewController.swift
////  ThrilJunky
////
////  Created by Brad Lietz on 10/09/2016.
////  Copyright © 2016 ThrilJunky LLC. All rights reserved.
////
//
//import UIKit
//import AVKit
//import MapKit
//import AVFoundation
//import UberRides
//import Firebase
//import GeoFire
//import PKHUD
//
//class VideoPlayerViewController: UIViewController {
//
//    
//    let geocoder = CLGeocoder()
//    var playerViewController = PlayerViewController()
//    let overlayHintController = OverlayHintController()
//
//    var player = AVPlayer()
//    var playerItem : AVPlayerItem?
//    var ref: DatabaseReference?
//
//
//    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//    var blurEffectView : UIVisualEffectView?
//    var callButton = UIButton(frame: CGRect(x: 0, y: 0, width: 210, height: 40))
//    var websiteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 210, height: 40))
//    var getDirectionsButton = UIButton(frame: CGRect(x: 0, y: 00, width: 210, height: 40))
//    var closeButton = UIButton(type: UIButtonType.system) as UIButton
//    let voteUpBtn = UIButton(type: UIButtonType.system) as UIButton
//    let voteUpBtnDone = UIButton(type: UIButtonType.system) as UIButton
//    //var rideWithUberbutton = RequestButton()
//    let videosRef = Database.database().reference(withPath: "videos")
//    let locationsRef = Database.database().reference(withPath: "locations")
//    let storage = Storage.storage()
//    let geofireRef = Database.database().reference()
//    let user = Auth.auth()?.currentUser
//    var videos: Array<Item> = []
//    var mostRecentVideos : Array<Item> = []
//    var keys : Array<String> = []
//    var mostPopularVideos : [Item] = []
//    var followingVideosList : [Item] = []
//    var refHandle: DatabaseHandle?
//
//    let dateFormatter = DateFormatter()
//    let closeBtn = UIButton(type: UIButtonType.system) as UIButton
//    let tickBtn = UIButton(type: UIButtonType.system) as UIButton
//    var isFinishedPlaying : Bool = false
//    
//    var images = [UIImage(named: "Indoor"),
//                  UIImage(named: "Outdoor"),
//                  UIImage(named: "Food"),
//                  UIImage(named: "Nightlife"),
//                  UIImage(named: "Events"),
//                  UIImage(named: "Other")]
//    
//    var categories: [String] = ["Indoor",
//                                "Outdoor",
//                                "Food",
//                                "Nightlife",
//                                "Events",
//                                "Other"]
//
//    
//    
//    
//    
//    let wouldYouDoThisLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//    let profileLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//    let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//    let userHint = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//    let userHintText = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//    let displayTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//    let Desc = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//    let imageViewProfile = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//    
//
//
//
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
////
//        self.profileLabel.textColor = UIColor.white
//        self.timeLabel.textColor = UIColor.white
//        self.userHint.textColor = UIColor.white
//        self.userHintText.textColor = UIColor.white
//        self.displayTitle.textColor = UIColor.white
//        self.wouldYouDoThisLabel.textColor = UIColor.white
//        self.wouldYouDoThisLabel.text = "Would you do this?"
//        
//        
//        
//        print(self.profileLabel)
//        self.profileLabel.isHidden = true
//        self.timeLabel.isHidden = true
//        self.userHint.isHidden = true
//        self.userHintText.isHidden = true
//        self.wouldYouDoThisLabel.isHidden = true
//        
////
//        
//        DispatchQueue.main.async {
//            self.present(self.playerViewController, animated: true) { () -> Void in
//            }
//            if(SingletonData.staticInstance.selectedObject != nil){
//                
//                self.playVideo(SingletonData.staticInstance.selectedObject?.videoPath)
//            }
//            
//            if(SingletonData.staticInstance.selectedVideoItem != nil){
//                
//                self.playVideo(SingletonData.staticInstance.selectedVideoItem)
//            }
//        }
//        // Do any additional setup after loading the view.
//    }
//    
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
//               var snap = Item?(snapshot)
//                
//                if(snap != nil){
//                    if count == 0 {
//                        self.videosRef.child(key!).updateChildValues(["voteUp": snap!.voteUp + 1])
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
//            print(snap)
//            
//            
//            
//            stopVideo(sender)
//            
//        } else {
//            closeVideo(sender)
//        }
//        
//    }
//    
//    func voteDown(_ sender: UIButton!){
//        self.closeBtn.isEnabled = false
//        var count = 0
//        
//        if !self.isFinishedPlaying {
//            let key = SingletonData.staticInstance.key
//            var snap = Item?()
//            
//            self.videosRef.child(key!).queryLimited(toFirst: 1).observe(.value, with: { (snapshot) in
//                
//                
//                snap = Item(snapshot)
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
//            stopVideo(sender)
//        } else {
//            closeVideo(sender)
//        }
//        
//        
//    }
//
//
//    func playVideo(_ url: String?)
//    {
//        HUD.show(.Progress)
//        HUD.dimsBackground = true
//        let refUrl = URL(string: url!)
//        self.playerItem = AVPlayerItem(url: refUrl!)
//        self.player = AVPlayer(playerItem: self.playerItem!)
//       // self.playerViewController.player = self.player
//        self.isFinishedPlaying = false
//        // self.playerViewController.showsPlaybackControls = false
//       self.profileLabel.isHidden = false
//        
//        self.timeLabel.isHidden = false
//        self.closeBtn.isEnabled = true
//        self.tickBtn.isEnabled = true
//        self.userHint.isHidden = true
//        self.userHintText.isHidden = true
//        self.tickBtn.isHidden = true
//        self.closeBtn.isHidden = true
//        self.imageViewProfile.image = nil
//        
//        DispatchQueue.main.async {
//            
//            self.voteUpBtn.isHidden = true
//            self.voteUpBtnDone.isHidden = true
//            self.websiteButton.isHidden = true
//            self.callButton.isHidden = true
//            self.wouldYouDoThisLabel.isHidden = true
//            
//           
//            let annotation = SingletonData.staticInstance.selectedAnnotation
//            let selectedObj = SingletonData.staticInstance.selectedObject
//            
//            
//            
//            
//            if annotation != nil {
//                
//                SingletonData.staticInstance.setKey(annotation?.key)
//                
//                if annotation?.createdAt != nil {
//                    self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
//                    self.dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//                    let date = self.dateFormatter.date(from: annotation!.createdAt!)
//                    
//                    self.timeLabel.text = SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true)
//                    
//                }
//                
//                if annotation?.displayHint != nil {
//                    self.userHintText.text = annotation?.displayHint
//                }
//                if annotation?.displayName != nil {
//                    self.profileLabel.text = annotation?.displayName
//                }
//                if annotation?.displayMsg != nil {
//                    self.Desc.text = annotation?.displayMsg
//                }
//                if annotation?.displayTitle != nil {
//                    self.displayTitle.text = annotation?.title
//                }
//                
//            }
//            
//            if selectedObj != nil {
//                
//                SingletonData.staticInstance.setKey(selectedObj!.key)
//                
//                self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
//                self.dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//                let date = self.dateFormatter.date(from: selectedObj!.createdAt)
//                
//                self.timeLabel.text = SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true)
//                
//                self.userHintText.text = selectedObj?.displayHint
//                
//                self.profileLabel.text = selectedObj?.displayName
//                
//                self.Desc.text = selectedObj?.displayMsg
//                
//                self.displayTitle.text = selectedObj?.displayTitle
//                
//                
//            }
//            
//            
//            
//            self.tickBtn.tintColor = UIColor.white
//            let voteUpImg = UIImage(named: "done")!
//            self.tickBtn.setImage(voteUpImg, for: UIControlState())
//            
//            self.tickBtn.addTarget(self, action: #selector(VideoPlayerViewController.voteUp(_:)), for: UIControlEvents.touchUpInside)
//            
//            self.closeBtn.tintColor = UIColor.white
//            let image = UIImage(named: "close")!
//            self.closeBtn.setImage(image, for: UIControlState())
//            
//            self.closeBtn.addTarget(self, action: #selector(VideoPlayerViewController.voteDown(_:)), for: UIControlEvents.touchUpInside)
//            
//            
//            
//           
//            self.playerViewController.view.addSubview(self.closeBtn)
//            self.playerViewController.view.addSubview(self.tickBtn)
//            self.playerViewController.view.addSubview(self.timeLabel)
//            self.playerViewController.view.addSubview(self.profileLabel)
//            self.playerViewController.view.addSubview(self.wouldYouDoThisLabel)
//            self.playerViewController.view.addSubview(self.Desc)
//            self.playerViewController.view.addSubview(self.displayTitle)
//            
//            
//            self.wouldYouDoThisLabel.translatesAutoresizingMaskIntoConstraints = false
//            
//            self.wouldYouDoThisLabel.bottomAnchor.constraint(equalTo: self.playerViewController.view.bottomAnchor, constant: -30).isActive = true
//            
//            self.wouldYouDoThisLabel.centerXAnchor.constraint(equalTo: self.playerViewController.view.centerXAnchor, constant: 0).isActive = true
//
//            
//            self.displayTitle.translatesAutoresizingMaskIntoConstraints = false
//            self.displayTitle.topAnchor.constraint(equalTo: self.playerViewController.view.topAnchor, constant: 100).isActive = true
//            self.displayTitle.centerXAnchor.constraint(equalTo: self.playerViewController.view.centerXAnchor, constant: 0).isActive = true
//            
//            self.Desc.translatesAutoresizingMaskIntoConstraints = false
//            self.Desc.topAnchor.constraint(equalTo: self.playerViewController.view.topAnchor, constant: 120).isActive = true
//            self.Desc.centerXAnchor.constraint(equalTo: self.playerViewController.view.centerXAnchor, constant: 0).isActive = true
//            
//            self.profileLabel.translatesAutoresizingMaskIntoConstraints = false
//            self.profileLabel.topAnchor.constraint(equalTo: self.playerViewController.view.topAnchor, constant: 20).isActive = true
//            self.profileLabel.leadingAnchor.constraint(equalTo: self.playerViewController.view.leadingAnchor, constant: 20).isActive = true
//            
//            self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
//            self.timeLabel.topAnchor.constraint(equalTo: self.playerViewController.view.topAnchor, constant: 40).isActive = true
//            self.timeLabel.leadingAnchor.constraint(equalTo: self.playerViewController.view.leadingAnchor, constant: 20).isActive = true
//            
//            self.tickBtn.translatesAutoresizingMaskIntoConstraints = false
//            self.tickBtn.bottomAnchor.constraint(equalTo: self.playerViewController.view.bottomAnchor, constant: -20).isActive = true
//            self.tickBtn.leadingAnchor.constraint(equalTo: self.playerViewController.view.leadingAnchor, constant: 20).isActive = true
//            
//            
//            self.closeBtn.translatesAutoresizingMaskIntoConstraints = false
//            self.closeBtn.bottomAnchor.constraint(equalTo: self.playerViewController.view.bottomAnchor, constant: -20).isActive = true
//            self.closeBtn.trailingAnchor.constraint(equalTo: self.playerViewController.view.trailingAnchor, constant: -20).isActive = true
//            
//        }
//        
//        let blurEffectVideoMenu = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectViewVideoMenu = UIVisualEffectView(effect: blurEffectVideoMenu)
//        //always fill the view
//        blurEffectViewVideoMenu.frame =  CGRect(x: 0, y: UIScreen.main.bounds.height + 100, width: UIScreen.main.bounds.width, height: 150)
//        blurEffectViewVideoMenu.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        
//        
//        self.playerViewController.view.addSubview(blurEffectViewVideoMenu)
//        
//        
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerViewController.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
//        self.playerItem!.addObserver(self, forKeyPath: "status", options:NSKeyValueObservingOptions(), context: self.playbackStatusContext)
//        self.playerItem!.addObserver(self, forKeyPath: "playbackBufferFull", options:NSKeyValueObservingOptions(), context: self.playbackBufferFullContext)
//        self.playerItem!.addObserver(self, forKeyPath: "playbackBufferEmpty", options:NSKeyValueObservingOptions(), context: self.playbackBufferEmptyContext)
//        self.playerItem!.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options:NSKeyValueObservingOptions(), context: self.playbackLikelyToKeepUpContext)
//        
//    }
//    
//    
//    func playerDidFinishPlaying(_ note: Notification) {
//        postVideoScreen()
//        
//    }
//    
//    func postVideoScreen(){
//        DispatchQueue.main.async {
//            
//            NotificationCenter.default.removeObserver(self)
//            self.playerItem!.removeObserver(self, forKeyPath: "status", context: self.playbackStatusContext)
//            self.playerItem!.removeObserver(self, forKeyPath: "playbackBufferFull", context: self.playbackBufferFullContext)
//            self.playerItem!.removeObserver(self, forKeyPath: "playbackBufferEmpty", context: self.playbackBufferEmptyContext)
//            self.playerItem!.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp", context: self.playbackLikelyToKeepUpContext)
//            self.playerItem = nil
//            self.wouldYouDoThisLabel.isHidden = true
//            self.tickBtn.isHidden = true
//            self.closeButton.isHidden = false
//            self.userHintText.isHidden = false
//            self.userHint.isHidden = false
//            //self.rideWithUberbutton.hidden = false
//            self.getDirectionsButton.isHidden = false
//            self.websiteButton.isHidden = false
//            self.callButton.isHidden = false
//            self.blurEffectView?.isHidden = false
//            self.isFinishedPlaying = true
//            let loc = SingletonData.staticInstance.location
//            
//            if loc != nil {
//                
//              //  self.rideWithUberbutton.setPickupLocation(latitude: loc!.coordinate.latitude, longitude: loc!.coordinate.longitude, nickname: "Pickup")
//            }
//            
//            let object = SingletonData.staticInstance.selectedAnnotation
//            
//            self.callButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 320)
//            
//            
//            let locDrop = object?.coordinate
//            if locDrop != nil
//            {
//                let lat = locDrop?.latitude
//                let lng = locDrop?.longitude
//                
////                if lat != nil && lng != nil
////                {
////                    self.rideWithUberbutton.setDropoffLocation(latitude: lat!, longitude: lng!, nickname: "Dropoff")
////                }
//            }
//            self.view.backgroundColor = UIColor.clear
//            
//            self.blurEffectView = UIVisualEffectView(effect: self.blurEffect)
//            //always fill the view
//            self.blurEffectView!.frame =  UIScreen.main.bounds
//            self.blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            
//            
//            
//            self.getDirectionsButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 290)
//            self.getDirectionsButton.tintColor = UIColor.white
//            self.getDirectionsButton.backgroundColor = UIColor.purple
//            self.getDirectionsButton.setTitle("Get Directions", for: UIControlState())
//            self.getDirectionsButton.addTarget(self, action: #selector(VideoPlayerViewController.routeToVideo(_:)), for: UIControlEvents.touchUpInside)
//            
//            self.closeButton.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
//            self.closeButton.tintColor = UIColor.white
//            
//            let image : UIImage = UIImage(named: "close")!
//            
//            self.closeButton.setImage(image, for: UIControlState())
//            self.closeButton.addTarget(self, action: #selector(VideoPlayerViewController.voteDown(_:)), for: UIControlEvents.touchUpInside)
//            
//            self.tickBtn.tintColor = UIColor.white
//            let voteUpImg = UIImage(named: "done")!
//            self.tickBtn.setImage(voteUpImg, for: UIControlState())
//            self.tickBtn.addTarget(self, action: #selector(VideoPlayerViewController.voteUp(_:)), for: UIControlEvents.touchUpInside)
//            
//            
//            
////            let uberWrapper = UIView()
////            uberWrapper.addSubview(self.rideWithUberbutton)
////            
////            let horizontalConstraint = NSLayoutConstraint(item: self.rideWithUberbutton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: uberWrapper, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
////            let verticalConstraint = NSLayoutConstraint(item: self.rideWithUberbutton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: uberWrapper, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
////            
////            uberWrapper.addConstraints([horizontalConstraint, verticalConstraint])
////            uberWrapper.frame = CGRect(origin: CGPointMake((UIScreen.mainScreen().bounds.width - 200) / 2, 320), size: self.rideWithUberbutton.intrinsicContentSize())
////            
////            
//            
//            
//            
//            self.tickBtn.translatesAutoresizingMaskIntoConstraints = false
//            self.tickBtn.bottomAnchor.constraint(equalTo: self.playerViewController.view.bottomAnchor, constant: -20).isActive = true
//            self.tickBtn.leadingAnchor.constraint(equalTo: self.playerViewController.view.leadingAnchor, constant: 20).isActive = true
//            
//            self.profileLabel.translatesAutoresizingMaskIntoConstraints = false
//            self.profileLabel.topAnchor.constraint(equalTo: self.playerViewController.view.topAnchor, constant: 20).isActive = true
//            self.profileLabel.leadingAnchor.constraint(equalTo: self.playerViewController.view.leadingAnchor, constant: 20).isActive = true
//            
//            self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
//            self.timeLabel.topAnchor.constraint(equalTo: self.playerViewController.view.topAnchor, constant: 40).isActive = true
//            self.timeLabel.leadingAnchor.constraint(equalTo: self.playerViewController.view.leadingAnchor, constant: 20).isActive = true
//            
//            
//            
//            self.wouldYouDoThisLabel.translatesAutoresizingMaskIntoConstraints = false
//            
//            self.wouldYouDoThisLabel.bottomAnchor.constraint(equalTo: self.playerViewController.view.bottomAnchor, constant: -30).isActive = true
//            
//            self.wouldYouDoThisLabel.centerXAnchor.constraint(equalTo: self.playerViewController.view.centerXAnchor, constant: 0).isActive = true
//            
//            
//            if SingletonData.staticInstance.userProfileImage != nil {
//                
//                self.imageViewProfile.isHidden = true
//                self.imageViewProfile.layer.cornerRadius = (self.self.imageViewProfile.frame.size.width) / 2
//                self.imageViewProfile.clipsToBounds = true
//                
//                self.imageViewProfile.image = SingletonData.staticInstance.userProfileImage
//                
//                self.imageViewProfile.isHidden = false
//            }
//            
//            
//            
//            self.playerViewController.view.addSubview(self.blurEffectView!)
//            self.playerViewController.view.addSubview(self.wouldYouDoThisLabel)
////            self.playerViewController.view.addSubview(uberWrapper)
//            self.playerViewController.view.addSubview(self.profileLabel)
//            self.playerViewController.view.addSubview(self.timeLabel)
//            self.playerViewController.view.addSubview(self.getDirectionsButton)
//            
//            self.playerViewController.view.addSubview(self.closeButton)
//            self.playerViewController.view.addSubview(self.tickBtn)
//            self.playerViewController.view.addSubview(self.voteUpBtnDone)
//            self.playerViewController.view.addSubview(self.websiteButton)
//            self.playerViewController.view.addSubview(self.callButton)
//            
//            self.playerViewController.view.addSubview(self.userHint)
//            self.playerViewController.view.addSubview(self.userHintText)
//            
//            self.closeButton.translatesAutoresizingMaskIntoConstraints = false
//            self.closeButton.bottomAnchor.constraint(equalTo: self.playerViewController.view.bottomAnchor, constant: -20).isActive = true
//            self.closeButton.trailingAnchor.constraint(equalTo: self.playerViewController.view.trailingAnchor, constant: -20).isActive = true
//            
//            self.playerViewController.view.addSubview(self.imageViewProfile)
//            self.imageViewProfile.translatesAutoresizingMaskIntoConstraints = false
//            self.imageViewProfile.topAnchor.constraint(equalTo: self.playerViewController.view.topAnchor, constant: 20).isActive = true
//            self.imageViewProfile.trailingAnchor.constraint(equalTo: self.playerViewController.view.trailingAnchor, constant: 20).isActive = true
//            
//            
//            self.userHint.topAnchor.constraint(equalTo: self.playerViewController.view.topAnchor, constant: 90).isActive = true
//            
//            self.userHint.centerXAnchor.constraint(equalTo: self.playerViewController.view.centerXAnchor, constant: 0).isActive = true
//            
//            
//            self.userHintText.topAnchor.constraint(equalTo: self.playerViewController.view.topAnchor, constant: 110).isActive = true
//            
//            self.userHintText.centerXAnchor.constraint(equalTo: self.playerViewController.view.centerXAnchor, constant: 0).isActive = true
//            
//        }
//        
//    }
//
//    func callThisPlace(_ sender: AnyObject){
//        print(SingletonData.staticInstance.phoneNumber!)
//        
//        if let url = URL(string: "tel://\(SingletonData.staticInstance.phoneNumber!.removeWhitespace())") {
//            UIApplication.shared.openURL(url)
//        }
//    }
//    func visitWebsite(_ sender: AnyObject){
//        if let url = SingletonData.staticInstance.website?.absoluteURL {
//            UIApplication.shared.openURL(url)
//            
//        }
//    }
//    func routeToVideo(_ sender: AnyObject) {
//        
//        let object = SingletonData.staticInstance.selectedAnnotation
//        let loc = object?.coordinate
//        
//        if loc != nil
//        {
//            let lat = loc?.latitude
//            let lng = loc?.longitude
//            
//            if lat != nil && lng != nil
//            {
//                let geocoder = CLGeocoder()
//                let location = CLLocation(latitude: lat!, longitude: lng!)
//                
//                geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
//                    if let placemarks = placemarks {
//                        let placemark = placemarks[0]
//                        let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
//                        mapItem.openInMapsWithLaunchOptions(nil)
//                    }
//                })
//            }
//        }
//        
//    }
//    func closeVideo(_ sender: UIButton!){
//        self.closeBtn.isEnabled = false
//
//
//        
//           DispatchQueue.main.async {
//            self.blurEffectView!.removeFromSuperview()
//            self.getDirectionsButton.removeFromSuperview()
//          //  self.rideWithUberbutton.removeFromSuperview()
//            self.closeButton.removeFromSuperview()
//            self.callButton.removeFromSuperview()
//            self.websiteButton.removeFromSuperview()
//            self.userHint.removeFromSuperview()
//            self.userHintText.removeFromSuperview()
//            self.profileLabel.removeFromSuperview()
//            SingletonData.staticInstance.setDisplayName(nil)
//            SingletonData.staticInstance.setCreatedAt(nil)
//            SingletonData.staticInstance.setName(nil)
//            SingletonData.staticInstance.setSelectedObject(nil)
//           
//              self.playerViewController.dismiss(animated: true, completion: {
//                self.dismiss(animated: true, completion: {
//                    
//                })
//              })
//        }
//    }
//    
//    func stopVideo(_ sender: UIButton!){
//        DispatchQueue.main.async {
//            
//            self.closeBtn.isEnabled = false
//            self.player.pause()
//            self.postVideoScreen()
//            
//        }
//    }
//
////    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
////        
////        dispatch_async(dispatch_get_main_queue()) {
////            
////            if context == self.playbackBufferEmptyContext
////            {
////                if keyPath == "playbackBufferEmpty" {
////                    HUD.show(.Progress)
////                    self.playerViewController.player!.pause()
////                    print("Change at keyPath = \(keyPath) for \(object)")
////                }
////            }
////            
////            if context == self.playbackBufferFullContext
////            {
////                if keyPath == "playbackBufferFull" {
////                    HUD.hide()
////                    self.player.play()
////                    print("Change at keyPath = \(keyPath) for \(object)")
////                }
////            }
////            
////            if context == self.playbackLikelyToKeepUpContext {
////                if keyPath == "playbackLikelyToKeepUp" {
////                    self.tickBtn.hidden = false
////                    self.closeBtn.hidden = false
////                    self.wouldYouDoThisLabel.hidden = false
////                    self.player.play()
////                    HUD.hide()
////                    print("Change at keyPath = \(keyPath) for \(object)")
////                }
////            }
////            
////        }
////    }
////    
//
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//}
