//
//  CustomOverlayView.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 21/5/17.
//  Copyright © 2017 ThrilJunky LLC. All rights reserved.
//

import Foundation
import UIKit
import Koloda

private let overlayRightImageName = "yesOverlayImage"
private let overlayLeftImageName = "noOverlayImage"

class CustomOverlayView: OverlayView {
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    
   override var mode: OverlayViewMode  {
        didSet {
            switch mode {
            case .left:
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .right:
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }
            
        }
    }
    
}
