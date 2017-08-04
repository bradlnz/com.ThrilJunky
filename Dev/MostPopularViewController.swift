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
////import FBAnnotationClusteringSwift
//import PKHUD
//import GeoFire
////import PopupDialog
////import PageMenu
//import AsyncDisplayKit
//
//
//class MostPopularViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DatabaseReferenceable{
//    
//    
//    var asyncVideoViewController = AsyncVideoViewController()
//    var ref: DatabaseReference?
//    let videosRef = Database.database().reference(withPath: "videos")
//    let locationsRef = Database.database().reference(withPath: "locations")
//    let storage = Storage.storage()
//    let geofireRef = Database.database().reference()
//    let user = Auth.auth()?.currentUser
//    var videos: Array<Item> = []
//    var keys : Array<String> = []
//    var mostPopularVideos : [Item] = []
//    var mostPopularVideosList : [Item] = []
//    var refHandle: DatabaseHandle?
//    //let cache = Shared.dataCache
//    let dateFormatter = DateFormatter()
//    
//    @IBOutlet weak var mostPopularVideo: UICollectionView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.mostPopularVideo.delegate = self
//        self.mostPopularVideo.dataSource = self
//        
//        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 0, right: 3)
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3.12, height: UIScreen.main.bounds.width/3.12)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 3
//        
//        self.mostPopularVideo.collectionViewLayout = layout
//        let loc = SingletonData.staticInstance.location
//        
//        
//        if loc != nil {
//            self.loadMostPopularVideos()        // Do any additional setup after loading the view.
//        }
//    }
//    
//    
//    func loadMostPopularVideos(){
//        
//             DispatchQueue.main.async {
//                    let loc = SingletonData.staticInstance.location
//            
//            
//                    CLGeocoder().reverseGeocodeLocation(loc!) { (placemarks: [CLPlacemark]?, error: NSError?) in
//            
//                        let placemark = placemarks![0] as CLPlacemark
//            
//                         print(placemark.subLocality)
//                    } as! CLGeocodeCompletionHandler
//            
//                    let geoFire = GeoFire(firebaseRef: self.locationsRef)
//            
//                    let query = geoFire?.query(at: loc, withRadius: 200)
//            
//                    query?.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
//            
//                        self.videosRef.child(key).observe(.value, with: { (snapshot) in
//            
//                            self.mostPopularVideosList.append(Item(snapshot))
//            
//            
//                            self.mostPopularVideosList.sort(by: {$0.averageVote > $1.averageVote})
//            //                self.mostPopularVideos.sortInPlace({ $0.createdAt.compare($1.createdAt) == .OrderedDescending })
//                            
//                            
//                            self.mostPopularVideo.reloadData()
//                            
//                            
//                            
//                        }) { (error) in
//                            print(error.localizedDescription)
//                        }
//                    })
//        }
//
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        if collectionView == self.mostPopularVideo {
//            
//            print(self.mostPopularVideosList.count)
//            
//            let withoutDups = SingletonData.staticInstance.removeDuplicates(self.mostPopularVideosList)
//            
//            self.mostPopularVideosList = withoutDups
//            
//            return self.mostPopularVideosList.count
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
//        if collectionView == self.mostPopularVideo {
//            let obj = self.mostPopularVideosList[(indexPath as NSIndexPath).row]
//            DispatchQueue.main.async {
//                
//                SingletonData.staticInstance.setSelectedObject(obj)
//                SingletonData.staticInstance.setSelectedVideoItem(obj.videoPath)
//                
//                DispatchQueue.main.async {
//                    self.present(self.asyncVideoViewController, animated: true) { () -> Void in
//                    }
//               
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
//        if collectionView == self.mostPopularVideo {
//            
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MostPopularCollectionViewCell
//            
//            
//            
//            let obj = self.mostPopularVideosList[(indexPath as NSIndexPath).row]
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
//            if obj.taggedLocation != "" {
//                cell.taggedLocation.text = obj.taggedLocation
//            }
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
