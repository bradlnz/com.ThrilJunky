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
import PKHUD

class MoreInfoController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, ASVideoNodeDelegate {


    var videoNode : ASVideoNode? = nil
    
    let videosRef = Database.database().reference(withPath: "videos")
    let locationsRef = Database.database().reference(withPath: "locations")
    let profilesRef = Database.database().reference(withPath: "profiles")
    
    let storage = Storage.storage()
    let geofireRef = Database.database().reference()
    let user = Auth.auth().currentUser
    let videos: Array<Item> = []
    let mostRecentVideos : Array<Item> = []
    let keys : Array<String> = []
    let mostPopularVideos : [Item] = []
    let followingVideosList : [Item] = []
    let refHandle: DatabaseHandle? = nil
    
   var count = 0
    let videoRootPath = "https://1490263195.rsc.cdn77.org/videos/"
    let isFinishedPlaying : Bool = false
    let dateFormatter = DateFormatter()

    
    @IBOutlet weak var imageAddress: UILabel!
    @IBOutlet weak var imageName: UILabel!
   
    @IBOutlet weak var moreInfoVideo: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = ["Share", "Get Directions", "Ride With Uber"]
    let button = RideRequestButton()
    let asyncVideoController = AsyncVideoViewController()
    var ref: DatabaseReference?
    var userGenerated = [Item]()
    
    @IBAction func thumbsUpAction(_ sender: Any) {
        
    }

    @IBAction func thumbsDownAction(_ sender: Any) {
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
    videoNode = nil
    }
    override func viewWillAppear(_ animated: Bool) {
     
    HUD.show(.progress)
        title = ""
        if(SingletonData.staticInstance.selectedObject == nil){
            title = SingletonData.staticInstance.selectedAnnotation!.displayTitle
        } else {
            title = SingletonData.staticInstance.selectedObject!.displayTitle
        }
    }
    
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if(parent == nil){
             print("Back Button Pressed!")
             videoNode = nil
        }
    }
    @IBAction func voteUp(_ sender: Any) {
        
        let currentUser = Auth.auth().currentUser

        var key: String?
        
        if(SingletonData.staticInstance.selectedObject != nil)
        {
            key = SingletonData.staticInstance.selectedObject?.key
        }
        if(SingletonData.staticInstance.selectedAnnotation != nil){
            key = SingletonData.staticInstance.selectedAnnotation?.key
        }
        
        
        Database.database().reference(withPath: "profiles/" + currentUser!.uid + "/voted/" + key!).observeSingleEvent(of: .value, with: { (snapshot1) in
            
            
            if(!snapshot1.exists()){
                
                
                self.videosRef.child(key!).observe(.value, with: { (snapshot) in
                    
                    var snap = Item(snapshot: snapshot)
                    
                    
                    if self.count == 0 {
                        
                        self.videosRef.child(key!).updateChildValues(["voteUp": snap.voteUp + 1])
                        let videoCount : Float = Float(self.mostPopularVideos.count)
                        
                        print(videoCount)
                        
                        let votes : Float = Float(snap.voteUp - snap.voteDown)
                        
                        print(votes)
                        
                        
                        self.videosRef.child(key!).updateChildValues(["averageVote": votes])
                        
                        let userId = Auth.auth().currentUser?.uid
                        
                        
                        self.ref?.child("profiles").child(userId!).child("voted").updateChildValues([key! : "true"])
                        
                        let alertController = UIAlertController(title: "Thank you for contributing", message: "Thank you for contributing it really helps the community find fun activities to do.", preferredStyle: .alert)
                        
                        // Initialize Actions
                        let  okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                            print("The user is okay.")
                            
                        }
                        alertController.addAction(okAction)
                        
                        
                        // Present Alert Controller
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        self.count = 1
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
        let currentUser = Auth.auth().currentUser
        
        var key: String?
        
        if(SingletonData.staticInstance.selectedObject != nil)
        {
         key = SingletonData.staticInstance.selectedObject?.key
        }
        if(SingletonData.staticInstance.selectedAnnotation != nil){
            key = SingletonData.staticInstance.selectedAnnotation?.key
        }
        
        Database.database().reference(withPath: "profiles/" + currentUser!.uid + "/voted/" + key!).observeSingleEvent(of: .value, with: { (snapshot1) in
            
            
            
            if(!snapshot1.exists()){
                
                
                self.videosRef.child(key!).observe(.value, with: { (snapshot) in
                    
                    var snap = Item(snapshot: snapshot)
                    
                    
                    if self.count == 0 {
                        
                        self.videosRef.child(key!).updateChildValues(["voteDown": snap.voteDown + 1])
                        let videoCount : Float = Float(self.mostPopularVideos.count)
                        
                        print(videoCount)
                        
                        let votes : Float = Float(snap.voteUp - snap.voteDown)
                        
                        print(votes)
                        
                        
                        self.videosRef.child(key!).updateChildValues(["averageVote": votes])
                        
                        let userId = Auth.auth().currentUser?.uid
                        
                        
                        self.ref?.child("profiles").child(userId!).child("voted").updateChildValues([key! : "true"])
                        
                        let alertController = UIAlertController(title: "Thank you for contributing", message: "Thank you for contributing it really helps the community find fun activities to do.", preferredStyle: .alert)
                        
                        // Initialize Actions
                        let  okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                            print("The user is okay.")
                            
                        }
                        alertController.addAction(okAction)
                        
                        
                        // Present Alert Controller
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        self.count = 1
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
    
    videoNode = ASVideoNode()
    
   
    if(SingletonData.staticInstance.selectedObject == nil){
        
        
        if(SingletonData.staticInstance.selectedAnnotation!.website != ""){
            items.append("Visit Website")
        }
        
        videoNode?.delegate = self
        
        
        DispatchQueue.main.async {
        
        
        let url = URL(string: self.videoRootPath + SingletonData.staticInstance.selectedAnnotation!.videoPath!)
        let asset = AVAsset(url: url!)
        
        let origin = CGPoint.zero
        let size = CGSize(width: self.moreInfoVideo.frame.width, height: self.moreInfoVideo.frame.height)
        
        self.videoNode?.asset = asset
        self.videoNode?.shouldAutoplay = true
        self.videoNode?.shouldAutorepeat = true
        self.videoNode?.muted = true
        self.videoNode?.gravity = AVLayerVideoGravity.resizeAspectFill.rawValue
        self.videoNode?.zPosition = 0
        self.videoNode?.frame = CGRect(origin: origin, size: size)
        self.videoNode?.url = url
        
        self.moreInfoVideo.addSubnode(self.videoNode!)
        
        }
        
        imageName.text = SingletonData.staticInstance.selectedAnnotation?.title
        imageAddress.text = SingletonData.staticInstance.selectedAnnotation?.address
        
        loadUserGenerated(taggedLocation: SingletonData.staticInstance.selectedAnnotation?.address)
        
    } else {
        if(SingletonData.staticInstance.selectedObject!.website != ""){
            items.append("Visit Website")
        }
        
        
        self.videoNode?.delegate = self
        let url = URL(string:  self.videoRootPath + SingletonData.staticInstance.selectedObject!.videoPath)
        let asset = AVAsset(url: url!)
        
        let origin = CGPoint.zero
        let size = CGSize(width: moreInfoVideo.frame.width, height: moreInfoVideo.frame.height)
        
        self.videoNode?.asset = asset
        self.videoNode?.shouldAutoplay = true
        self.videoNode?.shouldAutorepeat = true
        self.videoNode?.muted = true
        self.videoNode?.gravity = AVLayerVideoGravity.resizeAspectFill.rawValue
        self.videoNode?.zPosition = 0
        self.videoNode?.frame = CGRect(origin: origin, size: size)
        self.videoNode?.url = url
        
        
        moreInfoVideo.addSubnode(videoNode!)
        
        
        imageName.text = SingletonData.staticInstance.selectedObject?.displayTitle
        imageAddress.text = SingletonData.staticInstance.selectedObject?.address
        
        loadUserGenerated(taggedLocation: SingletonData.staticInstance.selectedObject?.address)
        
    }

   self.collectionView.delegate = self
   self.collectionView.dataSource = self
   self.tableView.delegate = self
   self.tableView.dataSource = self
    
    
}
    
    func videoNode(_ videoNode: ASVideoNode, willChange state: ASVideoNodePlayerState, to toState: ASVideoNodePlayerState) {
        
        
        if(toState == ASVideoNodePlayerState.playing){
            HUD.hide()
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
     
        if(SingletonData.staticInstance.selectedObject != nil){
            let lng : Float = SingletonData.staticInstance.selectedObject!.lat
            let lat : Float = SingletonData.staticInstance.selectedObject!.lng
            
            let loc =  SingletonData.staticInstance.location
            
            
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
        
        if(SingletonData.staticInstance.selectedAnnotation != nil){
            let lng : Double = Double(SingletonData.staticInstance.selectedAnnotation!.coord.latitude)
            let lat : Double = Double(SingletonData.staticInstance.selectedAnnotation!.coord.longitude)
            
            let loc =  SingletonData.staticInstance.location
            
            
            if item == "Visit Website" && SingletonData.staticInstance.selectedAnnotation!.website != "" {
                let url = URL(string: SingletonData.staticInstance.selectedAnnotation!.website!)
                UIApplication.shared.openURL(url!)
                
            }
            
            if item == "Watch Again" {
                
                let imageURL = URL(string: SingletonData.staticInstance.selectedAnnotation!.imagePath!)
                SingletonData.staticInstance.setVideoImage(imageURL)
                SingletonData.staticInstance.setSelectedVideoItem("https://1490263195.rsc.cdn77.org/videos/" + SingletonData.staticInstance.selectedAnnotation!.videoPath!)
                
                self.present(asyncVideoController, animated: true, completion: nil)
            }
            
            if item == "Get Directions" {
                
                
                
                let url = URL(string: "http://maps.apple.com/?saddr=\(loc!.coordinate.latitude),\(loc!.coordinate.longitude)&daddr=\(lng),\(lat)")
                UIApplication.shared.openURL(url!)
                
                
            }
            
            if item == "Ride With Uber" {
                
                let pickupLocation = CLLocation(latitude: loc!.coordinate.latitude, longitude: loc!.coordinate.longitude)
                let dropoffLocation = CLLocation(latitude: lng, longitude: lat)
                let dropoffNickname = SingletonData.staticInstance.selectedAnnotation?.displayTitle
                
                print(dropoffLocation)
                
                let builder = RideParametersBuilder().setPickupLocation(pickupLocation).setDropoffLocation(dropoffLocation, nickname: dropoffNickname)
                let rideParameters = builder.build()
                self.button.requestBehavior.requestRide(rideParameters)
                
            }
            
        
            
            if item == "Share" {
                let textToShare = "Check out " + SingletonData.staticInstance.selectedAnnotation!.displayTitle! + " on ThrilJunky!"
                
                var url = URL(string: videoRootPath + SingletonData.staticInstance.selectedAnnotation!.videoPath!)!
                let urlData = NSData(contentsOf: url)
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                }) { saved, error in
                    if saved {
                        let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
                if ((urlData) != nil){
                    

                    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    let docDirectory = paths[0]
                    let filePath = "\(docDirectory)/tmpVideo.mov"
                    
                    urlData?.write(toFile: filePath, atomically: true)
                    // file saved
                    
                    let videoLink = URL(fileURLWithPath: filePath)
                    
                 
                    let activityVC = UIActivityViewController(activityItems: [textToShare, videoLink], applicationActivities: nil)
                    
                    activityVC.setValue("Video", forKey: "subject")
                    
                    
                    self.present(activityVC, animated: true, completion: nil)
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

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoreInfoCollectionCell
        //
        let item = self.items[(indexPath as NSIndexPath).row]
        
        cell.title.text = item
        
        if(item == "Get Directions"){
        cell.displayImg.image =  UIImage(named: "compass-direction")
        }
        
        if(item == "Ride With Uber"){
            cell.displayImg.contentMode = .scaleAspectFit
            cell.displayImg.image = UIImage(named: "uber")
        }
        
        if(item == "Share"){
            cell.displayImg.contentMode = .scaleAspectFit
            cell.displayImg.image = UIImage(named: "share1")
        }
        
        if(item == "Visit Website"){
            cell.displayImg.contentMode = .scaleAspectFit
            cell.displayImg.image = UIImage(named: "website")
        }
       // cell.backgroundColor = getRandomColor()
        //        let url = URL(string: item.imagePath)
        //
        //        cell.pickImage.kf.setImage(with: url)
        //        cell.pickImage.asCircle()
        //
        //        cell.pickTitle.text = item.displayTitle
        //        cell.pickLocation.text = item.taggedLocation
        //        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MoreInfoCell
        
 
        let item = self.userGenerated[(indexPath as NSIndexPath).row]
        
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
        
            if self.userGenerated.count > 0
            {
                tableView.separatorStyle = .singleLine
                numOfRows = self.userGenerated.count
            
                tableView.backgroundView = nil
            }
            else
            {
                tableView.separatorStyle  = .none
                
            
            }
            return numOfRows
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var obj = userGenerated[indexPath.row]
        
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
                self.ref = Database.database().reference()
                
                self.ref?.child("videos").queryOrdered(byChild: "address").queryEqual(toValue: taggedLocation).observe(.value, with: { snapshot in
                   
                    self.userGenerated.removeAll()
                    
                        if snapshot.hasChildren(){
                            
                           for group in snapshot.children {
                               let item = Item(snapshot: group as! DataSnapshot)
                            
                            var object = SingletonData.staticInstance.selectedObject
                            
                            if(object == nil){
                                if(SingletonData.staticInstance.selectedAnnotation?.key != item.key){
                                    self.userGenerated.append(item)
                                  
                                }
                                
                            } else {
                                if(object?.key != item.key){
                                    self.userGenerated.append(item)
                                    
                                }

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
