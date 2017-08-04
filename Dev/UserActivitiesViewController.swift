//
//  UserActivitiesViewController.swift
//  Dev
//
//  Created by Brad Lietz on 27/01/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class UserActivitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var player:AVPlayer!
    var playerLayer = AVPlayerLayer()
    
    
    
    var tappedCell : ListItem!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.hidden = false
            self.tableView?.reloadData()
            
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.dataSource = self
            self.tableView.delegate = self
           
            self.tableView.hidden = false
         
            self.tableView?.reloadData()
        }
    }
    
   
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SingletonData.staticInstance.listOfItems.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell",
                forIndexPath: indexPath) as! TableViewCell
            
            let item = SingletonData.staticInstance.listOfItems[indexPath.row]
            
            cell.desc?.text = item.desc
            cell.imageField?.image = item.previewImage!
            tappedCell = item
        
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = SingletonData.staticInstance.listOfItems[indexPath.row]
        
        let nsUrl =  item.videoUrl?.relativePath
       
        let urlReplaced = nsUrl!.stringByReplacingOccurrencesOfString("https:/", withString: "https://")
        
        playVideo(urlReplaced)
    }
    
    

    func playVideo(url: String?)
    {
       self.navigationController?.navigationBar.hidden = true
        self.tableView.hidden = true
        self.tabBarController?.tabBar.hidden = true
         let refurl = NSURL(string: url!)
        
        
        let playerItem = AVPlayerItem(URL: refurl!)
        self.player = AVPlayer(playerItem:playerItem)
        self.player.volume = 1.0
         self.player.muted = false
            self.playerLayer = AVPlayerLayer(player: self.player)
        
            self.playerLayer.frame = self.view.layer.bounds
            self.view.layer.addSublayer(self.playerLayer)
        
        
        
            self.player.play()
        
        player.addObserver(self, forKeyPath: "status", options:NSKeyValueObservingOptions(), context: nil)
        player.addObserver(self, forKeyPath: "playbackBufferEmpty", options:NSKeyValueObservingOptions(), context: nil)
        player.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options:NSKeyValueObservingOptions(), context: nil)
        player.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions(), context: nil)
        
            SingletonData.staticInstance.setVideoPlayed(refurl)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "status"
        {
            print("Change at keyPath = \(keyPath) for \(object)")
        }
        if keyPath == "playbackBufferEmpty" {
            print("No internet connection, ThrilJunky requires an internet connection to continue streaming.")
            print("Change at keyPath = \(keyPath) for \(object)")
        }
        
        if keyPath == "playbackLikelyToKeepUp" {
            print("Change at keyPath = \(keyPath) for \(object)")
        }
       
    }
    
    @IBAction func goBack(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.player.pause()
            self.playerLayer.removeFromSuperlayer()
        }
        dispatch_async(dispatch_get_main_queue()) {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
func loadInitData()
{
    do{
        SingletonData.staticInstance.listOfItems.removeAll()
        
        loadingIndicator.hidden = false
        
    let user = PFUser.currentUser()?.username
    
    if user != nil{
        
        let query = PFQuery(className: "Videos")
        query.whereKey("username", equalTo: user!)
        let videoArray = try query.findObjects()
       
        
            for object in videoArray {
                let objectId = object["objectId"] as! String
                let file = object["videoPath"] as! PFFile
                let location = object["location"] as! PFGeoPoint
                let latitude = location.latitude
                let longitude = location.longitude
                let url =  NSURL(fileURLWithPath: file.url!)
               
                
                let previewImage = object["imagePath"] as! PFFile
                
                
                previewImage.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error:NSError?) -> Void in
                    if (error == nil) {
                        let image = UIImage(data:imageData!)
                        
                        SingletonData.staticInstance.listOfItems.append(ListItem(title: "TEST TITLE", desc: "TEST DESCRIPTION", latitude: latitude, longitude: longitude, videoUrl: url, previewImage: image!, objectId: objectId))
                       self.loadingIndicator.hidden = true
                    }
                })
            }
        }
    } catch let error as NSError {
            // Handle any errors
            print(error)
    }
    
}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
