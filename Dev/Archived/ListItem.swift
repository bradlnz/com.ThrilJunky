//
//  ListItem.swift
//  Dev
//
//  Created by Brad Lietz on 10/01/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import AVFoundation

 class ListItem: NSObject {

    // A text description of this item.
    
    var objectId: String?
    var desc: String?
    var videoUrl: URL?
    var latitude: Double?
    var longitude: Double?
    var previewImage: UIImage?
    var username: String?
 
    // Returns a ToDoItem initialized with the given text and default completed value.
    init(desc: String, latitude: Double, longitude: Double, videoUrl: URL, previewImage: UIImage, objectId: String, username: String) {
     
        self.videoUrl = videoUrl
        self.desc = desc
        self.latitude = latitude
        self.longitude = longitude
        self.previewImage = previewImage
        self.objectId = objectId
        self.username = username
}
    
    deinit{
        print(" is being deInitialized.")
        
    }

}
