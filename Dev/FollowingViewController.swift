////
////  FollowingViewController.swift
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
////import Haneke
//import ReachabilitySwift
//import FBAnnotationClusteringSwift
//import PKHUD
//import GeoFire
////import PopupDialog
////import PageMenu
////import Player
//import AsyncDisplayKit
//
//class FollowingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DatabaseReferenceable{
//
//    
//    let geocoder = CLGeocoder()
//    var asyncVideoViewController = AsyncVideoViewController()
//    var ref: DatabaseReference?
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
//    let dateFormatter = DateFormatter()
//   
//    
//    @IBOutlet weak var followingVideos: UICollectionView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.followingVideos.delegate = self
//        self.followingVideos.dataSource = self
//        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 0, right: 3)
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3.12, height: UIScreen.main.bounds.width/3.12)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 3
//        
//        self.followingVideos.collectionViewLayout = layout
//        let loc = SingletonData.staticInstance.location
//    
//        
//        if loc != nil {
//          self.loadFollowingVideos()        // Do any additional setup after loading the view.
//      }
//    }
//    
//    func loadFollowingVideos(){
//        
//        let userId = self.user!.uid
//        
//        
//        self.ref.child("profiles").child(userId).child("following").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if snapshot.hasChildren(){
//                let values = snapshot.value as! [String : AnyObject]
//                
//                
//                for childItem in values{
//                    
//                    let item = childItem.1 as? String
//                    
//                    if item != nil {
//                        
//                        self.videosRef.queryOrdered(byChild: "taggedLocation").queryEqual(toValue: item).observe(.value, with: { (snapshot) in
//                            
//                            for (i, child) in snapshot.children.enumerated() {
//                                print(i)
//                                self.followingVideosList.append(Item(child as! DataSnapshot))
//                                self.followingVideosList.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending })
//                                
//                                
//                            }
//                            //  self.followingLabel.hidden = false
//                            self.followingVideos.reloadData()
//                            
//                        }) { (error) in
//                            print(error.localizedDescription)
//                        }
//                        
//                    }
//                }
//            } else {
//                // self.followingLabel.hidden = true
//            }
//            
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            
//         if collectionView == self.followingVideos {
//            
//            print(self.followingVideosList.count)
//            
//            let withoutDups = SingletonData.staticInstance.removeDuplicates(self.followingVideosList)
//            
//            self.followingVideosList = withoutDups
//            
//            return self.followingVideosList.count
//            
//        }
//        
//        return 0
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        
//        if collectionView == self.followingVideos {
//            let obj = self.followingVideosList[(indexPath as NSIndexPath).row]
//            DispatchQueue.main.async {
//                SingletonData.staticInstance.setSelectedVideoItem(obj.videoPath)
//                
//                SingletonData.staticInstance.setSelectedObject(obj)
//                
//                DispatchQueue.main.async {
//                    self.present(self.asyncVideoViewController, animated: true) { () -> Void in
//                    }
//                  
//                }
//                
//
//                
//            }
//        }
//      
//    }
//
//    
//func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
// if collectionView == self.followingVideos {
//            
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FollowingVideoCollectionViewCell
//            
//            
//            
//            let obj = self.followingVideosList[(indexPath as NSIndexPath).row]
//            
//            print(obj)
//            
//            self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
//            self.dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//            
//            if obj.createdAt != "" {
//                let date = self.dateFormatter.date(from: obj.createdAt)
//                cell.timeSince.text = SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true)
//            }
//            if obj.displayTitle != "" {
//                cell.displayTitle.text = obj.displayTitle
//            }
//            if obj.imagePath != ""{
//                var imgUrl : String? = nil
//                let imgU = obj.imagePath
//                imgUrl = String(imgU)
//                let imageNode = ASNetworkImageNode()
//                imageNode.url = URL(string: imgUrl!)!
//                
//                
//                cell.imgView.setImageWith(imageNode.url!)
//                
//            }
//    
//           if obj.taggedLocation != "" {
//              cell.location.text = obj.taggedLocation
//           }
//        
//            return cell
//        }
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        
//        return cell
//        
//    }
//
//    
//    
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//}
