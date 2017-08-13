
//
//  ViewController.swift
//  Dev
//
//  Created by Brad Lietz on 10/01/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import UberRides
import Firebase
import ReachabilitySwift
import SwiftyImage
import AsyncDisplayKit
import MIBadgeButton_Swift
//import PKHUD
import Koloda
import RealmSwift
import GeoQueries
import GooglePlaces
import Crashlytics // If using Answers with Crashlytics
//import Answers // If using Answers without Crashlytics

class ViewController: UIViewController, FIRDatabaseReferenceable, ASVideoNodeDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let geocoder = CLGeocoder()
  
    var asyncVideoController = AsyncVideoViewController()
    
    var reachability : Reachability? = nil
    var player = AVPlayer()
    var playerItem : AVPlayerItem?
    var ref: FIRDatabaseReference?
   // var cluster:[FBAnnotation] = []
    var videoNode : ASVideoNode! = nil
    var networkImage = ASNetworkImageNode()
    var displayNode = ASDisplayNode()
    var initialize : Bool? = true
    var initLoad : Bool? = true
    var realm : Realm! = nil
    var swiping : Bool? = false
    private var dragArea: UIView?
    private var dragAreaBounds = CGRect.zero
   
    @IBOutlet weak var expandRadius: UILabel!
    @IBOutlet weak var noMoreTitle: UILabel!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var catCollectionView: UICollectionView!
    
    @IBOutlet weak var yesBtn: UIButton!
    
    @IBOutlet weak var noBtn: UIButton!
    
    fileprivate var PlayerObserverContext = 0
    fileprivate var PlayerItemObserverContext = 0
    fileprivate var PlayerLayerObserverContext = 0
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var blurEffectView : UIVisualEffectView?
    var callButton = UIButton(frame: CGRect(x: 0, y: 0, width: 210, height: 40))
    var websiteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 210, height: 40))
    var getDirectionsButton = UIButton(frame: CGRect(x: 0, y: 00, width: 210, height: 40))
    var activityTitleModal = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var closeButton = UIButton(type: UIButtonType.system) as UIButton
    let voteUpBtn = UIButton(type: UIButtonType.system) as UIButton
    let voteUpBtnDone = UIButton(type: UIButtonType.system) as UIButton
   // var rideWithUberbutton = RequestButton()
    let videosRef = FIRDatabase.database().reference(withPath: "videos")
    let badgesRef = FIRDatabase.database().reference(withPath: "profiles")
      var data : [FIRItem] = []
    var count = SingletonData.staticInstance.catCount 
    let locationsRef = FIRDatabase.database().reference(withPath: "locations")
    let storage = FIRStorage.storage()
    let geofireRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    var videos: [RealmObject] = []
    var closestVideos: [FIRItem] = []
    var mostRecentVideos : Array<FIRItem> = []
    var keys : Array<String> = []
    var mostPopularVideos : [FIRItem] = []
    var followingVideosList : [FIRItem] = []
    
    var categoryLevel : String? = "ActivityCategories"
    var filteredData : [RealmObject] = []
    
    var refHandle: FIRDatabaseHandle?
    var keysSwiped = [String]()
    var yesLabel : UILabel?
    var noLabel : UILabel?
    var videoIndex : Int? = 0
    let dateFormatter = DateFormatter()
    let closeBtn = UIButton(type: UIButtonType.system) as UIButton
    let tickBtn = UIButton(type: UIButtonType.system) as UIButton
    var isFinishedPlaying : Bool = false
    //var mapHeight : CGFloat? = 250
    var images = [UIImage(named: "All1"),
                    UIImage(named: "Indoor1"),
                  UIImage(named: "Outdoor1"),
                  UIImage(named: "Food1"),
                    UIImage(named: "Bar1"),
                  UIImage(named: "Nightlife1"),
                  UIImage(named: "Events1")]
    
    var categories: [String] = ["All",
                                "Indoor",
                                "Outdoor",
                                "Food",
                                "Bars",
                                "Nightlife",
                                "Events"]
    
    let wouldYouDoThisLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let profileLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let userHint = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let userHintText = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let DisplayTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let Desc = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let imageViewProfile = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

 
    @IBOutlet weak var menu: UIView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var filterBtn: UIBarButtonItem!
    @IBOutlet weak var yourPicksBtn: MIBadgeButton!
    @IBOutlet weak var toggleMap: UIButton!
    @IBOutlet weak var cardView: KolodaView!

    var heightConstraint : NSLayoutConstraint?
    
    var setView : UIView!
    
    func addedToPicks() {
        loadBadgeNumber()
    }

    @IBAction func openSideMenu(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    
    
    weak var polyLine: MKPolyline?
    var coordinates = [CLLocationCoordinate2D]()
     var points = [CLLocationCoordinate2D]()
    
    @IBAction func searchLocation(_ sender: Any) {

        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Set a filter to return only addresses.
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.region
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
        
    }

    func noMoreCardsToLoad() {
        self.noMoreTitle.isHidden = false
        self.expandRadius.isHidden = false
        self.refreshBtn.isHidden = false
    }
    
    func reloadCards(input: Bool) {
    
        self.cardView.isHidden = false
        
        let alertController = UIAlertController(title: "Thank you for contributing", message: "Thank you for contributing it really helps the community find fun activities to do.", preferredStyle: .alert)
        
        // Initialize Actions
        let  okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            print("The user is okay.")
    
        }
         alertController.addAction(okAction)
        
         if(input == false){
            // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)
        
        }

        if(SingletonData.staticInstance.overrideLocation != nil){
       
            self.loadClosestVideos(loc: SingletonData.staticInstance.overrideLocation)
            self.loadNextCard()

        } else {
     
                 self.loadClosestVideos(loc: SingletonData.staticInstance.location)
                 self.loadNextCard()
        }
        
    }
  //  @IBOutlet weak var followingLabel: UILabel!
    
    
    
    @IBAction func refreshCards(_ sender: Any) {
        
        self.noMoreTitle.isHidden = true
        self.expandRadius.isHidden = true
        self.refreshBtn.isHidden = true
        
        self.categoryLevel = "ActivityCategories"
        self.categories = ["All",
                           "Indoor",
                           "Outdoor",
                           "Food",
                           "Bars",
                           "Nightlife",
                           "Events",
                           "Other"];
        
        catCollectionView.reloadData()
        self.catCollectionView.isHidden = false
        let userId = FIRAuth.auth()?.currentUser?.uid
        self.ref?.child("profiles").child(userId!).child("swiped").removeValue()
        self.cardView.resetCurrentCardIndex()
        
        reloadCards(input: true)
        
    }

    func thumbsDownButtonPressed(){
        self.cardView!.swipe(.left)
    }
    func thumbsUpButtonPressed(){
        self.cardView!.swipe(.right)
    }
    override func viewDidLoad() {
        load()
        
   
        yesBtn.layer.cornerRadius = 0.5 * yesBtn.bounds.size.width
        yesBtn.backgroundColor = UIColor.white
        yesBtn.clipsToBounds = true
        yesBtn.tintColor = UIColor.green
        yesBtn.setImage(UIImage(named:"icons8-like_filled"), for: .normal)
        yesBtn.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
    
        noBtn.layer.cornerRadius = 0.5 * noBtn.bounds.size.width
        noBtn.backgroundColor = UIColor.white
        noBtn.clipsToBounds = true
        noBtn.tintColor = UIColor.red
        noBtn.setImage(UIImage(named:"cancel"), for: .normal)
        noBtn.addTarget(self, action: #selector(thumbsDownButtonPressed), for: .touchUpInside)
      
//        let camera = GMSCameraPosition.camera(withLatitude: -33.868,
//                                              longitude: 151.2086,
//                                              zoom: 14)
//        let map = GMSMapView.map(withFrame: .zero, camera: camera)
//
//        let marker = GMSMarker()
//        marker.position = camera.target
//        marker.snippet = "Hello World"
//        marker.appearAnimation = kGMSMarkerAnimationPop
//        marker.map = map
//
      //  self.mapView = mapView
        
    }
    func load() {
        super.viewDidLoad()
        realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }

     
        self.refreshBtn.isHidden = true
        self.expandRadius.isHidden = true
        self.noMoreTitle.isHidden = true
        self.cardView.dataSource = self
        self.cardView.delegate = self
      
        self.cardView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 450)
        
        self.cardView.countOfVisibleCards = 1
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
     
        self.catCollectionView.isHidden = false
        self.catCollectionView.delegate = self
        self.catCollectionView.dataSource = self
        
        
        let loc = SingletonData.staticInstance.location

        self.ref = FIRDatabase.database().reference()
        
        if loc != nil {
            
            if videos.count <= 0 {
                
                self.videosRef.observeSingleEvent(of: .value, with: { (snapshot) in
             
                    for snap in snapshot.children{
                    
                        let item = FIRItem(snapshot: snap as! FIRDataSnapshot)
                        
                        if(item.userGenerated == "false"){
                        
                            self.ref.child("businesses").queryOrdered(byChild: "uid").queryEqual(toValue: item.uid).observe(.value, with: { (snap) in
                                // Get user value
                                
                                for vid in snap.children {
                                    let business = BusinessModel(snapshot: vid as! FIRDataSnapshot)
                                    
                                    let numberFormatter = NumberFormatter()
                                    let lat = numberFormatter.number(from: business.latitude)
                                    let lng = numberFormatter.number(from: business.longitude)
                                    
                                    // Get the default Realm
                                    let realm = try! Realm()
                                    
                                    try! realm.write {
                                        
                                        let obj = RealmObject()
                                        
                                        obj.ActivityCategories = item.ActivityCategories
                                        obj.RefinedActivityCategories = item.RefinedActivityCategories
                                        obj.SubActivityCategories = item.SubActivityCategories
                                        obj.address = item.address
                                        obj.createdAt = item.createdAt
                                        obj.displayName = business.businessName
                                        obj.displayTitle = business.businessName
                                        obj.imagePath = item.imagePath
                                        obj.key = item.key
                                        obj.lat = Float(lat!)
                                        obj.lng = Float(lng!)
                                        obj.videoPath = item.videoPath
                                        obj.website = item.website
                                        obj.phone = item.phone
                                        
                                        realm.add(obj)
                                    }
                                }
                                
                                self.loadClosestVideos(loc: SingletonData.staticInstance.location)
                                self.loadNextCard()
                                
                            }) { (error) in
                                print(error.localizedDescription)
                            }
                        
                        }
             
                    }
    
                    if(SingletonData.staticInstance.overrideLocation != nil){
                        self.loadClosestVideos(loc: SingletonData.staticInstance.overrideLocation)
                        self.loadNextCard()
                    } else {
                     
                        self.loadClosestVideos(loc: SingletonData.staticInstance.location)
                        self.loadNextCard()
                    }
                 
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            }
        }

    }
    
    func loadBadgeNumber(){
        let currentUser = FIRAuth.auth()?.currentUser
        var count = 0
        DispatchQueue.main.async {
            self.badgesRef.child(currentUser!.uid).child("picks").queryOrdered(byChild: "show").queryEqual(toValue: "true").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
                print(snapshot)
                if snapshot.hasChildren(){
                    
                    for _ in snapshot.children.reversed(){
                        count = count + 1
                    }
                    
                    self.yourPicksBtn.badgeString = String(count)
                    self.yourPicksBtn.badgeTextColor = UIColor.white
                    self.yourPicksBtn.badgeBackgroundColor = UIColor.red
                    
                }
            }
        }

    }
    
    func loadVideosByCategory(category: String?, categoryLevel : String, loc: CLLocation?) {
     
        for item in self.cardView.subviews {
         item.removeFromSuperview()
        }
        
        self.filteredData.removeAll()
        
        self.loadClosestVideos(loc: loc)
        self.cardView.isHidden = false
        
        self.noMoreTitle.isHidden = true
        self.expandRadius.isHidden = true
        self.refreshBtn.isHidden = true
        
        if SingletonData.staticInstance.catCount == 0 {
            data = []
            SingletonData.staticInstance.setCatCount(input: 1)
        }
        
        if(categoryLevel == "ActivityCategories"){
            
                filteredData.removeAll()
        for item in self.videos {
     
            if item.ActivityCategories.contains(string: category!){
                filteredData.append(item)
            }
        
            }
        }

        if(categoryLevel == "SubActivityCategories"){
            filteredData.removeAll()
            for item in self.videos {
                if(item.SubActivityCategories != "") {
                if item.SubActivityCategories.contains(string: category!){
                    filteredData.append(item)
                }
                } else {
                      filteredData.removeAll()
                    for item in self.videos {
                        
                        if item.ActivityCategories.contains(string: category!){
                            filteredData.append(item)
                        }
                    }
                  }
                }
                
            }
        
        if(categoryLevel == "RefinedActivityCategories"){
            
            filteredData.removeAll()
            for item in self.videos {
                
                if(item.RefinedActivityCategories != ""){
                if item.RefinedActivityCategories.contains(string: category!){
                    filteredData.append(item)
                    }
                } else {
                      filteredData.removeAll()
                    for item in self.videos {
                        
                        if item.SubActivityCategories.contains(string: category!){
                            filteredData.append(item)
                        }
                    }
                }
                
            }
        }
        print(filteredData.count)
        if(filteredData.count <= 0){
            
            self.noMoreTitle.isHidden = false
            self.expandRadius.isHidden = false
            self.refreshBtn.isHidden = false
      
        } else {
         
            for item in filteredData {
                
                let obj = RealmObject()
                
                obj.ActivityCategories = item.ActivityCategories
                obj.address = item.address
                obj.createdAt = item.createdAt
                obj.displayName = item.displayName
                obj.displayTitle = item.displayTitle
                obj.imagePath = item.imagePath
                obj.key = item.key
                obj.lat = item.lat
                obj.lng = item.lng
                obj.videoPath = item.videoPath
                obj.website = item.website
                
                self.videos.append(obj)
            }
            
            self.cardView.reloadData()
        }

        self.catCollectionView.isHidden = false
    }
    
   
    func loadContent(loc: CLLocation?) {
        
         self.keysSwiped = []
            
                let currentUser = FIRAuth.auth()?.currentUser
                
                self.ref = FIRDatabase.database().reference()
                
                self.ref?.child("profiles").child(currentUser!.uid).child("swiped").observe(.value, with: { snapshot in
                    
                    if snapshot.hasChildren(){
                        
                        for group in snapshot.children {
                            let item = FIRItem(snapshot: group as! FIRDataSnapshot)
                            
                            if(!self.keysSwiped.contains(item.key)){
                                   self.keysSwiped.append(item.key)
                            }
                    }
                }
        })
    }
    
    
    func loadClosestVideos(loc: CLLocation?) {
        
        SingletonData.staticInstance.closestVideo.removeAll()
        
        self.videos.removeAll()
            
        let results2 : [RealmObject]? = self.realm.findNearby(type: RealmObject.self, origin: loc!.coordinate, radius: 50000, sortAscending: true)
        
          if let results = results2
          {
            for item in results.removeDuplicates() {
            
                SingletonData.staticInstance.appendObject(item)
                self.videos.append(item)
                
            }
         }
    }

    
    func loadNextCard()
    {
        self.cardView.reloadData()
    }
    

 override func viewWillAppear(_ animated: Bool) {
    
     UIApplication.shared.isStatusBarHidden = false
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.tintColor = UIColor.black
    
    UIApplication.shared.statusBarStyle = .default
    
    DispatchQueue.main.async {
        var loc : CLLocation?
        
        
    self.realm = try? Realm()
        
    
    self.yourPicksBtn.badgeString = String(0)
    self.loadBadgeNumber()
    
   
    if(SingletonData.staticInstance.overrideLocation != nil){
        loc = SingletonData.staticInstance.overrideLocation
    } else {
        loc = SingletonData.staticInstance.location
    }

        self.loadClosestVideos(loc: loc)
      }
   }
    

    @IBAction func toggleMap(_ sender: AnyObject) {
       //Hide this
    }
   
    func buttonClicked(){
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "moreInfoSegue", sender: self)
            }
    }


    
    
    @IBAction func openPicks(_ sender: AnyObject) {
              DispatchQueue.main.async{
                 let viewController : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YourPicks")
                        self.present(viewController, animated: true, completion: nil)
            
        }
    }
    

    //TODO Re Add Later
    @IBAction func resetCards(_ sender: Any) {
        
        self.noMoreTitle.isHidden = true
        self.expandRadius.isHidden = true
        self.refreshBtn.isHidden = true
        
        self.categoryLevel = "ActivityCategories"
        self.categories = ["All",
                           "Indoor",
                           "Outdoor",
                           "Food",
                           "Bars",
                           "Nightlife",
                           "Events",
                           "Other"];
        
        catCollectionView.reloadData()
        self.catCollectionView.isHidden = false
        let userId = FIRAuth.auth()?.currentUser?.uid
        self.ref?.child("profiles").child(userId!).child("swiped").removeValue()
        self.cardView.resetCurrentCardIndex()
        
        reloadCards(input: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! FilterCollectionView

        cell.textLbl.text = self.categories[indexPath.row]
    
         cell.textLbl.textColor = UIColor.black
        return cell
  
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        self.cardView.resetCurrentCardIndex()
        
        let loc : CLLocation?
        
        if(SingletonData.staticInstance.overrideLocation != nil){
            
            loc = SingletonData.staticInstance.overrideLocation
            
        } else {
            
            loc = SingletonData.staticInstance.location
        }
      
        self.loadVideosByCategory(category: self.categories[indexPath.row], categoryLevel: self.categoryLevel!, loc: loc)
        
    
        if self.categories[indexPath.row] != "Back" && self.categories[indexPath.row] != "All"{
         
            if self.categoryLevel == "SubActivityCategories" {
             
                self.categoryLevel = "RefinedActivityCategories"
                
                if self.categories[indexPath.row] == "Quick" || self.categories[indexPath.row] == "Casual"
                {
                 
                    
                    self.categories = ["Quick Bites", "Casual Dining", "Brunch", "Outdoor", "Back"];
                    
                    collectionView.reloadData()
                }
        
                if self.categories[indexPath.row] == "Ethnic" || self.categories[indexPath.row] == "Exotic" || self.categories[indexPath.row] == "Foreign"
                {
                    self.categories = ["Thai", "Chinese", "Japanese", "Mexican", "Italian", "Seafood", "American", "Breakfast", "Steakhouse", "Other", "Back"];
                    
                    collectionView.reloadData()
                }
                
                if self.categories[indexPath.row] == "Pubs"
                {
                    self.categories = ["Irish", "English", "Sports Bar", "Back"];
                    
                    collectionView.reloadData()
                }
                
              
                if self.categories[indexPath.row] == "Exotic Bars"
                {
                
                    self.categories = ["Speakeasies", "Specialist Bars", "Back"];
                    
                    collectionView.reloadData()
                }
                
                if self.categories[indexPath.row] == "Beats"
                {
                   
                    self.categories = ["Live Music", "Back"];
                    
                    collectionView.reloadData()
                }

                if self.categories[indexPath.row] == "Nightclubs"
                {
            
                    
                    self.categories = ["Upmarket", "Casual", "Dance Spots", "Back"];
                    
                    collectionView.reloadData()
                }
                
                if self.categories[indexPath.row] == "Shows"
                {
                
                    self.categories = ["Theatre", "Caberet", "Back"];
                    
                    collectionView.reloadData()
                }
                
                if self.categories[indexPath.row] == "Parties"
                {
                
                    self.categories = ["Public", "Back"];
                    
                    collectionView.reloadData()
                }
                
                if self.categories[indexPath.row] == "Music"
                {
                    
                    self.categories = ["Concerts", "Back"];
                    
                    collectionView.reloadData()
                }

            }
            
            if self.categoryLevel == "ActivityCategories" {
                
                if self.categories[indexPath.row] == "Food"
                {
                    
                    self.categories = ["Quick", "Casual", "Ethnic", "Exotic", "Foreign", "Fine Dining", "Back"];
                    
                    collectionView.reloadData()
                    
                    self.categoryLevel = "SubActivityCategories"
                    
                }
                
                if self.categories[indexPath.row] == "Bars"
                {
                    self.categoryLevel = "SubActivityCategories"
                    
                    self.categories = ["Pubs", "Cocktail Bars", "Rooftop Bars", "Beer Bars", "Wine Bars", "Restaurant Bars", "Exotic Bars", "Live Music Bars", "Back"];
                    
                    collectionView.reloadData()
                }
                
                if self.categories[indexPath.row] == "Outdoor Activities"
                {
                    self.categoryLevel = "SubActivityCategories"
                    
                    self.categories = ["Extreme", "User Activities", "Outdoor Entertainment", "Sports", "Back"];
                    
                    collectionView.reloadData()
                }
                
                if self.categories[indexPath.row] == "Outdoor Activities"
                {
                    self.categoryLevel = "SubActivityCategories"
                    
                    self.categories = ["Extreme", "User Activities", "Outdoor Entertainment", "Sports", "Back"];
                    
                    collectionView.reloadData()
                }
                
                if self.categories[indexPath.row] == "Indoor Activity"
                {
                    self.categoryLevel = "SubActivityCategories"
                    
                    self.categories = ["Extreme", "Sports", "Exercise", "Bar activities", "Back"];
                    
                    collectionView.reloadData()
                }
                
                
                if self.categories[indexPath.row] == "Nightlife"
                {
                    
                    self.categoryLevel = "SubActivityCategories"
                    
                    self.categories = ["Nightclubs", "Shows", "Parties", "Music", "Back"];
                    
                    collectionView.reloadData()
                    
                    
                    
                }
                
            }
            
            
        } else {
            self.noMoreTitle.isHidden = true
            self.expandRadius.isHidden = true
            self.refreshBtn.isHidden = true
            
            self.categoryLevel = "ActivityCategories"
            self.categories = ["All",
                               "Indoor",
                               "Outdoor",
                               "Food",
                               "Bars",
                               "Nightlife",
                               "Events",
                               "Other"];
            
            collectionView.reloadData()
            self.catCollectionView.isHidden = false
            let userId = FIRAuth.auth()?.currentUser?.uid
            self.ref?.child("profiles").child(userId!).child("swiped").removeValue()
            self.cardView.resetCurrentCardIndex()
            
            reloadCards(input: true)
        }
        
    
        
    }
   
    func videoNode(_ videoNode: ASVideoNode, willChange state: ASVideoNodePlayerState, to toState: ASVideoNodePlayerState) {
      
        if(toState == ASVideoNodePlayerState.readyToPlay){
            
              videoNode.play()
            
        }
     
    }
    
    deinit{
        print("deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: KolodaViewDelegate
extension ViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        self.noMoreTitle.isHidden = false
        self.expandRadius.isHidden = false
        self.refreshBtn.isHidden = false
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
  
        SingletonData.staticInstance.setSelectedObject(self.videos[index])
    
        var item = self.videos[index]
        
        Answers.logContentView(withName: item.displayName,
                                       contentType: "business",
                                       contentId: item.key,
                                       customAttributes: ["address": item.address
            ])
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc : MoreInfoController = storyboard.instantiateViewController(withIdentifier: "MoreInfoController") as! MoreInfoController
        
       self.navigationController?.pushViewController(vc, animated: true)
    }
   
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection)
    {
        
        self.swiping = false
        
        if direction == .left {
           
            
            DispatchQueue.main.async {
                Answers.logCustomEvent(withName: "Swiped Left",
                                               customAttributes: [
                                                "amount": 1
                    ])
                self.ref = FIRDatabase.database().reference()
                
                print(self.videos.count)
                if self.videos.count > 0 {
                let card = self.videos[index]
                
                let video = ["ActivityCategories": card.ActivityCategories,
                             "displayTitle": card.displayTitle,
                             "displayName": card.displayName,
                             "address": card.address,
                             "videoPath" : card.videoPath,
                             "imagePath": card.imagePath,
                             "latitude": String(card.lat),
                             "longitude": String(card.lng),
                             "createdAt": card.createdAt,
                             "show": "false"]
                
                let userId = FIRAuth.auth()?.currentUser?.uid
                    
                let key = card.key
                
                self.ref?.child("profiles").child(userId!).child("swiped").updateChildValues([key : video])
                
                self.loadBadgeNumber()
                
                
                    self.videosRef.child(card.key).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let snap = FIRItem(snapshot: snapshot)
                        
                        if self.count == 0 {
                            
                            self.videosRef.child(card.key).updateChildValues(["swipedLeft": snap.voteDown + 1])
                            let videoCount : Float = Float(self.mostPopularVideos.count)
                            
                            print(videoCount)
                            
                            let votes : Float = Float(snap.voteUp - snap.voteDown)
                            
                            print(votes)
                            
                            
                            self.videosRef.child(card.key).updateChildValues(["averageVote": votes])
                            
                            
                            self.count = 1
                        }
                        
                        
                        self.loadNextCard()
     
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                 self.loadNextCard()
            }
        }
       }
        
        if direction == .right {
            
            DispatchQueue.main.async {
                
                Answers.logCustomEvent(withName: "Swiped Right",
                                               customAttributes: [
                                                "amount": 1
                    ])
                
                self.ref = FIRDatabase.database().reference()
                
                let card = self.videos[index]
                
                let video = ["ActivityCategories": card.ActivityCategories,
                             "displayTitle": card.displayTitle,
                             "displayName": card.displayName,
                             "address": card.address,
                             "videoPath" : card.videoPath,
                             "imagePath": card.imagePath,
                             "latitude": String(card.lat),
                             "longitude": String(card.lng),
                             "createdAt": card.createdAt,
                             "show": "true"]
                
                let userId = FIRAuth.auth()?.currentUser?.uid
                let key = card.key
                
                self.ref?.child("profiles").child(userId!).child("picks").updateChildValues([key : video])
                self.ref?.child("profiles").child(userId!).child("swiped").updateChildValues([key : video])
       
                 self.loadBadgeNumber()
                
                self.videosRef.child(card.key).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let snap = FIRItem(snapshot: snapshot)
                    
                    
                    if self.count == 0 {
                        self.videosRef.child(card.key).updateChildValues(["swipedRight": snap.voteUp + 1])
                        let videoCount : Float = Float(self.mostPopularVideos.count)
                        
                        print(videoCount)
                        
                        let votes : Float = Float(snap.voteUp - snap.voteDown)
                        
                        print(votes)
                        
                        
                        self.videosRef.child(card.key).updateChildValues(["averageVote": votes])
                        
                        
                        self.count = 1
                    }
                    
                    
                     self.loadNextCard()
                    
                    
                    
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                self.loadNextCard()
            }
            
        }
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return false
    }
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {
        
        self.swiping = true
        
        print(finishPercentage)
        if (finishPercentage > 50 && direction == .left) {
            self.yesLabel?.isHidden = true
            self.noLabel?.isHidden = false
           
        }
        
        if(finishPercentage > 50 && direction == .right){
            self.noLabel?.isHidden = true
            self.yesLabel?.isHidden = false
           
        }
        
        if(finishPercentage < 50) {
            self.noLabel?.isHidden = true
            self.yesLabel?.isHidden = true
        }
        }
    
    
}

// MARK: KolodaViewDataSource
extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        self.noLabel?.isHidden = true
        self.yesLabel?.isHidden = true
        print(self.videos.count)
        return self.videos.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return DragSpeed.fast
    }
    

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    
        self.noLabel?.isHidden = true
        self.yesLabel?.isHidden = true
   
       self.setView = UIView(frame: self.cardView.frame)

      
  
            let video =  self.videos[index]
           
            self.setView.backgroundColor = UIColor.black
            let dateFormatter = DateFormatter()
            let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: self.setView.frame.width, height: self.setView.frame.height))
            overlayView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
            let DisplayTitle = UILabel(frame: CGRect(x: 10, y: 20, width: self.setView.frame.width, height: 40))
        
            let DisplayAddress = UILabel(frame: CGRect(x: 10, y: 30, width: self.setView.frame.width - 20, height: 40))
            let timeLabel = UILabel(frame: CGRect(x: 10, y: self.setView.frame.height - 40, width: self.setView.frame.width, height: 40))
        
            let distanceLabel = UILabel(frame: CGRect(x: 10, y: self.setView.frame.height - 60, width: self.setView.frame.width, height: 40))
        
            self.yesLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2 - 150) / 2, y: self.setView.frame.height / 2, width: 150, height: 40))
            self.noLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2 - 150) / 2, y: self.setView.frame.height / 2, width: 150, height: 40))
        
            if let yesLabel = self.yesLabel {
                yesLabel.textColor = UIColor.white
                yesLabel.font = UIFont(name: "HelveticaNeue", size: 40)
                yesLabel.textAlignment = NSTextAlignment.right
                yesLabel.text = "YES!"
            }
        
            if let noLabel = self.noLabel {
                noLabel.textColor = UIColor.white
                noLabel.font = UIFont(name: "HelveticaNeue", size: 40)
                noLabel.textAlignment = NSTextAlignment.right
                noLabel.text = "NO!"
            }
        
            timeLabel.textColor = UIColor.white
            timeLabel.font = UIFont(name: "System", size: 14)
        
            DisplayTitle.textColor = UIColor.white
            DisplayTitle.font = UIFont.systemFont(ofSize: 26.0)
            DisplayTitle.numberOfLines = 0
        
            
            DisplayAddress.textColor = UIColor.white
            DisplayAddress.font = UIFont(name: "System", size: 9)
            DisplayAddress.numberOfLines = 0
            
            distanceLabel.textColor = UIColor.white
            distanceLabel.font =  UIFont.boldSystemFont(ofSize: 16.0)
            distanceLabel.numberOfLines = 0
            
            let height = self.setView.frame.size.height
            let width = self.setView.frame.size.width
            
            
            SingletonData.staticInstance.setSelectedObject(nil)
            SingletonData.staticInstance.setVideoFrameWidth(width)
            SingletonData.staticInstance.setVideoFrameHeight(height)
            
        
            let origin = CGPoint.zero
            let size = CGSize(width: SingletonData.staticInstance.videoFrameWidth!, height: SingletonData.staticInstance.videoFrameHeight!)
       
            self.videoNode = ASVideoNode()
            self.videoNode.delegate = self
            self.videoNode.shouldAutorepeat = true
        
            self.videoNode.muted = false
            self.videoNode.frame = CGRect(origin: origin, size: size)
            self.videoNode.gravity = AVLayerVideoGravityResizeAspectFill
           // self.videoNode.zPosition = 0
            self.videoNode.shouldAutoplay = false
            //self.videoNode.layer.shouldRasterize = true
        
            self.videoNode.layer.borderColor = UIColor.clear.cgColor
        
           self.videoNode.assetURL = URL(string: "https://storage.googleapis.com/project-316688844667019748.appspot.com/" + video.videoPath)
    
             if(video.imagePath != ""){
               self.videoNode.url = URL(string: video.imagePath)
            }
         self.videoNode.shouldRenderProgressImages = true
        self.videoNode.shouldCacheImage = true
        
        SingletonData.staticInstance.setKey(video.key)
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
                    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                    let date = dateFormatter.date(from: video.createdAt)
        
                    if let dateItem = date {
                        timeLabel.text = SingletonData.staticInstance.timeAgoSinceDate(dateItem, numericDates: true)
                    }
                 
                    let coordinate₀ = SingletonData.staticInstance.location
                    let coordinate₁ = CLLocation(latitude: CLLocationDegrees(video.lat), longitude: CLLocationDegrees(video.lng))
                    
                    let distanceInMeters = coordinate₁.distance(from: coordinate₀!)
                    let distance : String = String(describing: round(Double((distanceInMeters) / 1000) / 1.6))
                    distanceLabel.text = distance + "mi"
                    DisplayTitle.text = video.displayTitle
                    DisplayAddress.text = video.address
        
                    self.setView.addSubnode(self.videoNode)
                    self.setView.addSubview(overlayView)
                    self.setView.addSubview(distanceLabel)
                    self.setView.addSubview(DisplayTitle)
                         self.setView.addSubview(DisplayAddress)
                    DisplayTitle.translatesAutoresizingMaskIntoConstraints = false
                    DisplayTitle.topAnchor.constraint(equalTo: self.setView.topAnchor, constant: 10).isActive = true
                    DisplayTitle.leadingAnchor.constraint(equalTo: self.setView.leadingAnchor, constant: 10).isActive = true
                    DisplayAddress.translatesAutoresizingMaskIntoConstraints = false
                    DisplayAddress.topAnchor.constraint(equalTo: self.setView.topAnchor, constant: 35).isActive = true
                    DisplayAddress.leadingAnchor.constraint(equalTo: self.setView.leadingAnchor, constant: 10).isActive = true
        DisplayAddress.trailingAnchor.constraint(equalTo: self.setView.trailingAnchor, constant: 20).isActive = true
                    distanceLabel.translatesAutoresizingMaskIntoConstraints = false
                    distanceLabel.bottomAnchor.constraint(equalTo: self.setView.bottomAnchor, constant: -15).isActive = true
                    distanceLabel.leadingAnchor.constraint(equalTo: self.setView.leadingAnchor, constant: 10).isActive = true
                    
                    if let yesLabel = self.yesLabel {
                        self.setView.addSubview(yesLabel)
                        yesLabel.isHidden = true
                    }
        
                    if let noLabel = self.noLabel {
                        self.setView.addSubview(noLabel)
                        noLabel.isHidden = true
                    }
        
            self.setView.layer.cornerRadius = 10
                    self.setView.layer.masksToBounds = true
        
                   // self.setView.layer.shadowColor = UIColor.black.cgColor
                 //   self.setView.layer.shadowOpacity = 1
                //    self.setView.layer.shadowOffset = CGSize.zero
                //    self.setView.layer.shadowRadius = 10
                //    self.setView.layer.shadowPath = UIBezierPath(rect: self.setView.bounds).cgPath
                  //  self.setView.layer.shouldRasterize = true

      
         return self.setView
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
 
        SingletonData.staticInstance.setMapLocation(location)

        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "mapStoryboardSegue", sender: self)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}







