////
////  ModalViewController.swift
////  ThrilJunky
////
////  Created by Brad Lietz on 20/5/17.
////  Copyright © 2017 ThrilJunky LLC. All rights reserved.
////
//
//import Foundation
//import MapKit
//
//class ModalController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
//    
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var modalBackground: UIView!
//    
//    var items = [RealmObject]()
//    
//    
//    func handleTap(gestureRecognizer: UIGestureRecognizer) {
//        self.dismiss(animated: false, completion:  nil)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ModalController.handleTap(gestureRecognizer:)))
//        gestureRecognizer.delegate = self
//        modalBackground.addGestureRecognizer(gestureRecognizer)
//        
//        items = SingletonData.staticInstance.closestVideo
//        
//        
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.tableView.reloadData()
//    }
//    
//    
//    @IBAction func searnAction(_ sender: Any) {
//        let popup : LocationSearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "LocationSearchViewController") as! LocationSearchViewController
//        let navigationController = UINavigationController(rootViewController: popup)
//        
//        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        self.present(navigationController, animated: false, completion: nil)
//        
//
//    }
//   
// 
//    override func viewWillDisappear(_ animated: Bool) {
//    
//        self.dismiss(animated: false, completion:  nil)
//        
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//          self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.items.count
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    
//        let item = self.items[(indexPath as NSIndexPath).row]
//        
//        SingletonData.staticInstance.setSelectedObject(item)
//        
//              DispatchQueue.main.async{
//                let viewController = UIStoryboard(name: "Post", bundle: nil).instantiateViewController(withIdentifier: "Share") as! CameraViewController
//            
//                viewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//                
//                
//                
//                self.present(viewController, animated: false, completion: {
//                     self.dismiss(animated: false, completion:  nil)
//                    UIApplication.shared.isStatusBarHidden = true
//              
//                })
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as! ModalPlaceCell
//        //
//        let item = self.items[(indexPath as NSIndexPath).row]
//        
//        cell.title.text = item.displayTitle
//        cell.address.text = item.address
//    
//   
//        return cell
//    }
//
//    
//}

