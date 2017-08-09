//
//  ContainerViewController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 21/12/16.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import Foundation
import SlideMenuControllerSwift

class ContainerViewController: SlideMenuController {
    
    override func awakeFromNib() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Main") {
            self.mainViewController = controller
        }
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Left") {
            self.leftViewController = controller
        }
        super.awakeFromNib()
    }
    
}
