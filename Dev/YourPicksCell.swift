//
//  YourPicksCell.swift
//  ThrilJunky
//
//  Created by Lietz on 5/11/16.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import Foundation
import UIKit

class YourPicksCell: UITableViewCell {

    
    
    @IBOutlet weak var pickImage: UIImageView!
    @IBOutlet weak var pickTitle: UILabel!
    @IBOutlet weak var pickLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pickImage.image = nil
        pickTitle.text = nil
        pickLocation.text = nil
    }
    
}
