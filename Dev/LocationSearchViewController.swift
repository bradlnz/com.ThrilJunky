////
////  LocationSearchViewController.swift
////  ThrilJunky
////
////  Created by Brad Lietz on 26/08/2016.
////  Copyright © 2016 ThrilJunky LLC. All rights reserved.
////
//
//import UIKit
//import MapKit
////import PKHUD
//
//class LocationSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
//
//    var delegateBg : LocationSearchViewDelegate?
//    
//    @IBOutlet weak var modalBackground: UIView!
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var tableView: UITableView!
//    
//    var searchController:UISearchController!
//    var localSearchRequest:MKLocalSearchRequest!
//    var localSearch:MKLocalSearch!
//    var localSearchResponse:MKLocalSearchResponse!
//    var error:NSError!
//  
//    var searchActive : Bool = false
//    var filtered : [GeocodePlace] = []
//    let SEARCH_DELAY_IN_MS = 100
//    var _scheduledSearch = false
//    var myQueue = DispatchQueue(label: "com.queue.my", attributes: DispatchQueue.Attributes.concurrent)
//
//    @IBAction func backBtnTop(_ sender: AnyObject) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchActive = false
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false
//    }
//    
//    
//    @IBAction func closeBtn(_ sender: Any) {
//        self.dismiss(animated: false, completion: nil)
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//
//        
//        GeocodeHelper.shared.decode(searchText, completion: { places  -> () in
//         
//            if places != nil {
//                self.filtered = places!
//                self.tableView.reloadData()
//              
//                return
//            }
//           
//            })
//    }
//
//    
////    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
////        
////    self.scheduleSearch(searchText)
////    
////    }
//    
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(searchActive) {
//            return filtered.count
//        }
//        return filtered.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
//        cell.textLabel?.text = filtered[(indexPath as NSIndexPath).row].name
//        cell.detailTextLabel?.text = filtered[(indexPath as NSIndexPath).row].address
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    
//        SingletonData.staticInstance.setSelectedMapItem(filtered[(indexPath as NSIndexPath).row])
//        SingletonData.staticInstance.setCatCount(input: 0)
//        
//        
//        let item = filtered[(indexPath as NSIndexPath).row]
//        
//        
//        
//        if SingletonData.staticInstance.isPostVideo == true && self.modalBackground == nil {
//            SingletonData.staticInstance.setBusinessName(input: item.name)
//            SingletonData.staticInstance.setAddress(item.address)
//            
//            self.dismiss(animated: true, completion: nil)
//        }
//        
//        if SingletonData.staticInstance.isPostVideo == false {
//              DispatchQueue.main.async {
//                
//                let loc = item.location
//                let geoCoder = CLGeocoder()
//                let location = CLLocation(latitude: loc!.coordinate.latitude, longitude: loc!.coordinate.longitude)
//                
//                geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//                    
//                    // Place details
//                    var placeMark: CLPlacemark!
//                    placeMark = placemarks?[0]
//                    
//                    print(placeMark)
//                    // City
//                    if let locality = placeMark.addressDictionary!["locality"] as? NSString {
//                        
//                        if(locality != ""){
//                            self.title = (locality as String)
//                            SingletonData.staticInstance.setTitle(locality as String)
//                        } else {
//                            
//                        }
//                        
//                    }
//                    
//                })
//
//            SingletonData.staticInstance.setInitLoad(input: true)
//            SingletonData.staticInstance.setOverrideLocation(item.location)
//                self.dismiss(animated: true, completion: {
//                
//                    self.delegateBg?.changeLocation()
//                    
//                })
//            }
//        }
//        
//        if SingletonData.staticInstance.isPostVideo == true && self.modalBackground != nil {
//             let item = filtered[(indexPath as NSIndexPath).row]
//            
//            var fitem : RealmObject?
//            
//            fitem?.displayName = item.name!
//            fitem?.displayTitle = item.name!
//            fitem?.address = item.address!
//            
//              SingletonData.staticInstance.setSelectedObject(fitem)
//            DispatchQueue.main.async{
//                let viewController = UIStoryboard(name: "Post", bundle: nil).instantiateViewController(withIdentifier: "Share") as! CameraViewController
//                
//                viewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//                
//                
//                
//                self.present(viewController, animated: false, completion: {
//                    self.dismiss(animated: false, completion:  nil)
//                    UIApplication.shared.isStatusBarHidden = true
//                    
//                })
//            }
//        }
//        
//    }
//    
//    func handleTap(gestureRecognizer: UIGestureRecognizer) {
//        self.dismiss(animated: false, completion:  nil)
//    }
//    
//    @IBAction func backBtn(_ sender: AnyObject) {
//        
//           DispatchQueue.main.async{
//        self.dismiss(animated: true, completion: nil)
//        }
//    }
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.searchBar.delegate = self
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//         self.navigationController?.isNavigationBarHidden = true
//        // Do any additional setup after loading the view.
//        
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LocationSearchViewController.handleTap(gestureRecognizer:)))
//        gestureRecognizer.delegate = self
//        if(modalBackground != nil){
//            self.modalBackground.addGestureRecognizer(gestureRecognizer)
//        }
//    }
//    
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
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
//protocol LocationSearchViewDelegate {
//
//    func changeLocation()
// 
//}

