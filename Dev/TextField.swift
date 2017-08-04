//
//  TextField.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 4/09/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

@IBDesignable
class TextField: UITextField {
    @IBInspectable var insetX: CGFloat = 10
    @IBInspectable var insetY: CGFloat = 10
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }
}
