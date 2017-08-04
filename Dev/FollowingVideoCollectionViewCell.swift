//
//  FollowingVideoCollectionViewCell.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 28/08/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

class FollowingVideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var displayTitle: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var timeSince: UILabel!
    
    
    @IBOutlet weak var location: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        timeSince.text = nil
        displayTitle.text = nil
    }
    
    
}
