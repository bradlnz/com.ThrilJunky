import Foundation
import AsyncDisplayKit

class MainNode: ASDisplayNode {
    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        return CGSize(width: constrainedSize.width * 0.2, height: constrainedSize.height * 0.2)
    }
 }
