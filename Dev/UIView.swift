//
//  UIView.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 8/05/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

extension UIView{
    func fadeIn(_ duration: TimeInterval = 0.5)
    {
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.alpha = 1.0
        }) 
    }
}
