////
////  PlaceController.swift
////  ThrilJunky
////
////  Created by Lietz on 16/08/2016.
////  Copyright © 2016 ThrilJunky LLC. All rights reserved.
////
//
//import UIKit
//import AVKit
//import MapKit
//import AVFoundation
//import UberRides
//import Firebase
//import ReachabilitySwift
//import FBAnnotationClusteringSwift
//import PKHUD
////import GeoFire
//
//let offset_HeaderStop:CGFloat = 120.0 // At this offset the Header stops its transformations
//let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
//let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label
//
//
//class PlaceController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, FIRDatabaseReferenceable  {
//
//    
//    
//    @IBOutlet var scrollView:UIScrollView!
//    @IBOutlet var header:UIView!
//    @IBOutlet var headerLabel:UILabel!
//    @IBOutlet var follow:UIButton!
//    @IBOutlet var headerImageView:UIImageView!
//    @IBOutlet var videoCollection:UICollectionView!
//    @IBOutlet weak var hintCollection: UITableView!
//    @IBOutlet weak var unfollow: UIButton!
//  
//    
//    var asyncVideoViewController = AsyncVideoViewController()
//
//    var ref : FIRDatabaseReference?
//    let videosRef = FIRDatabase.database().reference(withPath: "videos")
//    let locationsRef = FIRDatabase.database().reference(withPath: "locations")
//    let storage = FIRStorage.storage()
//    let geofireRef = FIRDatabase.database().reference()
//    var videos : Array<RealmObject> = []
//    let dateFormatter = DateFormatter()
//    let geocoder = CLGeocoder()
//    var reachability : Reachability? = nil
//    var player = AVPlayer()
//    var playerItem : AVPlayerItem?
//    var cluster:[FBAnnotation] = []
//    var user = FIRAuth.auth()?.currentUser
// 
//    var mostRecentVideos : Array<FIRItem> = []
//    var keys : Array<String> = []
//    var mostPopularVideos : [RealmObject] = []
//    var items : [RealmObject] = []
//    var refHandle: FIRDatabaseHandle?
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.follow.isHidden = true
//        self.unfollow.isHidden = true
//    }
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.scrollView.delegate = self
//        self.videoCollection.delegate = self
//        self.videoCollection.dataSource = self
//        self.hintCollection.delegate = self
//        self.hintCollection.dataSource = self
//        self.follow.isHidden = false
//        self.unfollow.isHidden = true
//        DispatchQueue.main.async {
//
//           
//          self.ref = FIRDatabase.database().reference()
//        
//        if SingletonData.staticInstance.selectedMapItem != nil {
//            
//            let placemark = SingletonData.staticInstance.selectedMapItem?.location
//            
//           SingletonData.staticInstance.setTaggedLocation(CLLocation(latitude: placemark!.coordinate.latitude, longitude: placemark!.coordinate.longitude))
//            
////            let item = SingletonData.staticInstance.selectedMapItem!.name
////            let key = ref.child("profiles").child(user!.uid).child("following").childByAutoId().key
////            self.ref.child("profiles").child(user!.uid).child("following").updateChildValues([key: item!])
//            
//self.ref.child("profiles").child(self.user!.uid).child("following").observeSingleEvent(of: .value, with: { (snapshot) in
//    
//    print(snapshot)
//    
//   let values = snapshot.value as? [String : AnyObject]
//    
//    if values != nil {
//    
//    var followBool = false
//    
//    for childItem in values!{
//    
//        let item = childItem.1 as! String
//        if item == SingletonData.staticInstance.selectedMapItem?.name {
//           followBool = true
//        }
//    }
//    
//    
//    if followBool == true {
//        self.follow.isHidden = true
//        self.unfollow.isHidden = false
//    } else {
//        self.follow.isHidden = false
//        self.unfollow.isHidden = true
//    }
//    } else {
//        if self.videos.count > 0 {
//            self.follow.isHidden = false
//            self.unfollow.isHidden = true
//        } else {
//            self.follow.isHidden = true
//            self.unfollow.isHidden = true
//        }
//    }
//   
//                    // ...
//                }) { (error) in
//                    print(error.localizedDescription)
//            }
//        }
//        
//        
//         self.loadData()
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    override func viewDidAppear(_ animated: Bool) {
//        // Header - Image
//      
//    }
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
//
//    
//    @IBAction func unfollowPlace(_ sender: AnyObject) {
//  
//        let profiles = self.ref?.child("profiles")
//       profiles?.child(self.user!.uid).child("following").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            print(snapshot.hasChildren())
//            let values = snapshot.value as! [String : AnyObject]
//            
//            
//            for childItem in values{
//                
//                let item = childItem.1 as! String
//                let key = childItem.0
//                if item == SingletonData.staticInstance.selectedMapItem?.name {
//                profiles?.child(self.user!.uid).child("following").child(key).removeValue()
//                    self.follow.isHidden = false
//                    self.unfollow.isHidden = true
//                }
//            
//            }
//        
//        })
//    }
//    
//    @IBAction func followPlace(_ sender: AnyObject) {
//    
//    let item = SingletonData.staticInstance.selectedMapItem!.name
//    let key = ref?.child("profiles").child(user!.uid).child("following").childByAutoId().key
//   // self.ref.child("profiles").child(user!.uid).child("following").updateChildValues([key: item!])
//      
//        self.follow.isHidden = true
//        self.unfollow.isHidden = false
//      
//    }
//    
//    
//    
//    func imageResize (_ image: UIImage, sizeChange:CGSize)-> UIImage{
//        
//        let hasAlpha = true
//        let scale: CGFloat = 0.0 // Use scale factor of main screen
//        
//        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
//        image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
//        
//        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//        return scaledImage!
//    }
//    
//    
//    
//        func loadData(){
////            let loc = SingletonData.staticInstance.taggedLocation
////    
////    
////            let geoFire = GeoFire(firebaseRef: self.locationsRef)
////    
////            let query = geoFire.queryAtLocation(loc, withRadius: 1)
////    
////            query.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in
//   
//                self.videosRef.queryOrdered(byChild: "taggedLocation").queryEqual(toValue: SingletonData.staticInstance.selectedMapItem?.name).observe(.value, with: { (snapshot) in
//    
//                    for (i, item) in snapshot.children.enumerated() {
//                    self.videos.append(RealmObject(value: item as! FIRDataSnapshot))
//                    self.videos.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending })
//                  
//                        
//                        if(i == 0){
//                            let itemData = FIRItem(snapshot: item as! FIRDataSnapshot)
//                            let imgData = try? Data(contentsOf: URL(string: itemData.imagePath)!)
//                            if imgData != nil {
//                                let img = UIImage(data: imgData!)
//                                self.headerImageView.image = img
//                            }
//                            
//                            self.headerLabel.text = itemData.taggedLocation
//                            
//                        }
//                        
//                  
//                    
//                   
//                    self.videoCollection.reloadData()
//                    self.hintCollection.reloadData()
//                    }
//    
//                }) { (error) in
//                    print(error.localizedDescription)
//                }
//            
////            })
//        }
//
//    
//    
////    func loadData(){
////        let loc = SingletonData.staticInstance.taggedLocation
////
////        
////        let geoFire = GeoFire(firebaseRef: self.locationsRef)
////        
////        let query = geoFire.queryAtLocation(loc, withRadius: 1000)
////        
////        query.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in
////            
////           let name = SingletonData.staticInstance.selectedMapItem?.name
////            
////            self.videosRef.child(key).child("taggedLocation").queryEqualToValue(name).observeEventType(.Value, withBlock: { (snapshot) in
////                
////                self.videos.append(FIRItem(snapshot))
////                self.videos.sortInPlace({ $0.createdAt.compare($1.createdAt) == .OrderedDescending })
////                
////                
////                self.videoCollection.reloadData()
////                self.hintCollection.reloadData()
////                
////                
////            }) { (error) in
////                print(error.localizedDescription)
////            }
////        })
////    }
////    
////    func scrollViewDidScroll(scrollView: UIScrollView) {
////      
////        let offset = scrollView.contentOffset.y
//////        var avatarTransform = CATransform3DIdentity
////        var headerTransform = CATransform3DIdentity
////        
////        
////        // PULL DOWN -----------------
////      
////        
////        if offset < 0 {
////          
////            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
////            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
////            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
////            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
////            
////            header.layer.transform = headerTransform
////         
////            
////            UIView.animateWithDuration(0.3, animations: {
////                
////                self.follow.alpha = 0.0
////                self.headerLabel.alpha = 0.0
////                }, completion: nil)
////        } else {
////            
////            UIView.animateWithDuration(0.1, animations: {
////                
////                self.follow.alpha = 1.0
////                self.headerLabel.alpha = 1.0
////                
////                
////                }, completion: nil)
////        }
////            
////      
////  
////        
//////
//////            // Header -----------
//////            
//////            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
//////
//////        
//////        
//////        // Apply Transformations
//////        
//////        header.layer.transform = headerTransform
////////        avatarImage.layer.transform = avatarTransform
////    }
//    
//    
//    @IBAction func backBtn(_ sender: AnyObject) {
//         self.dismiss(animated: true, completion: nil)
//    }
//    
//    func removeDuplicates(_ array: [FIRItem]) -> [FIRItem] {
//        var encountered = Set<String>()
//        
//        var result: [FIRItem] = []
//        for value in array {
//            
//            if encountered.contains(value.key) {
//                // Do not add a duplicate element.
//            }
//            else {
//                // Add value to the set.
//                encountered.insert(value.key)
//                
//                // ... Append the value.
//                result.append(value)
//            }
//        }
//        return result
//    }
//    
//    
//    
//     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(videos.count)
//        let withoutDups = self.removeDuplicates(self.videos)
//        
//        self.videos = withoutDups
//        
//        return videos.count
//    }
//     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let obj = self.videos[(indexPath as NSIndexPath).row]
//        DispatchQueue.main.async {
//            
//            SingletonData.staticInstance.setSelectedVideoItem(obj.videoPath)
//
//            SingletonData.staticInstance.setSelectedObject(obj)
//
//            
//            self.present(self.asyncVideoViewController, animated: true) { () -> Void in
//            }
//            
//         
//            
//        }
//
//    }
//     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCollectionViewCell
//        
//        
//        
//        let obj = self.videos[(indexPath as NSIndexPath).row]
//        
//        print(obj)
//        
//        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
//        self.dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//        let date = self.dateFormatter.date(from: obj.createdAt)
//        cell.timeSince.text = SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true)
//        cell.displayTitle.text = obj.displayTitle
//        var imgUrl : String? = nil
//        let imgU = obj.imagePath
//        imgUrl = String(imgU)
//        
//    
//     //   cell.imgView.setImageWith(URL(string: imgUrl!)!)
//
//        return cell
//    }
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let withoutDups = self.removeDuplicates(self.videos)
//        
//        self.videos = withoutDups
//        
//        return videos.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HintTableViewCell
//        
//        let obj = self.videos[(indexPath as NSIndexPath).row]
//        
//        print(obj)
//        
//        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
//        self.dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//        let date = self.dateFormatter.date(from: obj.createdAt)
//        
//        
//        cell.videoTime.text = SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true)
//        cell.hintText.text = obj.displayHint
//        
//        var imgUrl : String? = nil
//        let imgU = obj.userPhoto
//        imgUrl = String(imgU)
//        print(obj.userPhoto)
//            
//        //    cell.displayPhoto.setImageWith(URL(string: imgUrl!)!)
//        cell.displayPhoto = cell.displayPhoto.asCircle()
//            return cell
//    }
//        
//    
//}
//
