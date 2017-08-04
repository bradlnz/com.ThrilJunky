//
//  GGView.swift
//  ThrilJunky
//
//  Created by Lietz on 8/10/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import AVFoundation
import AsyncDisplayKit

class GGView: UIView {
    
    var draggableView:DraggableView!
    var videoNode : ASVideoNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("InitGGView")
        self.backgroundColor = UIColor.clearColor()
        self.loadDraggableCustomView()
    }
    
    func loadDraggableCustomView(){
        
       
        self.videoNode = ASVideoNode()
        self.draggableView = DraggableView()
        self.draggableView.backgroundColor = UIColor.clearColor()
        self.draggableView.frame = CGRectMake(30, 0, 260, 300)
    
        
        let height = draggableView.frame.size.height
        let width = draggableView.frame.size.width
        
        
        SingletonData.staticInstance.setVideoFrameWidth(width)
        SingletonData.staticInstance.setVideoFrameHeight(height)
        

        let link =  SingletonData.staticInstance.selectedVideoItem
        
     
        if link != nil {
            let asset = AVAsset(URL: NSURL(string: link!)!)
            
            let origin = CGPointZero
            let size = CGSize(width: SingletonData.staticInstance.videoFrameWidth!, height: SingletonData.staticInstance.videoFrameHeight!)
            
            
            self.videoNode.asset = asset
            self.videoNode.shouldAutorepeat = false
            self.videoNode.muted = true
            self.videoNode.frame = CGRect(origin: origin, size: size)
            self.videoNode.gravity = AVLayerVideoGravityResizeAspectFill
            self.videoNode.shouldAutoplay = false
            self.videoNode.zPosition = 1
         
            self.draggableView.addSubview(self.videoNode.view)
            addSubview(self.draggableView)
        }
    }
    
    func layoutSubViews()
    {
        super.layoutSubviews()
        self.draggableView.frame = CGRectMake(60, 60, 200, 260)
    }
    

}
