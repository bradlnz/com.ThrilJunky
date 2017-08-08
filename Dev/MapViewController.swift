import UIKit
import GoogleMaps
import ClusterKit
import Firebase
import ObjectiveC
import Kingfisher
import RealmSwift

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var dismissMapBtn: UIButton!
    var realm : Realm! = nil
    var places = [Place]()
    var arViewController: ARViewController!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var zoomLevel: Float = 15.0
     let videoRootPath = "https://storage.googleapis.com/project-316688844667019748.appspot.com/"
     let videosRef = FIRDatabase.database().reference(withPath: "videos")
    
    var items = [FIRItem]()
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.delegate = nil
        mapView.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        mapView.delegate = self
        
        
        dismissMapBtn.layer.cornerRadius = 25
        dismissMapBtn.layer.masksToBounds = true
        dismissMapBtn.layer.allowsEdgeAntialiasing = true
        
        self.items.removeAll()
        
        self.videosRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            for snap in snapshot.children{
                print(snapshot.children)
                let item = FIRItem(snapshot: snap as! FIRDataSnapshot)
                
                if(item.userGenerated == "false"){
                    
                    
                    FIRDatabase.database().reference().child("businesses").queryOrdered(byChild: "uid").queryEqual(toValue: item.uid).observeSingleEvent(of: .value, with: { (snap) in
                        
                        
                        for var vid in snap.children {
                            let business = BusinessModel(snapshot: vid as! FIRDataSnapshot)
                            
                            let numberFormatter = NumberFormatter()
                            let lat = numberFormatter.number(from: business.latitude)
                            let lng = numberFormatter.number(from: business.longitude)
                            
                  
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat!), longitude: CLLocationDegrees(lng!))
                            marker.title = item.displayTitle
                            marker.video = item
                            let url = URL(string: item.imagePath)
                            let imgView = UIImageView(image: marker.icon)
                            imgView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                            imgView.layer.cornerRadius = 25
                            imgView.layer.masksToBounds = true
        //                    imgView.layer.borderWidth = 3
        //                    imgView.layer.allowsEdgeAntialiasing = true
        //                    imgView.layer.borderColor = UIColor.white.cgColor
                            imgView.kf.setImage(with: url)
                    
                            marker.iconView = imgView
                            
                            marker.map = self.mapView
                    
                     let img2 = UIImageView(image: marker.icon)
                            img2.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                            img2.layer.cornerRadius = 25
                            img2.layer.masksToBounds = true
                            img2.kf.setImage(with: url)

                            let place = Place(location: CLLocation(latitude: Double(lat!), longitude: Double(lng!)), reference: "", name: business.businessName, address: business.address, img: img2, key: business.key)
                            
                    self.places.append(place)
                    
                    self.items.append(item)
                            
                        }
                        
                       })
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func openAr(_ sender: Any) {
        
        arViewController = ARViewController()
        arViewController.dataSource = self
        arViewController.maxDistance = 30000
        arViewController.maxVisibleAnnotations = 30
        arViewController.maxVerticalLevel = 5
        arViewController.headingSmoothingFactor = 0.15
        
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75
        print(self.places)
        arViewController.setAnnotations(self.places)
        arViewController.uiOptions.debugEnabled = false
        arViewController.uiOptions.closeButtonEnabled = true
        
        self.present(arViewController, animated: true, completion: nil)
    }
    
    @IBAction func dismissMap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

public final class ObjectAssociation<T: AnyObject> {
    
    private let policy: objc_AssociationPolicy
    
    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        
        self.policy = policy
    }
    
    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {
        
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

extension GMSMarker {
    private static let association = ObjectAssociation<FIRItem>()
    
    var video: FIRItem? {
        
        get { return GMSMarker.association[self] }
        set { GMSMarker.association[self] = newValue }
    }
}
extension MapViewController: GMSMapViewDelegate {
//
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        
        let obj = RealmObject()
        
        let item = marker.video!
        
        obj.address = item.address
        obj.createdAt = item.createdAt
        obj.displayName = item.displayName
        obj.displayTitle = item.displayTitle
        obj.imagePath = item.imagePath
        obj.key = item.key
        obj.lat = Float(marker.position.latitude)
        obj.lng = Float(marker.position.longitude)
        obj.videoPath = item.videoPath
        obj.website = item.website
        
        SingletonData.staticInstance.setSelectedObject(obj)
        
        self.performSegue(withIdentifier: "moreInfoMapSegue", sender: self)
        
        return true
    }
//
//    
}

extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        if(SingletonData.staticInstance.mapLocation == nil){
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: 14)
            
            SingletonData.staticInstance.setMapLocation(location)
            
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
            
        } else {
            let camera = GMSCameraPosition.camera(withLatitude: SingletonData.staticInstance.mapLocation!.coordinate.latitude,
                                                  longitude: SingletonData.staticInstance.mapLocation!.coordinate.longitude,
                                                  zoom: 14)
            
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    
}

extension MapViewController: ARDataSource {
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        
        return annotationView
    }
}

extension MapViewController: AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView) {
        if let annotation = annotationView.annotation as? Place {
            
            let obj = RealmObject()
            
            
        
            obj.key = annotation.key
        
            SingletonData.staticInstance.setSelectedObject(obj)
            
            self.performSegue(withIdentifier: "moreInfoMapSegue", sender: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
