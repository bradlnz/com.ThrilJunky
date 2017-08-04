//
//  PlayerViewController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 18/02/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: AVPlayerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
    UIApplication.shared.isStatusBarHidden = true
        
    }
    
    
    
    func buttonAction(_ sender: UIButton!){
        self.dismiss(animated: true) { () -> Void in
         
            self.removeFromParentViewController()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.pause()
    }
    
    
    deinit{
        print("De init av player")
    }

}
