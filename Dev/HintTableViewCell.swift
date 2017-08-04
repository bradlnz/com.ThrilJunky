//
//  HintTableViewCell.swift
//  ThrilJunky
//
//  Created by Lietz on 18/08/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

class HintTableViewCell: UITableViewCell {

    
    @IBOutlet weak var hintText: UILabel!
    @IBOutlet weak var videoTime: UILabel!
    @IBOutlet weak var displayPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
