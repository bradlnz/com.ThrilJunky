////
////  MapViewController.swift
////  ThrilJunky
////
////  Created by Brad Lietz on 11/09/2016.
////  Copyright © 2016 ThrilJunky LLC. All rights reserved.
////
//
//import UIKit
//import AVKit
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
//
//class MapViewController: UIViewController, MKMapViewDelegate{
//
//    let geocoder = CLGeocoder()
//    var playerViewController = PlayerViewController()
//    let overlayHintController = OverlayHintController()
//    let clusteringManager = FBClusteringManager()
//    var pageMenu : CAPSPageMenu?
//    var reachability : Reachability? = nil
//    var player = AVPlayer()
//    var playerItem : AVPlayerItem?
//    var ref: DatabaseReference?
//    var cluster:[FBAnnotation] = []
//    var playbackLikelyToKeepUpContext = UnsafeMutablePointer<(Void)>(nil)
//    var playbackBufferFullContext = UnsafeMutablePointer<(Void)>(nil)
//    var playbackBufferEmptyContext = UnsafeMutablePointer<(Void)>(nil)
//    var playbackStatusContext = UnsafeMutablePointer<(Void)>(nil)
//    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//    var blurEffectView : UIVisualEffectView?
//    var callButton = UIButton(frame: CGRect(x: 0, y: 0, width: 210, height: 40))
//    var websiteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 210, height: 40))
//    var getDirectionsButton = UIButton(frame: CGRect(x: 0, y: 00, width: 210, height: 40))
//    var closeButton = UIButton(type: UIButtonType.system) as UIButton
//    let voteUpBtn = UIButton(type: UIButtonType.system) as UIButton
//    let voteUpBtnDone = UIButton(type: UIButtonType.system) as UIButton
//  //  var rideWithUberbutton = RequestButton()
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
//    let cache = Shared.dataCache
//    let dateFormatter = DateFormatter()
//    let closeBtn = UIButton(type: UIButtonType.system) as UIButton
//    let tickBtn = UIButton(type: UIButtonType.system) as UIButton
//    var isFinishedPlaying : Bool = false
//    
//    var images = [UIImage(named: "Indoor"),
//                  UIImage(named: "Outdoor"),
//                  UIImage(named: "Food"),
//                  UIImage(named: "Nightlife"),
//                  UIImage(named: "Events"),
//                  UIImage(named: "Other")]
//    
//    var categories: [String] = ["Indoor",
//                                "Outdoor",
//                                "Food",
//                                "Nightlife",
//                                "Events",
//                                "Other"]
//    
//    @IBOutlet weak var mapView: MKMapView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.mapView.delegate = self
//
//        OperationQueue().addOperation({
//            let mapBoundsWidth = Double(self.mapView.bounds.size.width)
//            let mapRectWidth:Double = self.mapView.visibleMapRect.size.width
//            let scale:Double = mapBoundsWidth / mapRectWidth
//            
//            var annotationArray : [MKAnnotation]? = nil
//            
//            
//            annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
//            
//            
//            self.clusteringManager.displayAnnotations(annotationArray!, onMapView:self.mapView)
//        })
//        
//        self.mapView.showsPointsOfInterest = false
//        self.mapView.showsUserLocation = true
//        
//        let span = MKCoordinateSpanMake(0.2, 0.2)
//        
//        
//        let loc = SingletonData.staticInstance.location
//        print(loc)
//        if loc != nil {
//            let region = MKCoordinateRegion(center: loc!.coordinate, span: span)
//            self.mapView.setRegion(region, animated: true)
//        }
//        
//        
//        
//        if loc != nil {
//            
//            
//            videosRef.observe(.childAdded, with: { (snapshot) -> Void in
//                print("added")
//                self.videos.append(Item(snapshot))
//            })
//            
//
//            
//            if videos.count <= 0 && cluster.count <= 0{
//                
//                
//                
//                self.refHandle = self.videosRef.queryOrderedByValue().observe(.value, with: { (snapshot) in
//                    
//                    self.videos.removeAll()
//                    self.cluster.removeAll()
//                    var allAnnotations = self.clusteringManager.allAnnotations()
//                    allAnnotations.removeAll()
//                    self.mapView.removeAnnotations(allAnnotations)
//                    
//                    for snap in snapshot.children{
//                        let item = Item(snap as! DataSnapshot)
//                        
//                        
//                        self.videos.append(item)
//                        
//                        
//                        let pinAnnotation = PinAnnotation()
//                        
//                        let lat : Double = Double(item.latitude)!
//                        let lng : Double = Double(item.longitude)!
//                        
//                        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//                        
//                        
//                        pinAnnotation.category = item.ActivityCategory
//                        pinAnnotation.phoneNumber = item.phoneNumber
//                        pinAnnotation.website = item.website
//                        pinAnnotation.address = item.address
//                        pinAnnotation.displayName = item.displayName
//                        pinAnnotation.displayHint = item.displayHint
//                        pinAnnotation.displayMsg = item.displayMsg
//                        pinAnnotation.createdAt = item.createdAt
//                        pinAnnotation.title = item.displayTitle
//                        pinAnnotation.subtitle = item.ActivityCategory
//                        pinAnnotation.videoPath = item.videoPath
//                        pinAnnotation.coordinate = coord
//                        pinAnnotation.userPhoto = item.userPhoto
//                        pinAnnotation.imagePath = item.imagePath
//                        pinAnnotation.key = item.key
//                        
//                        self.cluster.append(pinAnnotation)
//                        allAnnotations.append(pinAnnotation)
//                        
//                    }
//                    
//                    
//                    self.clusteringManager.setAnnotations(self.cluster)
//                    self.clusteringManager.displayAnnotations(allAnnotations, onMapView:self.mapView)
//                    
//                }) { (error) in
//                    print(error.localizedDescription)
//                }
//                
//            }
//        }
//
//        // Do any additional setup after loading the view.
//    }
//    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        var reuseId = ""
//        if annotation.isKindOfClass(FBAnnotationCluster) {
//            reuseId = "Cluster"
//            var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
//            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)
//            return clusterView
//        } else {
//            reuseId = "Pin"
//            if annotation is PinAnnotation {
//                let ann = annotation as! PinAnnotation
//                let pinAnnotationView = MKAnnotationView(annotation: ann, reuseIdentifier: reuseId)
//                
//                pinAnnotationView.draggable = false
//                pinAnnotationView.canShowCallout = true
//                pinAnnotationView.calloutOffset = CGPoint(x: 0, y: 10)
//                
//                var image : UIImage? = nil
//                
//                
//                image = UIImage(named: ann.category!)
//                if image == nil {
//                    
//                    image = UIImage.circle(30, color: UIColor.purple)
//                }
//                
//                
//                let size = CGSize(width: 50, height: 50)
//                let resizedAndMaskedImage = SingletonData.staticInstance.imageResize(image!, sizeChange: size)
//                pinAnnotationView.image = resizedAndMaskedImage
//                
//                pinAnnotationView.tintColor = UIColor.purpleColor()
//                
//                
//                let button = UIButton(type: UIButtonType.detailDisclosure)
//                button.addTarget(self, action: #selector(MapViewController.buttonClicked), for: UIControlEvents.touchUpInside)
//                pinAnnotationView.rightCalloutAccessoryView = button
//                
//                
//                return pinAnnotationView
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
//    
//    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        
//        if(view.annotation is MKUserLocation)
//        {
//            
//            
//        } else {
//            
//            if view.annotation!.isKindOfClass(FBAnnotationCluster) {
//                
//                for item in self.cluster {
//                    print(item)
//                }
//                
//                self.clusteringManager.displayAnnotations(self.cluster, onMapView:self.mapView)
//                
//            } else
//            {
//                let ann = view.annotation as! PinAnnotation
//                
//                
//                SingletonData.staticInstance.setSelectedAnnotation(ann)
//                SingletonData.staticInstance.setSelectedVideoItem(ann.videoPath!)
//                
//            }
//        }
//    }
//    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        
//        
//        do {
//            reachability = try Reachability.reachabilityForInternetConnection()
//        } catch {
//            print("Unable to create Reachability")
//            
//        }
//        
//        
//        reachability!.whenReachable = { reachability in
//            // this is called on a background thread, but UI updates must
//            // be on the main thread, like this:
//            DispatchQueue.main.async {
//                if reachability.isReachableViaWiFi() {
//                    print("Reachable via WiFi")
//                    NSOperationQueue().addOperationWithBlock({
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
//                    NSOperationQueue().addOperationWithBlock({
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
//        reachability!.whenUnreachable = { reachability in
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
//            try reachability!.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
//        
//    }
//
//    func buttonClicked(){
//        DispatchQueue.main.async {
//            
//            
//            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoPlayer")
//            
//            self.present(viewController, animated: true, completion: nil)
//            
//            
//            //            self.playVideo(SingletonData.staticInstance.selectedVideoItem)
//        }
//    }
//    
//    
//    @IBAction func backButon(_ sender: AnyObject) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
