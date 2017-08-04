//
//  ActivityPlayer.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 6/02/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

protocol errorMessageDelegate {
    func errorMessageChanged(newVal: String)
}

protocol sharedInstanceDelegate {
    func sharedInstanceChanged(newVal: Bool)
}

class ActivityPlayer: NSObject {
    var refUrl : String!
    static let sharedInstance = ActivityPlayer(refUrl)
    var instanceDelegate: sharedInstanceDelegate? = nil
   
    var sharedInstanceBool = false {
        didSet {
            if let delegate = self.instanceDelegate {
                delegate.sharedInstanceChanged(self.sharedInstanceBool)
            }
        }
    }
    
    var errorDelegate:errorMessageDelegate? = nil
    var errorMessage = "" {
        didSet {
            if let delegate = self.errorDelegate {
                delegate.errorMessageChanged(self.errorMessage)
            }
        }
    }
    
   
    private var player = AVPlayer()
    private var playerItem = AVPlayerItem?()
    private var isPlaying = false
    
    init(refUrl: String) {
      
        errorMessage = ""
        
        let asset: AVURLAsset = AVURLAsset(URL: NSURL(string: refUrl)!, options: nil)
        
        let statusKey = "tracks"
        
        asset.loadValuesAsynchronouslyForKeys([statusKey], completionHandler: {
            var error: NSError? = nil
            
            dispatch_async(dispatch_get_main_queue(), {
                let status: AVKeyValueStatus = asset.statusOfValueForKey(statusKey, error: &error)
                
                if status == AVKeyValueStatus.Loaded{
                    
                    let playerItem = AVPlayerItem(asset: asset)
                    
                    self.player = AVPlayer(playerItem: playerItem)
                    self.sharedInstanceBool = true
                    
                } else {
                    self.errorMessage = error!.localizedDescription
                    print(error!)
                }
                
            })
            
            
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVPlayerItemFailedToPlayToEndTimeNotification,
            object: nil,
            queue: nil,
            usingBlock: { notification in
                print("Status: Failed to continue")
                self.errorMessage = "Stream was interrupted"
        })
        
        print("Initializing new player")
        
    }

  
}
