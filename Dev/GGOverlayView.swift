//
//  GGOverlayView.swift
//  ThrilJunky
//
//  Created by Lietz on 8/10/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//
import Foundation
import UIKit

enum OverlayViewMode {
    case none
    case left
    case right
}


class OverlayView:UIView {
    var imageView = UIImageView()
    var mode = OverlayViewMode.none
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setView()
        addImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView() {
        self.backgroundColor = UIColor.clear
    }
    
    func addImageView() {
        setImageViewFrame()
        self.addSubview(imageView)
    }
    
    func setImageViewFrame() {
        imageView.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        
    }
    func setMyImageView(_ buttonString: String) {
        imageView.image = UIImage(named: buttonString)
    }
    
    func setMode(_ mode: OverlayViewMode) {
        if (self.mode == mode) {
            return;
        }
        
        self.mode = mode;
        
        switch (mode) {
        case .left:
            setMyImageView("noButton")
            break;
        case .right:
            setMyImageView("yesButton")
            break;
        case .none:
            break;
            
        }
    }
    
}
