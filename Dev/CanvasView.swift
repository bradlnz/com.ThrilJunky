import Foundation

class CanvasView : UIImageView {
    var location = CGPoint.zero
    weak var delegate: ViewController?
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        delegate?.touchesBegan(touch)
        location = touch.location(in: self)
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        let currentLocation: CGPoint? = touch?.location(in: self)
        delegate?.touchesMoved(touch!)
        UIGraphicsBeginImageContext(frame.size)
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        self.image?.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(frame.size.width), height: CGFloat(frame.size.height)))
        //CGContextSetLineCap(ctx, kCGLineCapRound)
        ctx.setLineWidth(CGFloat(3.0))
        ctx.setStrokeColor(UIColor.blue.withAlphaComponent(0.7).cgColor)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: CGFloat(location.x), y: CGFloat(location.y)))
        ctx.addLine(to: CGPoint(x: CGFloat(currentLocation!.x), y: CGFloat(currentLocation!.y)))
        ctx.strokePath()
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        location = currentLocation!
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        let currentLocation: CGPoint? = touch?.location(in: self)
        delegate?.touchesEnded(touch!)
        UIGraphicsBeginImageContext(frame.size)
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        self.image?.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(frame.size.width), height: CGFloat(frame.size.height)))
        //CGContextSetLineCap(ctx, kCGLineCapRound)
        ctx.setLineWidth(CGFloat(3.0))
        ctx.setStrokeColor(UIColor.blue.withAlphaComponent(0.7).cgColor)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: CGFloat(location.x), y: CGFloat(location.y)))
        ctx.addLine(to: CGPoint(x: CGFloat(currentLocation!.x), y: CGFloat(currentLocation!.y)))
        ctx.strokePath()
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        location = currentLocation!
    }
 
}
