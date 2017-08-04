//
//  VideoCollectionViewCell.swift
//  ThrilJunky
//
//  Created by Lietz on 17/08/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var displayTitle: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var timeSince: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        timeSince.text = nil
        displayTitle.text = nil
    }
}
