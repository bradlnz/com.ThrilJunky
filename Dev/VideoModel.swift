//
//  VideoModel.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 10/7/17.
//  Copyright © 2017 ThrilJunky LLC. All rights reserved.
//

import Foundation

class VideoModel : FIRDataObject {
    
    
    var uid : String = ""
    var displayTitle : String = ""
    var displayName : String = ""
    var taggedLocation : String = ""
    var userGenerated : String = ""
    var address : String = ""
    var videoPath : String = ""
    var imagePath : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var update : String = ""
    var views : Int = 0
    var swipedLeft : Int = 0
    var swipedRight : Int = 0
}
