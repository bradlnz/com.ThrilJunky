//
//  ActionPicksCell.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 27/11/16.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Firebase
import MapKit
import Photos


class ActionPicksCell : UITableViewCell {
    
    @IBOutlet weak var textLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLbl.text = nil
        
    }
    
    
}
