//
//  FilterCollectionView.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 30/11/16.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Firebase
import MapKit
import Photos
//import GeoFire

class FilterCollectionView : UICollectionViewCell {
    
  //  @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLbl.text = nil
        //imgView.image = nil
    }
    
    
}
