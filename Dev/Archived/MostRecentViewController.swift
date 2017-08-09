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
//import Haneke
//import ReachabilitySwift
//import FBAnnotationClusteringSwift
//import PKHUD
//import GeoFire
////import PopupDialog
//import PageMenu
//import AsyncDisplayKit
//
//class MostRecentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FIRDatabaseReferenceable{
//    
//    
//
//    var asyncVideoViewController = AsyncVideoViewController()
//
//
//    let videosRef = FIRDatabase.database().reference(withPath: "videos")
//    let locationsRef = FIRDatabase.database().reference(withPath: "locations")
//    let storage = FIRStorage.storage()
//    let geofireRef = FIRDatabase.database().reference()
//    let user = FIRAuth.auth()?.currentUser
//    var videos: Array<FIRItem> = []
//    var mostRecentVideos : Array<FIRItem> = []
//    var keys : Array<String> = []
//    var mostRecentVideosList : [FIRItem] = []
//    let dateFormatter = DateFormatter()
//    
//    
//    @IBOutlet weak var mostRecentVideo: UICollectionView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.mostRecentVideo.delegate = self
//        self.mostRecentVideo.dataSource = self
//        
//        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 0, right: 3)
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3.12, height: UIScreen.main.bounds.width/3.12)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 3
//        
//        self.mostRecentVideo.collectionViewLayout = layout
//        let loc = SingletonData.staticInstance.location
//        
//        
//        if loc != nil {
//            self.loadMostRecentVideos()        // Do any additional setup after loading the view.
//        }
//    }
//    
//    func loadMostRecentVideos(){
//       
//         DispatchQueue.main.async {
//            
//            let loc = SingletonData.staticInstance.location
//            
//            let geoFire = GeoFire(firebaseRef: self.locationsRef)
//            
//            let query = geoFire?.query(at: loc, withRadius: 1000)
//            
//            query?.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
//                
//                self.videosRef.child(key).observe(.value, with: { (snapshot) in
//                    
//                    self.mostRecentVideosList.append(FIRItem(snapshot))
//                    self.mostRecentVideosList.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending })
//                    
//                    
//                    self.mostRecentVideo.reloadData()
//                    
//                    
//                    
//                }) { (error) in
//                    print(error.localizedDescription)
//                }
//            })
//        
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        if collectionView == self.mostRecentVideo {
//            
//            print(self.mostRecentVideosList.count)
//            
//            let withoutDups = SingletonData.staticInstance.removeDuplicates(self.mostRecentVideosList)
//            
//            self.mostRecentVideosList = withoutDups
//            
//            return self.mostRecentVideosList.count
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
//        if collectionView == self.mostRecentVideo {
//            let obj = self.mostRecentVideosList[(indexPath as NSIndexPath).row]
//            DispatchQueue.main.async {
//                SingletonData.staticInstance.setSelectedObject(obj)
//                SingletonData.staticInstance.setSelectedVideoItem(obj.videoPath)
//                
//                DispatchQueue.main.async {
//                    self.present(self.asyncVideoViewController, animated: true) { () -> Void in
//                    }
//                }
//
//                
//            }
//        }
//        
//    }
//    
//    
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        if collectionView == self.mostRecentVideo {
//            
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MostRecentCollectionViewCell
//            
//            
//            
//            let obj = self.mostRecentVideosList[(indexPath as NSIndexPath).row]
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
//                
//                let imageNode = ASNetworkImageNode()
//                imageNode.url = URL(string: imgUrl!)!
//                
//                
//                cell.imgView.setImageWith(imageNode.url!)
//                
//            }
//            
//            if obj.taggedLocation != "" {
//                cell.taggedLocation.text = obj.taggedLocation
//            }
//            
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
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//}
