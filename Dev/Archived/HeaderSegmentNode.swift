//
//  HeaderSegmentNode.swift
//  ThrilJunky
//
//  Created by Lietz on 28/09/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import Foundation
import AsyncDisplayKit

final class HeaderSegmentNode: ASCellNode {
    
    fileprivate let title: String
    fileprivate let textNode = ASTextNode()
    
    init(title: String) {
        self.title = title
        
        super.init()
        
        self.textNode.attributedText = attributedTitle()
        self.addSubnode(textNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 10.0, right: 10.0), child: textNode)
    
        return insetSpec
    }
    
    fileprivate func attributedTitle() -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: title)
        
        return attributedTitle
    }
    
    override func didLoad() {
        super.didLoad()
        // for debug purposes, to see that node's frame is not same as the cell's frame
        backgroundColor = UIColor.gray
    }
}
