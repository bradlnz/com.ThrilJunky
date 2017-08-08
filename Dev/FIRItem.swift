//
//  FIRItem.swift
//  ThrilJunky
//
//  Created by Lietz on 3/08/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

class FIRItem: FIRDataObject {

    
    var ActivityCategories : String = ""
    var SubActivityCategories : String = ""
    var RefinedActivityCategories : String = ""
    var address : String = ""
    var businessName : String = ""
    var createdAt : String = ""
    var userGenerated : String = ""
    var displayName : String = ""
    var displayHint: String = ""
    var displayMsg: String = ""
    var displayTitle: String = ""
    var imagePath : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var phoneNumber : String = ""
    var uid : String = ""
    var videoPath : String = ""
    var website : String = ""
    var phone : String = ""
    var userPhoto : String = ""
    var taggedLocation : String = ""
    var images = [UIImageView]()
    var voteUp : Int = 0
    var voteDown : Int = 0
    var averageVote : Float = 0.0
    var distanceFromLoc : Float = 0.0
    var show : Bool? = true
    
}
