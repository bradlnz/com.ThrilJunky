
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

class ViewController: UIViewController, FIRDatabaseReferenceable, ASVideoNodeDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let geocoder = CLGeocoder()
    var asyncVideoController = AsyncVideoViewController()
    var playerViewController = PlayerViewController()
    let overlayHintController = OverlayHintController()
    let overlayViewContent = OverlayViewContent()
   // var locationSearchViewController : LocationSearchViewController?
    
    //var pageMenu : CAPSPageMenu?
    var reachability : Reachability? = nil
    var player = AVPlayer()
    var playerItem : AVPlayerItem?
    var ref: FIRDatabaseReference?
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
    @IBOutlet weak var filteredBtn: UIButton!
    @IBOutlet weak var place: UILabel!
    
    @IBOutlet weak var catCollectionView: UICollectionView!
    
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

 //   @IBOutlet weak var filterViewBg: UIView!

    @IBOutlet weak var whatsHappeningLabel: UILabel!
    @IBOutlet weak var menu: UIView!
  
  
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var filterBtn: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var yourPicksBtn: MIBadgeButton!
    
    @IBOutlet weak var toggleMap: UIButton!
    
    
    @IBOutlet weak var cardView: KolodaView!
//    @IBOutlet weak var followingVideos: UICollectionView!
    
    
 

    
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
    var canvasView : CanvasView?
    
    
    @IBAction func searchLocation(_ sender: Any) {
//        SingletonData.staticInstance.setIsPostVideo(false)
//        let popup : LocationSearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "LocationSearchViewController") as! LocationSearchViewController
//
//       // popup.delegateBg = self
//        let navigationController = UINavigationController(rootViewController: popup)
//
//        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        self.present(navigationController, animated: false, completion: nil)
//
       // self.videos.removeAll()
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Set a filter to return only addresses.
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.region
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    
    

//    func changeLocation(){
//        DispatchQueue.main.async {
//        self.bg.isHidden = true
//        //   self.place.isHidden = true
//        //    self.whatsHappeningLabel.isHidden = true
//        self.cardView.isHidden = true
//        self.catCollectionView.isHidden = true
//
//        var region = MKCoordinateRegion()
//        region.center = SingletonData.staticInstance.overrideLocation!.coordinate
//        var span = MKCoordinateSpan()
//        span.latitudeDelta = 0.05
//        span.longitudeDelta = 0.05
//        region.span = span
//        self.mapView.setRegion(region, animated: true)
//        }
//    }
    
    @IBOutlet weak var drawPolygonButton: UIButton!
    var isDrawingPolygon: Bool = false

    @IBAction func didTouchUp(insideDraw sender: UIButton) {
        
//        if self.cardView.isHidden == false {
//            self.bg.isHidden = true
//            //   self.place.isHidden = true
//            //    self.whatsHappeningLabel.isHidden = true
//            self.cardView.isHidden = true
//            self.catCollectionView.isHidden = true
//        }
//        if isDrawingPolygon == false {
//            isDrawingPolygon = true
//            drawPolygonButton.setTitle("done", for: .normal)
//            coordinates.removeAll()
//            mapView.isUserInteractionEnabled = false
//        }
//        else {
//            let numberOfPoints: Int = coordinates.count
//
//            var maxLat: Float = -200
//            var maxLong: Float = -200
//            var minLat: Float = MAXFLOAT
//            var minLong: Float = MAXFLOAT
//            for i in 0..<coordinates.count {
//                let location: CLLocationCoordinate2D = coordinates[i]
//                if Float(location.latitude) < minLat {
//                    minLat = Float(location.latitude)
//                }
//                if Float(location.longitude) < minLong {
//                    minLong = Float(location.longitude)
//                }
//                if Float(location.latitude) > maxLat {
//                    maxLat = Float(location.latitude)
//                }
//                if Float(location.longitude) > maxLong {
//                    //Change to be greater than
//                    maxLong = Float(location.longitude)
//                }
//            }
//            //Center point
//            //The min's and max's should be ADDED not subtracted
//            let a = (maxLat + minLat) * 0.5
//            let b = (maxLong + minLong) * 0.5
//            let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(a), Double(b))
//            let area = regionArea(locations: coordinates) / 10000
//
//            if area > 0 {
//             SingletonData.staticInstance.setDistance(Float(area))
//             SingletonData.staticInstance.setOverrideDistance(input: true)
//             self.cardView.reloadData()
//            }
//
//            if self.cardView.isHidden == true
//            {
//
//                if (center.latitude > -180.0 && center.longitude < 180.0)
//                {
//                    self.loadClosestVideos(loc: CLLocation(latitude: center.latitude, longitude: center.longitude))
//                     self.loadNextCard()
//                }
//
//                self.bg.isHidden = false
//                self.cardView.isHidden = false
//                self.catCollectionView.isHidden = false
//            } else {
//                self.noMoreTitle.isHidden = true
//                self.expandRadius.isHidden = true
//                self.refreshBtn.isHidden = true
//
//                self.bg.isHidden = true
//
//                self.cardView.isHidden = true
//                self.catCollectionView.isHidden = true
//            }
//
//            if numberOfPoints > 2 {
//                 points = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2D(), count: numberOfPoints)
//                for i in 0..<numberOfPoints {
//                    points[i] = coordinates[i]
//                }
//                mapView.add(MKPolygon(coordinates: points, count: numberOfPoints))
//            }
//            if polyLine != nil {
//                mapView.remove(polyLine!)
//            }
//            mapView.removeOverlays(mapView.overlays)
//            isDrawingPolygon = false
//            drawPolygonButton.setTitle("draw", for: .normal)
//            mapView.isUserInteractionEnabled = true
//        }
    }
    let kEarthRadius = 6378137.0
    
    
//    func pointIsInside(point: MKMapPoint, polygon: MKPolygon) -> Bool {
//        let mapRect = MKMapRectMake(point.x, point.y, 0.0001, 0.0001)
//        return polygon.intersects(mapRect)
//    }
//
//    // CLLocationCoordinate2D uses degrees but we need radians
//    func radians(degrees: Double) -> Double {
//        return degrees * M_PI / 180
//    }
//
//    func regionArea(locations: [CLLocationCoordinate2D]) -> Double {
//
//        guard locations.count > 2 else { return 0 }
//        var area = 0.0
//
//        for i in 0..<locations.count {
//            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
//            let p2 = locations[i]
//
//            area += radians(degrees: p2.longitude - p1.longitude) * (2 + sin(radians(degrees: p1.latitude)) + sin(radians(degrees: p2.latitude)) )
//        }
//
//        area = -(area * kEarthRadius * kEarthRadius / 2)
//
//        return max(area, -area) // In order not to worry about is polygon clockwise or counterclockwise defined.
//    }
//
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        touchesBegan(touches.first!)
//    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        touchesMoved(touches.first!)
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        touchesEnded(touches.first!)
//    }
//
//
//      func touchesBegan(_ touch: UITouch) {
//        if isDrawingPolygon == false {
//            return
//        }
//        let location: CGPoint? = touch.location(in: mapView)
//        let coordinate: CLLocationCoordinate2D = mapView.convert(location!, toCoordinateFrom: mapView)
//        addCoordinate(coordinate)
//    }
//
//     func touchesMoved(_ touch: UITouch) {
//        if isDrawingPolygon == false {
//            return
//        }
//
//        let location: CGPoint? = touch.location(in: mapView)
//        let coordinate: CLLocationCoordinate2D = mapView.convert(location!, toCoordinateFrom: mapView)
//        addCoordinate(coordinate)
//    }
//
//      func touchesEnded(_ touch: UITouch) {
//        if isDrawingPolygon == false {
//            return
//        }
//
//        let location: CGPoint? = touch.location(in: mapView)
//        let coordinate: CLLocationCoordinate2D = mapView.convert(location!, toCoordinateFrom: mapView)
//        addCoordinate(coordinate)
//
//
//        didTouchUp(insideDraw: drawPolygonButton)
//    }
//
//
//    func addCoordinate(_ coordinate: CLLocationCoordinate2D) {
//        coordinates.append(coordinate)
//        let numberOfPoints: Int = coordinates.count
//        if numberOfPoints > 2 {
//            let oldPolyLine: MKPolyline? = polyLine
//            var points = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2D(), count: numberOfPoints)
//            for i in 0..<numberOfPoints {
//                points[i] = coordinates[i]
//            }
//            let newPolyLine = MKPolyline(coordinates: points, count: numberOfPoints)
//            mapView.add(newPolyLine)
//            polyLine = newPolyLine
//            if oldPolyLine != nil {
//                mapView.remove(oldPolyLine!)
//            }
//        }
//    }
    
    func reportVideo(_ item : RealmObject) {
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
    
    func noMoreCardsToLoad() {
        self.noMoreTitle.isHidden = false
        self.expandRadius.isHidden = false
        self.refreshBtn.isHidden = false
      //  HUD.hide()
    }
    
    func reloadCards(input: Bool) {
        
      
    //    self.bg.isHidden = false
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
       // self.closestVideos.removeAll()
      //  SingletonData.staticInstance.overrideCloseObject()
//        for item in self.cardView.subviews{
//            item.removeFromSuperview()
//        }
//        
        
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
    
    
    override func viewDidAppear(_ animated: Bool) {
//        var selectedMapItem = SingletonData.staticInstance.selectedMapItem
//        
//        var annotations = self.cluster as! [PinAnnotation]
//        var ann : PinAnnotation?
//        
//        
//        if(selectedMapItem != nil){
//            if let i = annotations.index(where: { $0.title?.range(of: selectedMapItem!.name!) != nil || $0.address?.range(of: selectedMapItem!.address!) != nil }) {
//                
//                DispatchQueue.main.async {
//                    ann = annotations[i];
//                    
//                    self.mapView.selectAnnotation(ann!, animated: true)
//                }
//                
//            }
//            
//        }
    }
    
    @objc func thumbsDownButtonPressed(){
        self.cardView!.swipe(.left)
    }
    @objc func thumbsUpButtonPressed(){
        self.cardView!.swipe(.right)
    }
    override func viewDidLoad() {
        load()
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 210, y: self.view.bounds.height - 90, width: 80, height: 80)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.backgroundColor = UIColor.white
        button.clipsToBounds = true
        button.tintColor = UIColor.green
        button.setImage(UIImage(named:"pin"), for: .normal)
        button.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        view.addSubview(button)
        
        
        let buttonDown = UIButton(type: .custom)
        buttonDown.frame = CGRect(x: 100, y: self.view.bounds.height - 90, width: 80, height: 80)
        buttonDown.layer.cornerRadius = 0.5 * button.bounds.size.width
        buttonDown.backgroundColor = UIColor.white
        buttonDown.clipsToBounds = true
        buttonDown.tintColor = UIColor.red
        buttonDown.setImage(UIImage(named:"cancel"), for: .normal)
        buttonDown.addTarget(self, action: #selector(thumbsDownButtonPressed), for: .touchUpInside)
        view.addSubview(buttonDown)
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
//        var bounds = self.navigationController?.navigationBar.bounds as CGRect!
//        bounds!.offsetBy(dx: 0.0, dy: -20.0)
//        bounds!.size.height = bounds!.height
//
//        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//        visualEffectView.frame = bounds!
//        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.navigationController?.navigationBar.addSubview(visualEffectView)
//        
      
        //let logo = UIImage(named: "textNavBar")
        //let imageView = UIImageView(image:logo)
       // self.navigationItem.titleView = imageView
        let popup : IntroController = self.storyboard?.instantiateViewController(withIdentifier: "IntroController") as! IntroController
        let navigationController = UINavigationController(rootViewController: popup)
        
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
        
        isDrawingPolygon = false
        //drawPolygonButton.setTitle("draw", for: .normal)
      //  mapView.isUserInteractionEnabled = true
        self.refreshBtn.isHidden = true
        self.expandRadius.isHidden = true
        self.noMoreTitle.isHidden = true
        self.cardView.dataSource = self
        self.cardView.delegate = self
      
       // locationSearchViewController?.delegateBg = self
        
        
        
        self.cardView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 450)
        
        self.cardView.countOfVisibleCards = 1
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
//        // since I can connect from multiple devices, we store each connection instance separately
//        // any time that connectionsRef's value is null (i.e. has no children) I am offline
//        let myConnectionsRef = FIRDatabase.database().reference(withPath: "users/" + user!.displayName! + "/connections")
//        
//        // stores the timestamp of my last disconnect (the last time I was seen online)
//        let lastOnlineRef = FIRDatabase.database().reference(withPath: "users/" + user!.displayName! + "/lastOnline")
//        
//        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
//        
//        connectedRef.observe(.value, with: { snapshot in
//            // only handle connection established (or I've reconnected after a loss of connection)
//            guard let connected = snapshot.value as? Bool, connected else {
//                return
//            }
//            // add this device to my connections list
//            // this value could contain info about the device or a timestamp instead of just true
//            let con = myConnectionsRef.childByAutoId()
//            con.setValue("YES")
//            
//            // when this device disconnects, remove it
//            con.onDisconnectRemoveValue()
//            
//            // when I disconnect, update the last time I was seen online
//            lastOnlineRef.onDisconnectSetValue(FIRServerValue.timestamp())
//        })
//        
//        let remoteConfig = FIRRemoteConfig.remoteConfig()
//        
//        
//        let alertController = UIAlertController(title: "How to begin?", message: "Swipe left for NO! and right for YES! otherwise tap the map icon below to scroll around.", preferredStyle: .alert)
//        
//        // Initialize Actions
//        let  okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
//            print("The user is okay.")
//            
//        }
//        alertController.addAction(okAction)
//        
//        
//        // Present Alert Controller
//        self.present(alertController, animated: true, completion: nil)
//        
//        
 
        
        
//        remoteConfig.fetch(withExpirationDuration: 0, completionHandler: { (status, error) in
//            
//            print(status)
//            remoteConfig.activateFetched()
//            
//            var json : NSArray!
//            do {
//                
//                json = try JSONSerialization.jsonObject(with: remoteConfig.configValue(forKey: "Categories").dataValue, options: JSONSerialization.ReadingOptions()) as? NSArray
//            } catch {
//                print(error)
//            }
//            
//            
//            var arr : [[String:Any]] = []
//            
//            
//            for (key, value) in json.enumerated() {
//                let obj = json[key] as! [String:Any]
//                arr.append(obj)
//            }
//            
//            SingletonData.staticInstance.setActivities(input: arr)
//        })
//        
        
     
        self.catCollectionView.isHidden = false
     //   self.filterViewBg.isHidden = true
        self.catCollectionView.delegate = self
        self.catCollectionView.dataSource = self
        
        
        let loc = SingletonData.staticInstance.location
        
        
        //        SingletonData.staticInstance.closestVideo.sort(by: { (item1: FIRItem, item2: FIRItem) -> Bool in
        //            item1.distanceFromLoc > item2.distanceFromLoc
        //        })
        
       // self.mapView.delegate = self
       // self.mapView.mapType = .standard
        
        self.ref = FIRDatabase.database().reference()
        
        // UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
//        OperationQueue().addOperation({
//            let mapBoundsWidth = Double(self.mapView.bounds.size.width)
//            let mapRectWidth:Double = self.mapView.visibleMapRect.size.width
//            let scale:Double = mapBoundsWidth / mapRectWidth
//
//            var annotationArray : [MKAnnotation]? = nil
//
//
//            annotationArray = self.clusteringManager?.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
//
//
//            self.clusteringManager?.displayAnnotations(annotationArray!, onMapView:self.mapView)
//        })
        
        
        
        
        if loc != nil {
            
            if videos.count <= 0 {
                
                
                
                self.videosRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                  //  self.videos.removeAll()
               // self.cluster.removeAll()
              //      var allAnnotations = self.clusteringManager?.allAnnotations()
                
                   // self.mapView.removeAnnotations(allAnnotations!)
                    
                    for snap in snapshot.children{
                        let item = FIRItem(snapshot: snap as! FIRDataSnapshot)
                        
                        if(item.videoPath != ""){
                           
                          //  let pinAnnotation = PinAnnotation()
                            
                            self.ref.child("businesses").queryOrdered(byChild: "uid").queryEqual(toValue: item.uid).observe(.value, with: { (snap) in
                                // Get user value
                                
                                let lat : Double!
                                let lng : Double!
                                
                                
                                for var vid in snap.children {
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
                                        
                                        
                                        realm.add(obj)
                                    }
                                }
                                
                                self.loadClosestVideos(loc: SingletonData.staticInstance.location)
                                self.loadNextCard()
                                
                            }) { (error) in
                                print(error.localizedDescription)
                            }
                            
                            
                            
                            
                          //  self.cluster.append(pinAnnotation)
                           /// allAnnotations!.append(pinAnnotation)
                            
                        }
                        
                       
                        
                    }
             //       self.clusteringManager?.setAnnotations(self.cluster)
               //     self.clusteringManager?.displayAnnotations(allAnnotations!, onMapView:self.mapView)
                    
                    
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
        
        
       // HUD.show(.progress)
        print(self.videos)
          //  self.whatsHappeningLabel.isHidden = false
         //   self.bg.isHidden = false
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
           // HUD.hide()
        } else {
           // self.videos.removeAll()
            
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

    //    HUD.hide()
  
        self.catCollectionView.isHidden = false
        //self.filterViewBg.isHidden = true
    
        
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
            
            let results2 = try! self.realm
                .findNearby(type: RealmObject.self, origin: loc!.coordinate, radius: 50000, sortAscending: true)
                .removeDuplicates()
        
       
            for item in results2 {
                
                SingletonData.staticInstance.appendObject(item)
                self.videos.append(item)
            }
    }

    
    func loadNextCard()
    {
   
        self.cardView.reloadData()
    }
    

 override func viewWillAppear(_ animated: Bool) {
    
     UIApplication.shared.isStatusBarHidden = false
    // Hide the navigation bar on the this view controller
   // self.navigationController?.setNavigationBarHidden(true, animated: animated)
    // Transparent navigation bar
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.tintColor = UIColor.black
    
    UIApplication.shared.statusBarStyle = .default
    
    DispatchQueue.main.async {
        var loc : CLLocation?
        
        
    self.realm = try! Realm()
        
    
    self.yourPicksBtn.badgeString = String(0)
    self.loadBadgeNumber()
    
   
    if(SingletonData.staticInstance.overrideLocation != nil){
        loc = SingletonData.staticInstance.overrideLocation
    } else {
        loc = SingletonData.staticInstance.location
    }
    

    self.loadClosestVideos(loc: loc)
    
    if loc != nil {
        let latitude:CLLocationDegrees =  loc!.coordinate.latitude//insert latitutde
        
        let longitude:CLLocationDegrees = loc!.coordinate.longitude//insert longitude
        
        
        let delta = 50 / 69.0
        
        let latDelta:CLLocationDegrees = delta
        
        let lonDelta:CLLocationDegrees = delta
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.015, 0.015)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        if(SingletonData.staticInstance.initLoad == true){
            
        
         //   self.mapView.setRegion(region, animated: false)
            self.initLoad = false
            SingletonData.staticInstance.setInitLoad(input: false)
            

           // SingletonData.staticInstance.setOverrideLocation(nil)
        }
        }
    

    
    if(SingletonData.staticInstance.title != nil){
    //self.title = SingletonData.staticInstance.title
         self.whatsHappeningLabel.text = "What's happening around"
        self.place.text = SingletonData.staticInstance.title! + "?"
         self.place.textAlignment = .center
    } else {
//        let geoCoder = CLGeocoder()
//        let location = CLLocation(latitude: loc!.coordinate.latitude, longitude: loc!.coordinate.longitude)
//        
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//            
//            // Place details
//            var placeMark: CLPlacemark!
//            placeMark = placemarks?[0]
//            
//            if placeMark != nil {
//            // City
//            if let city = placeMark.addressDictionary!["City"] as? NSString {
//                
//                if(city != ""){
//               //     self.title = (city as String)
//                   //self.whatsHappeningLabel.text = "What's happening around"
//                 //   self.place.text = (city as String) + "?"
//                  //   self.place.textAlignment = .center
//                } else {
//                    
//                }
//                
//            }
//            }
//        })
    }
        }
}
    
    override func viewWillDisappear(_ animated: Bool) {
      //  UIApplication.shared.isStatusBarHidden = false
      //  self.closestVideos.removeAll()
        //SingletonData.staticInstance.overrideCloseObject()
//        for item in self.cardView.subviews{
//            item.removeFromSuperview()
//        }
      //  self.videoNode.recursivelyClearContents()
      //  self.videoNode.removeFromSupernode()
        
    //    SingletonData.staticInstance.setTitle(nil)
//        self.catCollectionView.delegate = nil
//        self.catCollectionView.dataSource = nil
//        self.cardView.dataSource = nil
//        self.cardView.delegate = nil
    }
    

    @IBAction func toggleMap(_ sender: AnyObject) {
//        
//        if self.cardView.isHidden == true
//        {
//        
//            if(SingletonData.staticInstance.overrideLocation != nil){
//                loadContent(loc: SingletonData.staticInstance.overrideLocation)
//                self.loadClosestVideos(loc: SingletonData.staticInstance.overrideLocation)
//                self.loadNextCard()
//            } else {
//                  loadContent(loc: SingletonData.staticInstance.location)
//                            self.loadClosestVideos(loc: SingletonData.staticInstance.location)
//                self.loadNextCard()
//            }
////
//           // self.whatsHappeningLabel.isHidden = false
//               // self.place.isHidden = false
//              //  self.bg.isHidden = false
//                self.cardView.isHidden = false
//                 self.catCollectionView.isHidden = false
//
//        //    self.mapView.removeFromSuperview()
//           // self.filterViewBg.isUserInteractionEnabled = true
//        } else {
//            
//        
//          //  self.videoNode.pause()
//         //   self.videoNode.removeFromSupernode()
//            
//            self.noMoreTitle.isHidden = true
//            self.expandRadius.isHidden = true
//            self.refreshBtn.isHidden = true
//            
//          //  self.closestVideos.removeAll()
//           // SingletonData.staticInstance.overrideCloseObject()
////            for item in self.cardView.subviews{
////                item.removeFromSuperview()
////            }
//
//           // self.filterViewBg.isUserInteractionEnabled = false
//            //self.bg.isHidden = true
//         //   self.place.isHidden = true
//        //    self.whatsHappeningLabel.isHidden = true
//            self.cardView.isHidden = true
//            self.catCollectionView.isHidden = true
//            self.loadNextCard()
//        }
    }
    
    
       
      
    
    func buttonClicked(){
        DispatchQueue.main.async {
    
            DispatchQueue.main.async {
//                self.present(self.asyncVideoController, animated: true) { () -> Void in
//                }
                
                self.performSegue(withIdentifier: "moreInfoSegue", sender: self)
            }
        }
    }
    
   
//    func addRadiusCircle(location: CLLocation){
//
//            let circle = MKCircle(center: location.coordinate, radius: 10 as CLLocationDistance)
//          //  self.mapView.add(circle)
//
//    }
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//
//        if (overlay is MKPolygon) {
//            let pr = MKPolygonRenderer(overlay: overlay);
//            pr.strokeColor = UIColor.blue.withAlphaComponent(0.5);
//            pr.lineWidth = 5;
//            return pr;
//        } else if (overlay is MKPolyline) {
//            var pr = MKPolylineRenderer(overlay: overlay);
//            pr.strokeColor = UIColor.blue.withAlphaComponent(0.5);
//            pr.lineWidth = 5;
//            return pr;
//        }
//
//        if overlay is MKCircle {
//            let circle = MKCircleRenderer(overlay: overlay)
//            circle.strokeColor = UIColor.red
//            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
//            circle.lineWidth = 1
//            return circle
//        } else {
//            return MKPolylineRenderer()
//        }
//    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//
//        var reuseId = ""
//        if annotation.isKind(of: FBAnnotationCluster.self) {
//            reuseId = "Cluster"
//            var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
//            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)
//
//
//            return clusterView
//        } else {
//
//            reuseId = "Pin"
//            if annotation is PinAnnotation {
//
//                var ann = annotation as! PinAnnotation
//                var pinAnnotationView = MKAnnotationView(annotation: ann, reuseIdentifier: reuseId)
//
//                pinAnnotationView.isDraggable = false
//                pinAnnotationView.canShowCallout = true
//                pinAnnotationView.calloutOffset = CGPoint(x: 0, y: 10)
//                    DispatchQueue.main.async {
//                var imageView : UIImageView! = UIImageView()
//
//
//
//                if imageView.image == nil {
//
//                    imageView.image = UIImage.size(width: 20, height: 20)
//                        .color(UIColor.red)
//                        .border(color: UIColor.white)
//                        .border(width: 2)
//                        .corner(radius: 10)
//                        .image
//                }
//
//
//
//                    var size = CGSize(width: 50, height: 50)
//                var resizedAndMaskedImage = self.imageResize(imageView.image!, sizeChange: size)
//                pinAnnotationView.image = resizedAndMaskedImage
//
//                }
//
//                 let button = UIButton(type: UIButtonType.detailDisclosure)
//                 button.addTarget(self, action: #selector(ViewController.buttonClicked), for: UIControlEvents.touchUpInside)
//                 pinAnnotationView.rightCalloutAccessoryView = button
//
//
//              return pinAnnotationView
//
//
//            }
//        }
//
//
//
//        return nil
//    }
    
    
//
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//
//       // self.addRadiusCircle(location: SingletonData.staticInstance.location!)
//
//        if(view.annotation is MKUserLocation)
//        {
//
//
//        } else {
//
//            if view.annotation!.isKind(of: FBAnnotationCluster.self) {
//
//                for item in self.cluster {
//                    print(item)
//                }
//
//                 self.clusteringManager?.displayAnnotations(self.cluster, onMapView:self.mapView)
//
//            } else
//            {
//                let ann = view.annotation as! PinAnnotation
//                SingletonData.staticInstance.setVideoPlayed(nil)
//                SingletonData.staticInstance.setSelectedVideoItem(nil)
//                SingletonData.staticInstance.setSelectedObject(nil)
//                SingletonData.staticInstance.setSelectedAnnotation(nil)
//                SingletonData.staticInstance.setSelectedAnnotation(ann)
//
//                let imageURL = URL(string: ann.imagePath!)
//                SingletonData.staticInstance.setVideoImage(imageURL)
//             //   SingletonData.staticInstance.setSelectedVideoItem("https://1096606134.rsc.cdn77.org/" + ann.videoPath!)
//                SingletonData.staticInstance.setSelectedVideoItem("https://project-316688844667019748.appspot.com.storage.googleapis.com/" + ann.videoPath!)
//
//            }
//        }
//    }
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//
//
//        DispatchQueue.global(qos: .background).async {
//
//                let mapBoundsWidth = Double(self.mapView.bounds.size.width)
//                let mapRectWidth:Double = self.mapView.visibleMapRect.size.width
//                let scale:Double = mapBoundsWidth / mapRectWidth
//
//                var annotationArray : [MKAnnotation]? = nil
//
//
//                annotationArray = self.clusteringManager?.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
//
//
//                self.clusteringManager?.displayAnnotations(annotationArray!, onMapView:self.mapView)
//
//        }
//
//
//        }
//
    func removeNastyMapMemory() {
//        print (" ********* MapVC \(#function) ********** ")
//
//        if self.mapView != nil {
//            switch mapView.mapType {
//            case .hybrid :
//                print (" mapType = MKMapType.standard")
//                self.mapView.mapType = MKMapType.standard
//            case .standard:
//                print (" mapType = MKMapType.hybrid")
//                self.mapView.mapType = MKMapType.hybrid
//            default:
//                print (" mapType = ???")
//                break
//            }
//
//            print (" showsUserLocation = false")
//            self.mapView.showsUserLocation = false
//
//            if self.mapView.delegate != nil {
//                print (" mapView.delegate = nil")
//                self.mapView.delegate = nil
//            }
//
//            print (" mapView = nil")
//            self.mapView.removeFromSuperview()
//            self.mapView = nil
//        }
//        DispatchQueue.main.async {
//
//
//    self.reachability = Reachability()!
//
//    self.reachability!.whenReachable = { reachability in
//            // this is called on a background thread, but UI updates must
//            // be on the main thread, like this:
//            DispatchQueue.main.async {
//                if reachability.isReachableViaWiFi {
//                    print("Reachable via WiFi")
//                    OperationQueue().addOperation({
//                        let mapBoundsWidth = Double(self.mapView.bounds.size.width)
//                        let mapRectWidth:Double = self.mapView.visibleMapRect.size.width
//                        let scale:Double = mapBoundsWidth / mapRectWidth
//                        
//                        var annotationArray : [MKAnnotation]? = nil
//                        
//                        
//                        annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
//                        
//                        
//                        self.clusteringManager.displayAnnotations(annotationArray!, onMapView:self.mapView)
//                    })
//                } else {
//                    print("Reachable via Cellular")
//                    OperationQueue().addOperation({
//                        let mapBoundsWidth = Double(self.mapView.bounds.size.width)
//                        let mapRectWidth:Double = self.mapView.visibleMapRect.size.width
//                        let scale:Double = mapBoundsWidth / mapRectWidth
//                        
//                        var annotationArray : [MKAnnotation]? = nil
//                        
//                        
//                        annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
//                        
//                        
//                        self.clusteringManager.displayAnnotations(annotationArray!, onMapView:self.mapView)
//                    })
//                }
//            }
//        }
//        self.reachability!.whenUnreachable = { reachability in
//            // this is called on a background thread, but UI updates must
//            // be on the main thread, like this:
//            DispatchQueue.main.async {
//                print("Not reachable")
//                if self.cluster.count > 0 {
//                    self.cluster.removeAll()
//                    self.mapView.removeAnnotations(self.cluster)
//                    print(self.cluster)
//                    self.clusteringManager.displayAnnotations(self.cluster, onMapView: self.mapView)
//                }
//            }
//        }
//        
//        do {
//            try self.reachability!.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
//         }
    }
    
    func ResizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
 
    
   
    
    func imageResize (_ image: UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
    
    
 
    @IBAction func loadFilterModal(_ sender: Any) {
        if(self.catCollectionView.isHidden == false){
            self.catCollectionView.isHidden = true
            //self.filterViewBg.isHidden = true
        } else {
            self.catCollectionView.isHidden = false
           // self.filterViewBg.isHidden = false
        }
    }
        
    
       
    @IBAction func shareVideo(_ sender: AnyObject) {
      //   SingletonData.staticInstance.setIsPostVideo(true)
      //  SingletonData.staticInstance.setMapRegion(input: self.mapView.region)
        
      //  let popup : ModalController = self.storyboard?.instantiateViewController(withIdentifier: "ModalController") as! ModalController
       // let navigationController = UINavigationController(rootViewController: popup)
    
     //   popup.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
     //   self.present(popup, animated: false, completion: nil)
        
//        self.closestVideos.removeAll()
//        SingletonData.staticInstance.overrideCloseObject()
//        for item in self.cardView.subviews{
//            item.removeFromSuperview()
//        }
//        
//        self.cardView.isHidden = false
//        
//      DispatchQueue.main.async{
//        let viewController = UIStoryboard(name: "Post", bundle: nil).instantiateViewController(withIdentifier: "Share") as! CameraViewController
//        
//        viewController.delegate = self
//        
//       
//        viewController.modalPresentationStyle = .overCurrentContext
//        self.slideMenuController()?.present(viewController, animated: true, completion: nil)
//        }
    }
    
    func closeModal(_ sender: UIButton!){
        self.blurEffectView?.isHidden = true
        
    }
    
    
    @IBAction func shareSheet(_ sender: AnyObject) {
        
        let firstActivityItem = "Text you want"
        let secondActivityItem : URL = URL(string: "http//:urlyouwant")!
        // If you want to put an image
        //let image : UIImage = UIImage(named: "image.jpg")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func openPicks(_ sender: AnyObject) {
      //  self.closestVideos.removeAll()
     //   SingletonData.staticInstance.overrideCloseObject()
//        for item in self.cardView.subviews{
//            item.removeFromSuperview()
//        }
        
              DispatchQueue.main.async{
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YourPicks")
   //     viewController.modalPresentationStyle = .OverCurrentContext
        self.present(viewController, animated: true, completion: nil)
        }
    }
    

    
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
    
    
    
    @IBAction func openProfile(_ sender: AnyObject) {
       // self.closestVideos.removeAll()
        //SingletonData.staticInstance.overrideCloseObject()
        for item in self.cardView.subviews{
            item.removeFromSuperview()
        }
        
              DispatchQueue.main.async{
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfile")
     //   viewController.modalPresentationStyle = .OverCurrentContext
        self.present(viewController, animated: true, completion: nil)
        }
    }
    

    func loadFilterModal(){
        
        // Blur Effect
        self.blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurEffectView!.frame = self.view.bounds
        self.view.addSubview(blurEffectView!)
        
        // Vibrancy Effect
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = self.view.bounds
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! FilterCollectionView
        
     //   cell.backgroundColor = UIColor.groupTableViewBackground
        cell.textLbl.text = self.categories[indexPath.row]
    
         cell.textLbl.textColor = UIColor.black
       // cell.backgroundColor = getRandomColor()
 
       // cell.imgView.image = self.images[indexPath.row]
        return cell
            
      
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        do {
            var cell =  collectionView.cellForItem(at: indexPath)
        
     //   cell?.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
     var cell = collectionView.cellForItem(at: indexPath) as! FilterCollectionView
        
   //     cell.backgroundColor = UIColor.lightGray

        
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
    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }

    func videoNodeDidStartInitialLoading(_ videoNode: ASVideoNode) {
        
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
        let position = self.cardView.currentCardIndex
      
        self.noMoreTitle.isHidden = false
        self.expandRadius.isHidden = false
        self.refreshBtn.isHidden = false
           }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
  
        SingletonData.staticInstance.setSelectedObject(self.videos[index])
       // self.performSegue(withIdentifier: "moreInfoSegue", sender: self)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : MoreInfoController = storyboard.instantiateViewController(withIdentifier: "MoreInfoController") as! MoreInfoController
       self.navigationController?.pushViewController(vc, animated: true)
    }
   
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection)
    {
        
        self.swiping = false
        
        if direction == .left {
           
            
            DispatchQueue.main.async {
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
                let key = card.key //self.ref?.child("profiles").child(userId!).child("picks").childByAutoId().key
                
                
                self.ref?.child("profiles").child(userId!).child("swiped").updateChildValues([key : video])
                
                
               // self.cardView.resetCurrentCardIndex()
                
                self.loadBadgeNumber()
                
                
                    self.videosRef.child(card.key).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        var snap = FIRItem(snapshot: snapshot)
                        
                        
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
                let key = card.key //self.ref?.child("profiles").child(userId!).child("picks").childByAutoId().key
                
               
                self.ref?.child("profiles").child(userId!).child("picks").updateChildValues([key : video])
                self.ref?.child("profiles").child(userId!).child("swiped").updateChildValues([key : video])
             //  self.cardView.resetCurrentCardIndex()
         
                 self.loadBadgeNumber()
                
                self.videosRef.child(card.key).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    var snap = FIRItem(snapshot: snapshot)
                    
                    
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
    
    
    
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
//    }
    
  
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    
        
        self.noLabel?.isHidden = true
        self.yesLabel?.isHidden = true
   
       setView = UIView(frame: self.cardView.frame)

      
  
            let video =  self.videos[index]
           
            setView.backgroundColor = UIColor.black
            let dateFormatter = DateFormatter()
            let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: setView.frame.width, height: setView.frame.height))
            overlayView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
            let DisplayTitle = UILabel(frame: CGRect(x: 10, y: 20, width: setView.frame.width, height: 40))
            let DisplayAddress = UILabel(frame: CGRect(x: 10, y: 50, width: setView.frame.width, height: 40))
            let timeLabel = UILabel(frame: CGRect(x: 10, y: setView.frame.height - 40, width: setView.frame.width, height: 40))
        
            let distanceLabel = UILabel(frame: CGRect(x: 10, y: setView.frame.height - 60, width: setView.frame.width, height: 40))
        
            self.yesLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2 - 150) / 2, y: setView.frame.height / 2, width: 150, height: 40))
            self.noLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2 - 150) / 2, y: setView.frame.height / 2, width: 150, height: 40))
            
            self.yesLabel!.textColor = UIColor.white//setView.UIColorFromRGB(0xFFFFFF)
            
            self.yesLabel!.font = UIFont(name: "HelveticaNeue", size: 40)
            self.yesLabel!.textAlignment = NSTextAlignment.right
            self.yesLabel!.text = "YES!"
        
            self.noLabel!.textColor = UIColor.white// self.UIColorFromRGB(0xFFFFFF)
            self.noLabel!.font = UIFont(name: "HelveticaNeue", size: 40)
            self.noLabel!.textAlignment = NSTextAlignment.right
            self.noLabel!.text = "NOPE!"
        
            timeLabel.textColor = UIColor.white
            timeLabel.font = UIFont(name: "System", size: 14)
        
            DisplayTitle.textColor = UIColor.white
            DisplayTitle.font = UIFont.systemFont(ofSize: 26.0)
            DisplayTitle.numberOfLines = 0
        
            
            DisplayAddress.textColor = UIColor.white
            DisplayAddress.font = UIFont(name: "System", size: 15)
            DisplayAddress.numberOfLines = 5
            
            distanceLabel.textColor = hexStringToUIColor(hex: "FFFFFF")
            distanceLabel.font =  UIFont.boldSystemFont(ofSize: 16.0)
            distanceLabel.numberOfLines = 0
            
            let height = setView.frame.size.height
            let width = setView.frame.size.width
            
            
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
            self.videoNode.gravity = AVLayerVideoGravity.resizeAspectFill.rawValue
            self.videoNode.zPosition = 0
            self.videoNode.shouldAutoplay = false
            self.videoNode.layer.shouldRasterize = true
        
            self.videoNode.layer.borderColor = UIColor.clear.cgColor
        
                    self.videoNode.assetURL = URL(string: "https://storage.googleapis.com/project-316688844667019748.appspot.com/" + video.videoPath)
          //  self.videoNode.displaysAsynchronously = true
        
                    if(video.imagePath != ""){
                       self.videoNode.url = URL(string: video.imagePath)
                    }
                    SingletonData.staticInstance.setKey(video.key)
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
                    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                    let date = dateFormatter.date(from: video.createdAt)
                    if(date != nil){
                        timeLabel.text = SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true)
                    }
                 
                    let coordinate₀ = SingletonData.staticInstance.location
                    let coordinate₁ = CLLocation(latitude: CLLocationDegrees(video.lat), longitude: CLLocationDegrees(video.lng))
                    
                    let distanceInMeters = coordinate₁.distance(from: coordinate₀!)
                    let distance : String = String(describing: round(Double((distanceInMeters) / 1000) / 1.6))
                    distanceLabel.text = distance + "mi"
                    DisplayTitle.text = video.displayTitle
                    DisplayAddress.text = video.address
        
                    setView.addSubnode(self.videoNode)
                    setView.addSubview(overlayView)
                    let layer = CAGradientLayer()
                    layer.frame = CGRect(x: 0, y: 0, width: setView.frame.width, height: setView.frame.height)
                    layer.colors = [hexStringToUIColor(hex: "000000").cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, hexStringToUIColor(hex: "000000").cgColor]
                    layer.locations = [0.0, 0.5, 0.5, 1.0]
                    
                    layer.opacity = 0.5
                   
                    setView.layer.addSublayer(layer)
                  
                    setView.addSubview(distanceLabel)
                    setView.addSubview(DisplayTitle)
                    
                    DisplayTitle.translatesAutoresizingMaskIntoConstraints = false
                    DisplayTitle.topAnchor.constraint(equalTo: setView.topAnchor, constant: 10).isActive = true
                    DisplayTitle.leadingAnchor.constraint(equalTo: setView.leadingAnchor, constant: 10).isActive = true
                    
                    distanceLabel.translatesAutoresizingMaskIntoConstraints = false
                    distanceLabel.bottomAnchor.constraint(equalTo: setView.bottomAnchor, constant: -15).isActive = true
                    distanceLabel.leadingAnchor.constraint(equalTo: setView.leadingAnchor, constant: 10).isActive = true
                    
                    
                    setView.addSubview(self.yesLabel!)
                    setView.addSubview(self.noLabel!)
                    
                    
                    setView.layer.cornerRadius = 10
                    setView.layer.masksToBounds = true
        
                    self.yesLabel!.isHidden = true
                    self.noLabel!.isHidden = true
        
                    setView.layer.shadowColor = UIColor.black.cgColor
                    setView.layer.shadowOpacity = 1
                    setView.layer.shadowOffset = CGSize.zero
                    setView.layer.shadowRadius = 10
                    setView.layer.shadowPath = UIBezierPath(rect: setView.bounds).cgPath
                    setView.layer.shouldRasterize = true
        
                    return setView
        }
    
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
}
extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        //self.videos.removeAll()
        
        SingletonData.staticInstance.setMapLocation(location)
        // TODO: Add code to get address components from the selected place.
      // self.loadClosestVideos(loc: location)
        // Close the autocomplete widget.
        
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







