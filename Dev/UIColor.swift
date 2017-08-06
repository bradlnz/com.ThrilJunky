//
//  UIColr.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 10/7/17.
//  Copyright © 2017 ThrilJunky LLC. All rights reserved.
//

import Foundation


extension UIColor {
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
