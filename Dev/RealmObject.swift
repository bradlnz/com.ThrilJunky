//
//  RealmObject.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 8/6/17.
//  Copyright © 2017 ThrilJunky LLC. All rights reserved.
//

import Foundation
import Realm
import RealmSwift



class RealmObject : Object {

    dynamic var key : String = ""
    dynamic var ActivityCategories : String = ""
    dynamic var SubActivityCategories : String = ""
    dynamic var RefinedActivityCategories : String = ""
    dynamic var address : String = ""
    dynamic var createdAt : String = ""
    dynamic var displayName : String = ""
    dynamic var displayTitle: String = ""
    dynamic var imagePath : String = ""
    dynamic var lat : Float = 0.0
    dynamic var lng : Float = 0.0
    dynamic var userGenerated : String = ""
    dynamic var videoPath : String = ""
    dynamic var website : String = ""
    dynamic var phone : String = ""

    dynamic var voteUp : Int = 0
    dynamic var voteDown : Int = 0
    dynamic var uid : String = ""


}
