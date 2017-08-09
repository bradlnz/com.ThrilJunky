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
    let wouldYouDoThisLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let profileLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let userHint = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let userHintText = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let DisplayTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let Desc = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let imageViewProfile = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let closeBtn = UIButton(type: UIButtonType.system) as UIButton
 
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

        DispatchQueue.main.async {
            
            let selectedObj = SingletonData.staticInstance.selectedObject
     
            if selectedObj != nil {
                
                SingletonData.staticInstance.setKey(selectedObj!.key)
                
                self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
                self.dateFormatter.timeZone = TimeZone.autoupdatingCurrent
              
                self.profileLabel.text = selectedObj?.displayName

                self.DisplayTitle.text = selectedObj?.displayTitle
        
            }
            
            self.closeBtn.tintColor = UIColor.white
            let image = UIImage(named: "close")!
            self.closeBtn.setImage(image, for: UIControlState())
            
            self.closeBtn.addTarget(self, action: #selector(self.voteDown(_:)), for: UIControlEvents.touchUpInside)
            
            self.DisplayTitle.translatesAutoresizingMaskIntoConstraints = false
            self.DisplayTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
            self.DisplayTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            self.DisplayTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            self.DisplayTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.DisplayTitle.textAlignment = NSTextAlignment.center
            
            self.Desc.translatesAutoresizingMaskIntoConstraints = false
            self.Desc.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
            self.Desc.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            
//            self.profileLabel.translatesAutoresizingMaskIntoConstraints = false
//            self.profileLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
//            self.profileLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
//            
            self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
            self.timeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
            self.timeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            
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
        self.view.addSubview(self.timeLabel)
        self.view.addSubview(self.Desc)
        self.view.addSubview(self.DisplayTitle)
        self.view.addSubview(self.blurEffectView!)
        

    }
    
    func voteDown(_ sender: UIButton!){
        stopVideo(sender)
    }
    
    
    func stopVideo(_ sender: UIButton!){
        DispatchQueue.main.async {
            
            self.closeBtn.isEnabled = true
         
            if let blurEffectView = self.blurEffectView {
                blurEffectView.removeFromSuperview()
            }
     
            self.getDirectionsButton.removeFromSuperview()
            self.closeButton.removeFromSuperview()
            self.callButton.removeFromSuperview()
            self.websiteButton.removeFromSuperview()
      
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    func postVideoScreen(){
        DispatchQueue.main.async {
    
            self.callButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 320)
            
            self.view.backgroundColor = UIColor.clear
            
            self.dismiss(animated: true, completion: {
                
            })
     
            self.view.addSubview(self.blurEffectView!)
            self.view.addSubview(self.timeLabel)
            self.view.addSubview(self.getDirectionsButton)
            
            self.view.addSubview(self.closeButton)
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
        if let phoneNumber = SingletonData.staticInstance.phoneNumber {
            if let url = URL(string: "tel://\(phoneNumber))") {
                UIApplication.shared.open(url)
            }
        }
    }
    func visitWebsite(_ sender: AnyObject){
        if let website = SingletonData.staticInstance.website {
                UIApplication.shared.open(website.absoluteURL)
        }
    }

    deinit{
        videoNode.asset = nil
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

}



