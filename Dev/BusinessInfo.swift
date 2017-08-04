//
//  BusinessInfo.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 13/06/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

class BusinessInfoItem: NSObject {
    
    var displayPhone : String? = ""
    var distance : Double?
    var id : String? = ""
    var mobileUrl : String? = ""
    var name : String? = ""
    
    
    init(nameVal: String, displayPhoneVal : String, distanceVal: Double, idVal : String, mobileUrlVal : String){
        displayPhone = displayPhoneVal
        name = nameVal
        distance = distanceVal
        id = idVal
        mobileUrl = mobileUrlVal
    }

}
