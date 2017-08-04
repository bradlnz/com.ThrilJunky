//
//  UIImage.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 8/05/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit


extension UIImage {
    class func circle(_ radius: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: radius, height: radius), false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: radius, height: radius)
        
     
        ctx!.setStrokeColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 255.0)
        ctx!.setLineWidth(3)
          ctx!.strokeEllipse(in: rect)
        ctx!.setFillColor(color.cgColor)
        
      
        ctx!.fillEllipse(in: rect)
        
        ctx!.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return img!
    }

   
        
    func drawBlackBorder(_ view: UIView, bgColor: UIColor, borderColor: UIColor) {
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 1.0
        
        view.layer.cornerRadius = view.frame.size.width/2.0
        view.backgroundColor = bgColor
        
    }
    
    
    func maskRoundedImage() -> UIImage {
        let imageView = UIImageView(image: self)
        var layer = CALayer()
        layer = imageView.layer
        
        layer.masksToBounds = true
    
        layer.cornerRadius = layer.frame.width / 2
    
      
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage!
    }
    
    func alpha(_ value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext();
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        ctx!.scaleBy(x: 1, y: -1)
        ctx!.translateBy(x: 0, y: -area.size.height)
        ctx!.setAlpha(value)
        ctx!.draw(self.cgImage!, in: area)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


