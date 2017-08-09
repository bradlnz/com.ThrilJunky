//
//  BusinessTableViewCell.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 15/03/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
 
 
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
