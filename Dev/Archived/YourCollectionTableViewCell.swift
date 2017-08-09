//
//  YourCollectionTableViewCell.swift
//  ThrilJunky
//
//  Created by Lietz on 6/11/16.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import Foundation
import UIKit

class YourCollectionTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var displayTitle: UILabel!
    
    @IBOutlet weak var timeSince: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
      imgView.image = nil
       timeSince.text = nil
       displayTitle.text = nil
    }
    
    
}
