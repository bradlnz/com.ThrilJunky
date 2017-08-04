//
//  UIImageView.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 8/05/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

extension UIImageView{
    
   
    
    func makeBlurImage(_ targetImageView:UIImageView?)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        targetImageView?.addSubview(blurEffectView)
    }
   
    func asCircle() -> UIImageView?{
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
        return self
    }
    
   
        public func imageFromServerURL(urlString: String) {
            
            URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error)
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    self.image = image
                })
                
            }).resume()
        }
}
