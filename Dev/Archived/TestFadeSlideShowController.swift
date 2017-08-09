//
//  TestFadeSlideShowController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 11/5/17.
//  Copyright © 2017 ThrilJunky LLC. All rights reserved.
//

import Foundation
import UIKit

class TestFadeSlideShowController: UIViewController, KASlideShowDelegate {
    
    @IBOutlet weak var slideShow: KASlideShow!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        // UI
       
        
        //KASlideshow
        slideShow.delegate = self
        slideShow.delay = 1 // Delay between transitions
        slideShow.transitionDuration = 0.5 // Transition duration
        slideShow.transitionType = KASlideShowTransitionType.fade // Choose a transition type (fade or slide)
        slideShow.imagesContentMode = .scaleAspectFill // Choose a content mode for images to display
        slideShow.addImages(fromResources: ["https://1283682457.rsc.cdn77.org/-Q_et-ODXipI/V5f4gKXMUJI/AAAAAAAAC9Y/dJ8uE9HKVcszhCgnPeVbW2_DmKJsyfrLwCJkC/w1920-h1080-k/","https://1283682457.rsc.cdn77.org/-ZF4IcQJNC_g/WFtRJ48HpBI/AAAAAAAAVC0/ajgAYAtnrLwXRYv0V2cZ_YtjLo1S2WwkwCLIB/w1920-h1080-k/", "https://1283682457.rsc.cdn77.org/-kUxSylAMrpc/WDHDvTVFIII/AAAAAAAAg6I/HQVp79PHb-c4qEIQ249CERAh9PEtyZSxwCLIB/w640-h360-k/", "https://1283682457.rsc.cdn77.org/-Tjn7gWUSXks/V2sng7a529I/AAAAAAABFxI/C6RvZ2jCHZY4MeW7VQzG32L8haMNvaY4ACJkC/w640-h360-k/))", "https://1283682457.rsc.cdn77.org/-aEEa3-UxRj4/WDHDvb0QaVI/AAAAAAAAg28/8zUKJc7-pucLFmZ2lPISQ0WeVLqCWudhgCLIB/w640-h360-k/"])
        slideShow.add(KASlideShowGestureType.tap) // Gesture to go previous/next directly on the image (Tap or Swipe)
        slideShow.start()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //KASlideShow delegate
    func kaSlideShowWillShowNext(slideshow: KASlideShow) {
        NSLog("kaSlideShowWillShowNext")
    }
    
    func kaSlideShowWillShowPrevious(slideshow: KASlideShow) {
        NSLog("kaSlideShowWillShowPrevious")
    }
    
    func kaSlideShowDidShowNext(slideshow: KASlideShow) {
        NSLog("kaSlideShowDidNext")
    }
    
    func kaSlideShowDidShowPrevious(slideshow: KASlideShow) {
        NSLog("kaSlideShowDidPrevious")
    }
//          @IBAction func switchType(sender: AnyObject) {
//        let control:UISegmentedControl = sender as! UISegmentedControl
//        if control.selectedSegmentIndex == 0{
//            slideShow.transitionType = KASlideShowTransitionType.fade
//            slideShow.gestureRecognizers = nil
//            slideShow.add(KASlideShowGestureType.tap)
//        }else {
//            slideShow.transitionType = KASlideShowTransitionType.slide
//            slideShow.gestureRecognizers = nil
//            slideShow.add(KASlideShowGestureType.swipe)
//        }
    }
    
    
