//
//  TimelineController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 3/12/16.
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


class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
   // var timeline: TimelineView!
    @IBOutlet weak var timelineView: UITableView!
    
    var ref: FIRDatabaseReference?
    let videosRef = FIRDatabase.database().reference(withPath: "profiles")
    let videosAllRef = FIRDatabase.database().reference(withPath: "videos")
    
    let storage = FIRStorage.storage()
    var videos: Array<FIRDataSnapshot> = []
    var refHandle: FIRDatabaseHandle?
    var isFinishedPlaying : Bool = false
    let closeBtn = UIButton(type: UIButtonType.system) as UIButton
    var objs: [AnyObject?] = []
    var photoLoaded : Bool = false
    var distanceValue : Int = 1
        var timeFrames : [TimeFrame] = []
    var asyncVideoController = AsyncVideoViewController()
    var playerViewController = PlayerViewController()
    var videoItemImages : [UIImage]?
    var videoItemDescs : [String]?
    var videoItems : [RealmObject] = []
    var timeframeCount = 0
    
//    @IBOutlet weak var profileViewTop: UIView!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var coverPhoto: UIImageView!
//    @IBOutlet weak var profilePhoto: UIImageView!
    
    func tappedTimelineItem(indexPath: IndexPath) {
      
        let obj = self.videoItems[indexPath.row]
        SingletonData.staticInstance.setVideoPlayed(nil)
        SingletonData.staticInstance.setSelectedVideoItem(nil)
        SingletonData.staticInstance.setSelectedObject(nil)

        SingletonData.staticInstance.setSelectedObject(obj)
        let imageURL = URL(string: obj.imagePath)
        SingletonData.staticInstance.setVideoImage(imageURL)
        SingletonData.staticInstance.setSelectedVideoItem("https://project-316688844667019748.appspot.com.storage.googleapis.com/" + obj.videoPath)

        self.present(asyncVideoController, animated: true, completion: nil)
        
    }
    
    @IBAction func dismissProfile(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
   //     HUD.show(.progress)
        
        self.timelineView.dataSource = self
        self.timelineView.delegate = self
        
   
//        if(self.scrollView != nil){
//            for item in self.scrollView.subviews{
//                item.removeFromSuperview()
//            }
//        }
        // Do any additional setup after loading the view, typically from a nib.
        let currentUser = FIRAuth.auth()?.currentUser
       // let processorCover = BlurImageProcessor(blurRadius: 10.0)
     //   let processor = ResizingImageProcessor(targetSize: CGSize(width: 110, height: 50))
       

      //  coverPhoto.kf.setImage(with: currentUser?.photoURL, options: [.processor(processorCover)])
       // profilePhoto.kf.setImage(with: currentUser?.photoURL, options: [.processor(processor)])
        //profilePhoto.asCircle()
        DispatchQueue.main.async {
            self.ref = FIRDatabase.database().reference()
            
            
            DispatchQueue.main.async {
                self.videosRef.child(currentUser!.uid).queryOrderedByValue().observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
                    print(snapshot)
                    if snapshot.hasChildren(){
                        
                        for snap in snapshot.children.reversed(){
                        
                            let item = RealmObject(value: [snap as! FIRDataSnapshot])
                            if(item.ActivityCategories != "" && item.address != "" && item.createdAt != "" && item.displayName != "" && item.displayTitle != ""){
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
                                dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                                let date = dateFormatter.date(from: item.createdAt)
                                if(date != nil){
                                    
                                    let imageView = UIImageView()
                                    let url = URL(string: item.imagePath)
                                    
                                    
                                    
                                    imageView.kf.setImage(with: url, completionHandler: {
                                        (image, error, cacheType, imageUrl) in
                                        
                                
                                    
                                        //self.timeFrames.append(TimeFrame(indexPath: self.timeframeCount, text: SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true) + " - " + item.taggedLocation, date: item.displayTitle, image: image))
                                         //      self.timeframeCount = self.timeframeCount + 1
                                        
                                    })
                                }
                                
                                
                                self.videoItems.append(item)
                                self.timelineView.reloadData()
                            }
                          
                         //HUD.hide()
                        }
                        
                    
                        
                        
//                        DispatchQueue.main.async {
                        
//                       
//                            self.scrollView.translatesAutoresizingMaskIntoConstraints = false
//                           self.view.addSubview(self.profileViewTop)
//                            
//                            self.view.addConstraints([
//                                NSLayoutConstraint(item: self.scrollView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0),
//                                NSLayoutConstraint(item: self.scrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 350),
//                                NSLayoutConstraint(item: self.scrollView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0),
//                                NSLayoutConstraint(item: self.scrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
//                                ])
////
//                            
//                            self.timeline = TimelineView(bulletType: .circle, timeFrames: self.timeFrames)
//                            
//                            self.scrollView.addSubview(self.timeline)
//                            
//                           
//                            
//                            self.scrollView.addConstraints([
//                                NSLayoutConstraint(item: self.timeline, attribute: .left, relatedBy: .equal, toItem: self.scrollView, attribute: .left, multiplier: 1.0, constant: 0),
//                                NSLayoutConstraint(item: self.timeline, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self.scrollView, attribute: .bottom, multiplier: 1.0, constant: 0),
//                                NSLayoutConstraint(item: self.timeline, attribute: .top, relatedBy: .equal, toItem: self.scrollView, attribute: .top, multiplier: 1.0, constant: 10),
//                                NSLayoutConstraint(item: self.timeline, attribute: .right, relatedBy: .equal, toItem: self.scrollView, attribute: .right, multiplier: 1.0, constant: 0),
//                                
//                                NSLayoutConstraint(item: self.timeline, attribute: .width, relatedBy: .equal, toItem: self.scrollView, attribute: .width, multiplier: 1.0, constant: 0)
//                                ])
//                            
//                            
                        
//                            HUD.hide()
                        
                            //self.timeline.delegate = self
//                        }
                        
                    }
                }
            }
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedTimelineItem(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
           let currentUser = FIRAuth.auth()?.currentUser
            let item = self.videoItems[indexPath.row]
            self.videosAllRef.child(item.key).removeValue()
            self.videosRef.child(currentUser!.uid).child(item.key).removeValue()
            self.videoItems.remove(at: indexPath.row)
            self.timelineView.reloadData()
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.timelineView.dequeueReusableCell(withIdentifier: "cell")! as! TimelineTableViewCell
        
        let item = self.videoItems[(indexPath as NSIndexPath).row]
        let url = URL(string: item.imagePath)
        
        cell.displayImg.kf.setImage(with: url)
     
        
      //  cell.displayTitle.text = item.taggedLocation
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let date = dateFormatter.date(from: item.createdAt)
    
        
        cell.createdAt.text = SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true)
        
    //    item.createdAt
        
        
        return cell

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoItems.count
    }
    
   
//    @IBAction func bulletChanged(_ sender: UISegmentedControl) {
//       // timeline.bulletType = [BulletType.circle, BulletType.hexagon, BulletType.diamond, BulletType.diamondSlash, BulletType.carrot, BulletType.arrow][sender.selectedSegmentIndex]
//    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
}


