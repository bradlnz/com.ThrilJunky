//
//  SingletonData.swift
//  Dev
//
//  Created by Brad Lietz on 14/01/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class SingletonData{

    static let staticInstance = SingletonData()
 
    var loggedInUserToken = ""
    var coLocation : String?
    var location : CLLocation?
    var mapLocation: CLLocation?
    var overrideLocation : CLLocation?
    var overrideDistance : Bool?
    var title : String?
    var taggedLocation: CLLocation?
    var address: String?
    var videoPlayed : URL?
    var selectedVideoItem: String?
    var displayName : String?
    var mergedClip : URL?
    var selectedItemUser : String?
    var selectedObjectId : String?
    var selectedAnnotation: PinAnnotation?
    var selectedObject: RealmObject?
    var selectedObjects: [FIRItem]?
    var selectedItemHasUserVoted : Bool?
    var selectedPicker: String!
    var activityProvider: String?
    var activityCategory: String?
    var activitySubCategory: String?
    var displayCategory: String?
    var userProfileImage: UIImage?
    var key: String?
    var listOfItems = [ListItem]()
    var objs : [String : AnyObject] = [:]
    var businessTagged : BusinessInfoItem?
    var keys : [String] = []
    var createdAt : String?
    var name : String?
    var MapItems = [MKMapItem]()
    var selectedMapItem : GeocodePlace?
    var phoneNumber : String?
    var website : URL?
    var region: MKCoordinateRegion?
    var readyToUpload: Bool?
    var isPostVideo : Bool? = false
    var videoFrameWidth : CGFloat?
    var videoFrameHeight : CGFloat?
    var videoImage : URL?
    var setDistance : Float?
    var closestVideo : [RealmObject] = []
    var catCount : Int? = 0
    var Activities : [[String:Any]]?
    var minDistance : Float?
    var initLoad : Bool? = true
    var businessName : String?
    
    
    func setMapRegion(input: MKCoordinateRegion?){
        region = input
    }
    
    func setBusinessName(input : String?){
        businessName = input
    }
    
    func setInitLoad(input : Bool?){
            initLoad = input
    }
    
    func setMinDistance(input : Float?){
            minDistance = input
    }
    
    func setActivities(input : [[String:Any]]?){
        Activities = input
    }
    func setCatCount(input : Int?){
        catCount = input
    }
    func setTitle(_ input : String?){
        title = input
    }
    func setDistance(_ input : Float?){
     setDistance = input
    }
    func appendObject(_ input : RealmObject?){
        closestVideo.append(input!)
    }
    func overrideCloseObject(){
        self.closestVideo.removeAll()
    }
    
    func setSelectedObjects(_ input : [FIRItem]?){
        selectedObjects = input
    }
    func setVideoImage(_ input : URL?){
        videoImage = input
    }
    
    func setKeys(_ input : String){
        keys.append(input)
    }
    func setVideoFrameWidth(_ input : CGFloat?){
        videoFrameWidth = input
    }
    
    func setVideoFrameHeight(_ input : CGFloat?){
        videoFrameHeight = input
    }
    
    
    func setSelectedMapItem(_ input : GeocodePlace!){
        selectedMapItem = input
    }
    func setIsPostVideo(_ input : Bool!){
        isPostVideo = input
    }
    func setReadyToUpload(_ input : Bool!){
        readyToUpload = input
    }
    func setVideoPlayed(_ input : URL!)
    {
        videoPlayed = input
    }
    func setMergedClip(_ input : URL!){
        mergedClip = input
    }
    func setActivityProvider(_ input : String!){
        activityProvider = input
    }
    func setRegion(_ input : MKCoordinateRegion){
        region = input
    }
    func setUserPhoto(_ input : UIImage){
        userProfileImage = input
    }
    func setDisplayName(_ input : String!){
        displayName = input
    }
    func setActivityCategory(_ input : String!){
        activityCategory = input
    }
    
    func setActivitySubCategory(_ input : String!){
        activitySubCategory = input
    }
    
    func setDisplayCategory(_ input : String!){
        displayCategory = input
    }
    
    func setOverrideLocation(_ input : CLLocation!){
        overrideLocation = input
    }
    
    func setMapLocation(_ input : CLLocation!){
        mapLocation = input
    }
    
    func setLocation(_ input : CLLocation!){
        location = input
    }
    
    func setTaggedLocation(_ input : CLLocation!){
        taggedLocation = input
    }
    
    func setAddress(_ input: String?){
        address = input
    }
    
    func setCreatedAt(_ input : String!){
        createdAt = input
    }
   
    func setSelectedPicker(_ input: String!)
    {
        selectedPicker = input
    }
    
    func setSelectedVideoItem(_ input : String!)
    {
        selectedVideoItem = input
    }
    
    func setSelectedAnnotation(_ input : PinAnnotation?)
    {
        selectedAnnotation = input
    }
    
    func setSelectedObject(_ input : RealmObject?){
        selectedObject = input
    }
    
    func setPhoneNumber(_ input: String?){
        phoneNumber = input
    }
    func setWebsite(_ input: URL?){
        website = input
    }
    func setName(_ input: String?){
        name = input
    }
    
    func setMapItems(_ input: [MKMapItem]?){
        MapItems = input!
    }
    
    func setLoggedInUserToken(_ token: String!)
    {
        if token != ""
        {
            loggedInUserToken = token
        }
    }
    
    func setSelectedItemUser(_ item: String?)
    {
        if(item != "")
        {
            selectedItemUser = item
        }
    }
    
    func setBusinessInfoItem(_ item: BusinessInfoItem?){
        businessTagged = item
    }
    
    func setSelectedItemHasUserVoted(_ item: Bool?)
    {
        selectedItemHasUserVoted = item
    }
    
    func setSelectedObjectId(_ item: String?)
    {
        selectedObjectId = item
    }
    
    func setCoLocation(_ item : String?)
    {
        coLocation = item
    }
    
    func setObjs(_ item: [String : AnyObject]?){
        objs = item!
    }
    
    func setKey(_ item : String?){
        key = item
    }
    
    
    func setNil(){
        closestVideo = []
    }
    
    func removeDuplicates(_ array: [FIRItem]) -> [FIRItem] {
        var encountered = Set<String>()
        
        var result: [FIRItem] = []
        for value in array {
            
            if encountered.contains(value.key) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value.key)
                
                // ... Append the value.
                result.append(value)
            }
        }
        return result
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
    
//    func indexOfMessage(snapshot: FIRDataSnapshot) -> Int {
//        var index = 0
//        for video in self.videos {
//            if (snapshot.key == video.key) {
//                return index
//            }
//            index += 1
//        }
//        return -1
//    }
    
    func timeAgoSinceDate(_ date:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }

    
    func setOverrideDistance(input: Bool?){
        overrideDistance = input
    }
    
    deinit{
        print(" is being deInitialized.")
        
    }


    
}
