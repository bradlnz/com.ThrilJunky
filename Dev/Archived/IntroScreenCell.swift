//
//  IntroScreenCell.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 1/04/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

class IntroScreenCell: UITableViewCell {

    @IBOutlet weak var imageWrapper: UIView!

  
    @IBOutlet weak var textVal: UIButton!

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    func offset(_ offset: CGPoint) {
        imgView.frame = self.imgView.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.imageWrapper.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
