//
//  OverlayViewContent.swift
//  ThrilJunky
//
//  Created by Lietz on 1/10/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class OverlayViewContent: ASDisplayNode {

    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        return CGSize(width: constrainedSize.width * 0.2, height: constrainedSize.height * 0.2)
    }
    

}
