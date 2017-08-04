//
//  PinAnnotation.swift
//  Dev
//
//  Created by Brad Lietz on 16/01/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import MapKit
import Foundation
import UIKit
import FBAnnotationClusteringSwift

class PinAnnotation : FBAnnotation {
    var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    var key: String? = ""
    var subtitle: String? = ""
    var desc: String? = ""
    var category: String? = ""
    var subCategory: String? = ""
    var previewImage: UIImageView?
    var userPhoto: String? = ""
    var videoPath: String? = ""
    var imagePath: String? = ""
    var user: String? = ""
    var createdAt: String?
    var phoneNumber : String? = ""
    var website : String? = ""
    var address : String? = ""
    var displayName : String? = ""
    var displayCategory : String? = ""
    var displayTitle : String? = ""
    var displayMsg : String? = ""
    var displayHint : String? = ""
    
    
    func setCoordinate(_ newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
    
    deinit{
        print(" is being deInitialized.")
        
    }

}
