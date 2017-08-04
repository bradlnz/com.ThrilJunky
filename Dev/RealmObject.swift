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

    @objc dynamic var key : String = ""
    @objc dynamic var ActivityCategories : String = ""
    @objc dynamic var SubActivityCategories : String = ""
    @objc dynamic var RefinedActivityCategories : String = ""
    @objc dynamic var address : String = ""
    @objc dynamic var createdAt : String = ""
    @objc dynamic var displayName : String = ""
    @objc dynamic var displayTitle: String = ""
    @objc dynamic var imagePath : String = ""
    @objc dynamic var lat : Float = 0.0
    @objc dynamic var lng : Float = 0.0
//    dynamic var phoneNumber : String = ""
//    dynamic var uid : String = ""
    @objc dynamic var videoPath : String = ""
    @objc dynamic var website : String = ""
//    dynamic var userPhoto : String = ""
//    dynamic var taggedLocation : String = ""
    @objc dynamic var voteUp : Int = 0
    @objc dynamic var voteDown : Int = 0
//    dynamic var averageVote : Float = 0.0
//    dynamic var distanceFromLoc : Float = 0.0

}
