//
//  UINavigationBar.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 27/5/17.
//  Copyright © 2017 ThrilJunky LLC. All rights reserved.
//

import Foundation

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}
