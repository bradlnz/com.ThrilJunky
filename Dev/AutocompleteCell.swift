//
//  AutocompleteCell.swift
//  ThrilJunky
//
//  Created by Lietz on 12/11/16.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import Foundation
import UIKit

class AutocompleteCell : UITableViewCell {
    
    
    @IBOutlet weak var result: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        result.text = nil

    }
    
    
}
