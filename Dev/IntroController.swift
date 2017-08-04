//
//  IntroController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 23/6/17.
//  Copyright © 2017 ThrilJunky LLC. All rights reserved.
//

import Foundation


class IntroController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var modalBackground: UIView!
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        self.dismiss(animated: false, completion:  nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IntroController.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        modalBackground.addGestureRecognizer(gestureRecognizer)
      
    }
    @IBAction func beginDismiss(_ sender: Any) {
                self.dismiss(animated: false, completion:  nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
