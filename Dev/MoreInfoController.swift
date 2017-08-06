//
//  MoreInfoController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 5/5/17.
//  Copyright © 2017 ThrilJunky LLC. All rights reserved.
//

import UIKit
import AVFoundation
import AsyncDisplayKit
import UberRides
import Firebase
import FBSDKShareKit
import FBSDKMessengerShareKit
//import PKHUD

class MoreInfoController: UIViewController, UITableViewDataSource, UITableViewDelegate, ASVideoNodeDelegate {


    var videoNode : ASVideoNode? = nil
    
    let videosRef = FIRDatabase.database().reference(withPath: "videos")
    let locationsRef = FIRDatabase.database().reference(withPath: "locations")
    let profilesRef = FIRDatabase.database().reference(withPath: "profiles")
    let ref = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let geofireRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    let videos: Array<FIRItem> = []
    let mostRecentVideos : Array<FIRItem> = []
    let keys : Array<String> = []
    let mostPopularVideos : [FIRItem] = []
    let followingVideosList : [FIRItem] = []
    let refHandle: FIRDatabaseHandle? = nil
    
    
    var uid : String = ""
    var displayTitle : String = ""
    var displayName : String = ""
    var taggedLocation : String = ""
    var userGenerated : String = ""
    var address : String = ""
    var videoPath : String = ""
    var imagePath : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var update : String = ""
    
    let videoRootPath = "https://storage.googleapis.com/project-316688844667019748.appspot.com/"
    let isFinishedPlaying : Bool = false
    let dateFormatter = DateFormatter()

    @IBOutlet weak var updateView: UIView!
    
    @IBOutlet weak var updateLbl: UILabel!
    @IBOutlet weak var imageAddress: UILabel!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var moreInfoVideo: UIView!
    @IBOutlet weak var tableView: UITableView!
   
    var items = ["Contribute", "Share", "Get Directions", "Ride With Uber"]
    let button = RideRequestButton()
    let asyncVideoController = AsyncVideoViewController()
    
    var userGenerateds = [FIRItem]()
    
    @IBAction func thumbsUpAction(_ sender: Any) {
        
    }

    @IBAction func thumbsDownAction(_ sender: Any) {
        
    }
    
    
    @IBAction func dismissMoreInfo(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        videoNode?.delegate = nil
       videoNode = nil
     
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
        for var i in self.moreInfoVideo.subviews {
            i.removeFromSuperview()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
              UIApplication.shared.statusBarStyle = .lightContent
//        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
//        navigationItem.leftBarButtonItem = backButton
        
        title = ""
//        if(SingletonData.staticInstance.selectedObject == nil){
//            title = SingletonData.staticInstance.selectedAnnotation!.displayTitle
//        } else {
//            title = SingletonData.staticInstance.selectedObject!.displayTitle
//        }
        
    }
    
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if(parent == nil){
             print("Back Button Pressed!")
             videoNode = nil
        }
    }
    @IBAction func voteUp(_ sender: Any) {
        
        let currentUser = FIRAuth.auth()?.currentUser

        var key: String?
        
        if(SingletonData.staticInstance.selectedObject != nil)
        {
            key = SingletonData.staticInstance.selectedObject?.key
        }
      
        
        
        FIRDatabase.database().reference(withPath: "profiles/" + currentUser!.uid + "/voted/" + key!).observeSingleEvent(of: .value, with: { (snapshot1) in
            
            
            if(!snapshot1.exists()){
                
                
                self.videosRef.child(key!).observe(.value, with: { (snapshot) in
                    
                    var snap = FIRItem(snapshot: snapshot)
                    
                    
                    if count == 0 {
                        
                        self.videosRef.child(key!).updateChildValues(["voteUp": snap.voteUp + 1])
                        let videoCount : Float = Float(self.mostPopularVideos.count)
                        
                        print(videoCount)
                        
                        let votes : Float = Float(snap.voteUp - snap.voteDown)
                        
                        print(votes)
                        
                        
                        self.videosRef.child(key!).updateChildValues(["averageVote": votes])
                        
                        let userId = FIRAuth.auth()?.currentUser?.uid
                        
                        
                        self.ref.child("profiles").child(userId!).child("voted").updateChildValues([key! : "true"])
                        
                        let alertController = UIAlertController(title: "Thank you for contributing", message: "Thank you for contributing it really helps the community find fun activities to do.", preferredStyle: .alert)
                        
                        // Initialize Actions
                        let  okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                            print("The user is okay.")
                            
                        }
                        alertController.addAction(okAction)
                        
                        
                        // Present Alert Controller
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        count = 1
                    }
                    
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            } else {
                let alertController = UIAlertController(title: "Thank you", message: "Thank you, but you've already voted for this.", preferredStyle: .alert)
                
                // Initialize Actions
                let  okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    print("The user is okay.")
                    
                }
                alertController.addAction(okAction)
                
                // Present Alert Controller
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        })

    }
    
    @IBAction func voteDown(_ sender: Any) {
        let currentUser = FIRAuth.auth()?.currentUser
        
        var key: String?
        
        if(SingletonData.staticInstance.selectedObject != nil)
        {
         key = SingletonData.staticInstance.selectedObject?.key
        }
//        if(SingletonData.staticInstance.selectedAnnotation != nil){
//            key = SingletonData.staticInstance.selectedAnnotation?.key
//        }
        
        FIRDatabase.database().reference(withPath: "profiles/" + currentUser!.uid + "/voted/" + key!).observeSingleEvent(of: .value, with: { (snapshot1) in
            
            
            
            if(!snapshot1.exists()){
                
                
                self.videosRef.child(key!).observe(.value, with: { (snapshot) in
                    
                    var snap = FIRItem(snapshot: snapshot)
                    
                    
                    if count == 0 {
                        
                        self.videosRef.child(key!).updateChildValues(["voteDown": snap.voteDown + 1])
                        let videoCount : Float = Float(self.mostPopularVideos.count)
                        
                        print(videoCount)
                        
                        let votes : Float = Float(snap.voteUp - snap.voteDown)
                        
                        print(votes)
                        
                        
                        self.videosRef.child(key!).updateChildValues(["averageVote": votes])
                        
                        let userId = FIRAuth.auth()?.currentUser?.uid
                        
                        
                        self.ref.child("profiles").child(userId!).child("voted").updateChildValues([key! : "true"])
                        
                        let alertController = UIAlertController(title: "Thank you for contributing", message: "Thank you for contributing it really helps the community find fun activities to do.", preferredStyle: .alert)
                        
                        // Initialize Actions
                        let  okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                            print("The user is okay.")
                            
                        }
                        alertController.addAction(okAction)
                        
                        
                        // Present Alert Controller
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        count = 1
                    }
                    
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            } else {
                let alertController = UIAlertController(title: "Thank you", message: "Thank you, but you've already voted for this.", preferredStyle: .alert)
                
                // Initialize Actions
                let  okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    print("The user is okay.")
                    
                }
                alertController.addAction(okAction)
                
                // Present Alert Controller
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        })
    }
    
override func viewDidLoad() {
    var key: String?
    
    self.videoNode?.delegate = self
       self.videoNode = ASVideoNode()
    
    if(SingletonData.staticInstance.selectedObject != nil)
    {
        key = SingletonData.staticInstance.selectedObject?.key
    }
//    if(SingletonData.staticInstance.selectedAnnotation != nil){
//        key = SingletonData.staticInstance.selectedAnnotation?.key
//    }
    
  videosRef.queryOrdered(byChild: "uid").queryEqual(toValue: key!).observe(.value, with: { (snapshot) in
    
    for var item in snapshot.children {
        let video = VideoModel(snapshot: item as! FIRDataSnapshot)
        
        self.update = video.update
        
        self.updateLbl.text = self.update
        
        if(self.update == ""){
            self.updateView.isHidden = true
        }
        
        
    }
        
      }) { (error) in
        print(error.localizedDescription)
     }
    
    
    videosRef.queryOrdered(byChild: "uid").queryEqual(toValue: key!).observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
        
        
        for var item in snapshot.children {
            let video = VideoModel(snapshot: item as! FIRDataSnapshot)
            
            self.ref.child("videos").child(key!).updateChildValues(["views": video.views + 1])
            
            
              self.ref.child("businesses").queryOrdered(byChild: "uid").queryEqual(toValue: video.uid).observe(.value, with: { (snap) in
                
                for var b in snap.children {
                    let business = BusinessModel(snapshot: b as! FIRDataSnapshot)
                    self.displayName = business.businessName
                    self.displayTitle = business.businessName
                    self.address = business.address
                    self.latitude = business.latitude
                    self.longitude = business.longitude
                }
                
                self.imageName.text = self.displayTitle
                self.imageAddress.text = self.address
                
                self.loadUserGenerated(taggedLocation: self.address)
              })
            self.uid = video.uid
                
            self.taggedLocation = video.taggedLocation
            self.userGenerated = video.userGenerated
                
            self.videoPath = video.videoPath
            self.imagePath = video.imagePath
                
            self.update = video.update
            
            
            DispatchQueue.main.async {
                
                
                    
                if video.videoPath.range(of: self.videoPath) != nil {
                    let url = URL(string: self.videoRootPath + self.videoPath)
                    let asset = AVAsset(url: url!)
                    
                    let origin = CGPoint.zero
                    let size = CGSize(width: self.moreInfoVideo.frame.width, height: self.moreInfoVideo.frame.height)
                    
                    
                    self.videoNode?.asset = asset
                    self.videoNode?.shouldAutoplay = true
                    self.videoNode?.shouldAutorepeat = true
                    self.videoNode?.muted = true
                    self.videoNode?.gravity = AVLayerVideoGravityResizeAspectFill
                    self.videoNode?.zPosition = 0
                    self.videoNode?.frame = CGRect(origin: origin, size: size)
                    self.videoNode?.url = url
                    
                    
                    self.moreInfoVideo.addSubnode(self.videoNode!)
                    
                }
                
                
                    
//                } else {
//                    if(SingletonData.staticInstance.selectedObject!.website != ""){
//                        self.items.append("Visit Website")
//                    }
//
//                    let url = URL(string:  self.videoRootPath + self.videoPath)
//                    let asset = AVAsset(url: url!)
//
//                    let origin = CGPoint.zero
//                    let size = CGSize(width: self.moreInfoVideo.frame.width, height: self.moreInfoVideo.frame.height)
//                    self.videoNode = ASVideoNode()
//
//                    self.videoNode?.delegate = self
//
//                    self.videoNode?.asset = asset
//                    self.videoNode?.shouldAutoplay = true
//                    self.videoNode?.shouldAutorepeat = true
//                    self.videoNode?.muted = true
//                    self.videoNode?.gravity = AVLayerVideoGravityResizeAspectFill
//                    self.videoNode?.zPosition = 0
//                    self.videoNode?.frame = CGRect(origin: origin, size: size)
//                    self.videoNode?.assetURL = URL(string: "https://storage.googleapis.com/project-316688844667019748.appspot.com/" + self.videoPath)
//                    self.videoNode?.url = url
//
//                    for var i in self.moreInfoVideo.subviews {
//                        i.removeFromSuperview()
//                    }
//
//                    self.moreInfoVideo.addSubnode(self.videoNode!)
//
//
//
//                    self.imageName.text = SingletonData.staticInstance.selectedObject?.displayTitle
//                    self.imageAddress.text = SingletonData.staticInstance.selectedObject?.address
//
//                    self.loadUserGenerated(taggedLocation: SingletonData.staticInstance.selectedObject?.address)
//
//                }
                    
//                self.collectionView.delegate = self
//                self.collectionView.dataSource = self
                self.tableView.delegate = self
                self.tableView.dataSource = self
                
//                let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
//
//                if(visibleItems.count > 0){
//                    let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
//                    let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
//                    self.collectionView.scrollToItem(at: nextItem, at: .right, animated: true)
//
//                }
                
            }
            
        }
        
        
        self.updateLbl.text = self.update
        
        if(self.update == ""){
            self.updateView.isHidden = true
        }
    
//    let video = ["uid": self.uid,
//                 "update": self.update,
//                 "displayTitle": self.displayTitle,
//                 "displayName": self.displayName,
//                 // "displayHint": displayHint,
//        "taggedLocation": self.taggedLocation,
//        "userGenerated": self.userGenerated,
//        "address": self.address,
//        "videoPath" : self.videoPath,
//        "imagePath": self.imagePath,
//        "latitude": self.latitude,
//        "longitude": self.longitude] as [String : Any]
//
//
//
        
        
    }) { (error) in
        print(error.localizedDescription)
    }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    @IBAction func contribute(_ sender: Any) {
     
    }
    
    @IBAction func share(_ sender: Any) {
   
            let someText:String = "Check out \(SingletonData.staticInstance.selectedObject!.displayName) on ThrilJunky"
            let objectsToShare:URL = URL(string: "https://thriljunky.com/video/\(SingletonData.staticInstance.selectedObject!.key)")!
            let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.mail]
            
            self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func GetDirections(_ sender: Any) {
   
        var lng : Float = SingletonData.staticInstance.selectedObject!.lat
        var lat : Float = SingletonData.staticInstance.selectedObject!.lng
        
        let loc =  SingletonData.staticInstance.location
        
        let url = URL(string: "http://maps.apple.com/?saddr=\(loc!.coordinate.latitude),\(loc!.coordinate.longitude)&daddr=\(lng),\(lat)")
        UIApplication.shared.openURL(url!)
        
    }
    
    
    @IBAction func rideWithUber(_ sender: Any) {
        let lng : Float = SingletonData.staticInstance.selectedObject!.lat
        let lat : Float = SingletonData.staticInstance.selectedObject!.lng
        
        let loc =  SingletonData.staticInstance.location
        
        let pickupLocation = CLLocation(latitude: loc!.coordinate.latitude, longitude: loc!.coordinate.longitude)
        let dropoffLocation = CLLocation(latitude: CLLocationDegrees(lng), longitude: CLLocationDegrees(lat))
        let dropoffNickname = SingletonData.staticInstance.selectedObject?.displayTitle
        
        print(dropoffLocation)
        
        let builder = RideParametersBuilder().setPickupLocation(pickupLocation).setDropoffLocation(dropoffLocation, nickname: dropoffNickname)
        let rideParameters = builder.build()
        self.button.requestBehavior.requestRide(rideParameters)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
     
        if(SingletonData.staticInstance.selectedObject != nil){
            let lng : Float = SingletonData.staticInstance.selectedObject!.lat
            let lat : Float = SingletonData.staticInstance.selectedObject!.lng
            
            let loc =  SingletonData.staticInstance.location
            
            if(item == "Contribute"){
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Post", bundle:nil)
//                let camera : CameraViewController = storyBoard.instantiateViewController(withIdentifier: "Share") as! CameraViewController
//                // let navigationController = UINavigationController(rootViewController: popup)
//                
//                self.present(camera, animated: false, completion: nil)
            }
            
            if item == "Visit Website" && SingletonData.staticInstance.selectedObject!.website != "" {
                let url = URL(string: SingletonData.staticInstance.selectedObject!.website)
                UIApplication.shared.openURL(url!)
                
            }
//            
//            if item == "Watch Again" {
//                
//                let imageURL = URL(string: SingletonData.staticInstance.selectedObject!.imagePath)
//                SingletonData.staticInstance.setVideoImage(imageURL)
//                SingletonData.staticInstance.setSelectedVideoItem("https://project-316688844667019748.appspot.com.storage.googleapis.com/videos/" + SingletonData.staticInstance.selectedObject!.videoPath)
//                
//                self.present(asyncVideoController, animated: true, completion: nil)
//            }
//            
            if item == "Get Directions" {
                
                
                let url = URL(string: "http://maps.apple.com/?saddr=\(loc!.coordinate.latitude),\(loc!.coordinate.longitude)&daddr=\(lng),\(lat)")
                UIApplication.shared.openURL(url!)
                
                
            }
            
            if item == "Ride With Uber" {
                
                let pickupLocation = CLLocation(latitude: loc!.coordinate.latitude, longitude: loc!.coordinate.longitude)
                let dropoffLocation = CLLocation(latitude: CLLocationDegrees(lng), longitude: CLLocationDegrees(lat))
                let dropoffNickname = SingletonData.staticInstance.selectedObject?.displayTitle
                
                print(dropoffLocation)
                
                let builder = RideParametersBuilder().setPickupLocation(pickupLocation).setDropoffLocation(dropoffLocation, nickname: dropoffNickname)
                let rideParameters = builder.build()
                self.button.requestBehavior.requestRide(rideParameters)
                
            }
            
            if item == "Share" {
                let textToShare = "Check out " + SingletonData.staticInstance.selectedObject!.displayTitle + " on ThrilJunky!"
                
                var url = URL(string: videoRootPath + SingletonData.staticInstance.selectedObject!.videoPath)!
                let urlData = NSData(contentsOf: url)
               
                
                if ((urlData) != nil){
                
                    
                    var options = FBSDKMessengerShareOptions()
                    options.metadata = textToShare
                    
                    FBSDKMessengerSharer.shareVideo(urlData! as Data, with: options)
//                    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//                    let docDirectory = paths[0]
//                    let filePath = "\(docDirectory)/tmpVideo.mov"
//                    urlData?.write(toFile: filePath, atomically: true)
//                    // file saved
//                    
//                    let videoLink = NSURL(fileURLWithPath: filePath)
//                    var items : [Any] = [videoLink]
//                    
//                    let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//                    
//                    
//                    activityVC.setValue("Video", forKey: "subject")
//
//                    
//                    self.present(activityVC, animated: true, completion: nil)
                }

                
            }

        }
        
      

      
    }
    

    @IBAction func reportBtn(_ sender: Any) {
        let pickerData = [
            ["value": "NotForMe", "display": "Not for me"],
            ["value": "AlreadySeenVideo", "display": "Already seen video"],
            ["value": "VideoDoesntLoad", "display": "Video doesn't load"],
            ["value": "Spam", "display": "Spam"],
            ["value": "WrongCategory", "display": "Wrong Category"],
            ["value": "BlockVideo", "display": "Block Video"]
        ]
        
        
        PickerDialog().show(title: "Report Inappropriate", options: pickerData, selected: "NotForMe") {
            (value) -> Void in
            
            print("Unit selected: \(value)")
        }
    }

    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoreInfoCollectionCell
//        //
//        let item = self.items[(indexPath as NSIndexPath).row]
//
//        cell.title.text = item
//
//        if(item == "Contribute"){
//
//            cell.displayImg.image = UIImage(named: "photography-camera")
//
//        }
//
//        if(item == "Get Directions"){
//        cell.displayImg.image =  UIImage(named: "compass-direction")
//        }
//
//        if(item == "Ride With Uber"){
//            cell.displayImg.contentMode = .scaleAspectFit
//            cell.displayImg.image = UIImage(named: "uber")
//        }
//
//        if(item == "Share"){
//            cell.displayImg.contentMode = .scaleAspectFit
//            cell.displayImg.image = UIImage(named: "share1")
//        }
//
//        if(item == "Visit Website"){
//            cell.displayImg.contentMode = .scaleAspectFit
//            cell.displayImg.image = UIImage(named: "website")
//        }
//       // cell.backgroundColor = getRandomColor()
//        //        let url = URL(string: item.imagePath)
//        //
//        //        cell.pickImage.kf.setImage(with: url)
//        //        cell.pickImage.asCircle()
//        //
//        //        cell.pickTitle.text = item.displayTitle
//        //        cell.pickLocation.text = item.taggedLocation
//        //
//        return cell
//    }
//
//
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MoreInfoCell
        
 
        let item = self.userGenerateds[(indexPath as NSIndexPath).row]
        
        var dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let date = dateFormatter.date(from: item.createdAt)
        if(date != nil){
            cell.createdAt.text = SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true)
        }
        cell.displayTitle.text = item.displayTitle
        
        cell.displayImg.imageFromServerURL(urlString: item.imagePath)
        
        cell.backgroundColor = UIColor.lightGray

        
        return cell
        
        
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // return self.userGenerated.count
        
       
            var numOfRows: Int = 0
        
            if self.userGenerateds.count > 0
            {
                tableView.separatorStyle = .singleLine
                numOfRows = self.userGenerateds.count
            
                tableView.backgroundView = nil
            }
            else
            {
                tableView.separatorStyle  = .none
                
            
            }
            return numOfRows
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var obj = userGenerateds[indexPath.row]
        
        let imageURL = URL(string: obj.imagePath)
        
        SingletonData.staticInstance.setVideoImage(imageURL)
        SingletonData.staticInstance.setSelectedVideoItem("https://1490263195.rsc.cdn77.org/videos/" + obj.videoPath)
        
        self.present(asyncVideoController, animated: true, completion: nil)

    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                print(placemark.addressDictionary!)
            } else {
                
            }
        }
    }
    
    
    func loadUserGenerated(taggedLocation: String?) {
       
        DispatchQueue.main.async {

            DispatchQueue.main.async {
                
                self.ref.child("videos").queryOrdered(byChild: "address").queryEqual(toValue: taggedLocation).observe(.value, with: { snapshot in
                   
                    self.userGenerateds.removeAll()
                    
                        if snapshot.hasChildren(){
                            
                           for group in snapshot.children {
                               let item = FIRItem(snapshot: group as! FIRDataSnapshot)
                            
                            var object = SingletonData.staticInstance.selectedObject
                            
                         
                                if(object?.key != item.key){
                                    self.userGenerateds.append(item)
                                    
                                }

                            
                            
                           
                           }
                      }
                    self.tableView.reloadData()
                })
            
            }
        }
    }

    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deinit called")
    }
}
