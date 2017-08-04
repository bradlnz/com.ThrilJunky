//
//  GGDraggableView.swift
//  ThrilJunky
//
//  Created by Lietz on 8/10/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AsyncDisplayKit
//import Kingfisher

    let ACTION_MARGIN = CGFloat(40) //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
    let SCALE_STRENGTH = CGFloat(4) //%%% how quickly the card shrinks. Higher = slower shrinking
    let SCALE_MAX = CGFloat(0.93) //%%% upper bar for how much the card shrinks. Higher = shrinks less
    let ROTATION_MAX = CGFloat(1) //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
    let ROTATION_STRENGTH = CGFloat(100) //%%% strength of rotation. Higher = weaker rotation
    let ROTATION_ANGLE = CGFloat(M_PI/10) //%%% Higher = stronger rotation angle
    var count = 0



    class DraggableView : UIView, ASVideoNodeDelegate {
        
          static let staticInstance = DraggableView()
        
        
        var delegate: DraggableViewDelegate?
        var xFromCenter = CGFloat()
        var yFromCenter = CGFloat()
        var asset : AVAsset?
        var videoItem : RealmObject!
        var isFirst : Bool = true
        var originalPoint = CGPoint()
        var videoNode : ASVideoNode!
        
        var panGestureRecognizer = UIPanGestureRecognizer()
        var tapGestureRecognizer = UITapGestureRecognizer()
        var overlayView: OverlayView?
        var noLabel : UILabel?
        var yesLabel : UILabel?
        var dateFormatter = DateFormatter()
      
    
        var profileImage : UIImageView?
        var DisplayTitle : UILabel?
        var DisplayAddress : UILabel?
        var timeLabel : UILabel?
        var distanceLabel : UILabel?
        var profileLabel : UILabel?
        var priceLabel : UILabel?
        var poweredBy: UIImageView?
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        convenience init(frame: CGRect, video: RealmObject) {
            
            self.init(frame: frame)
            setupView()
            addGestureRecognizer()
            for item in subviews {
                item.removeFromSuperview()
            }
            self.videoNode = nil
            self.videoNode = ASVideoNode()
            self.videoNode.delegate = self
            self.videoItem = video
            let Url = URL(string: "https://project-316688844667019748.appspot.com.storage.googleapis.com/videos/" + video.videoPath)
            self.asset = AVAsset(url: Url!)
            self.setVideo(self.videoItem)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupView() {
            self.layer.cornerRadius = 0;
            self.layer.shadowRadius = 0;
            self.layer.shadowOpacity = 0.0;
            self.layer.shadowOffset = CGSize(width: 1, height: 1);
            self.backgroundColor = UIColor.clear
        }
        
    
        func addGestureRecognizer() {
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DraggableView.beingDragged(_:)))
            self.addGestureRecognizer(panGestureRecognizer)
           tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DraggableView.tapAction(_:)))
            self.addGestureRecognizer(tapGestureRecognizer)
        }
        
        
        func tapAction(_ gestureRecognizer: UITapGestureRecognizer){
//            let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
//            let blurView = UIVisualEffectView(effect: darkBlur)
//            blurView.frame =  self.bounds
//            self.addSubview(blurView)
//            self.yesLabel?.layer.zPosition = 1
//            self.noLabel?.layer.zPosition = 1
//            self.DisplayAddress?.layer.zPosition = 1
//            self.DisplayTitle?.layer.zPosition = 1
//            self.profileImage?.layer.zPosition = 1
            delegate?.cardTapped(self)
        }
        
        func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
            xFromCenter = gestureRecognizer.translation(in: self).x;
            yFromCenter = gestureRecognizer.translation(in: self).y;
            
            switch (gestureRecognizer.state) {
            case .began:
                self.originalPoint = self.center;
                break;
                
                
            case .changed:
                
   
                //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
                let rotationStrength = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
                
                //%%% degree change in radians
                let rotationAngel = (ROTATION_ANGLE * rotationStrength);
                
                //%%% amount the height changes when you move the card up to a certain point
                let scale = max(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
                
                //%%% move the object's center by center + gesture coordinate
                self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter);
                
                //%%% rotate by certain amount
                let transform = CGAffineTransform(rotationAngle: rotationAngel);
                
                //%%% scale by certain amount
                let scaleTransform = transform.scaledBy(x: scale, y: scale);
                
                //%%% apply transformations
                self.transform = scaleTransform;
                
                self.updateOverlay(xFromCenter)
                break;
            case .ended:
                afterSwipeAction()
                
                break;
            default:
                break;
            }
            
        }
        
        
        
        func afterSwipeAction() {

            if (xFromCenter > ACTION_MARGIN) {
                rightAction();
            } else if (xFromCenter < -ACTION_MARGIN){
                leftAction();
            } else {
                animateCardBack()
                
            }
            
        }
        
        func rightAction() {
            animateCardToTheRight()
            delegate?.cardSwipedRight(self)
        }
        
        func animateCardToTheRight() {
            let rightEdge = CGFloat(500)
        animateCardOutTo(rightEdge)
        }
        
        func leftAction() {
            animateCardToTheLeft()
            delegate?.cardSwipedLeft(self)
        }

        func animateCardToTheLeft() {
            let leftEdge = CGFloat(-500)
           animateCardOutTo(leftEdge)
        }
        
        func animateCardOutTo(_ edge: CGFloat) {
            let finishPoint = CGPoint(x: edge, y: 2*yFromCenter + self.originalPoint.y)
            UIView.animate(withDuration: 0.3, animations: {
                self.center = finishPoint;
                }, completion: {
                    (value: Bool) in
       
                    self.removeFromSuperview()
            })
            
        }
        
        func animateCardBack() {
            UIView.animate(withDuration: 0.3, animations: {
                self.center = self.originalPoint;
                self.transform = CGAffineTransform(rotationAngle: 0);
                self.overlayView?.alpha = 0;
                self.yesLabel?.isHidden = true
                self.noLabel?.isHidden = true
                }
            )
        }
        
        func updateOverlay(_ distance: CGFloat) {
            if (distance > 0) {
                self.yesLabel?.isHidden = false
                self.noLabel?.isHidden = true
                overlayView?.setMode(.right)
            } else {
                self.noLabel?.isHidden = false
                self.yesLabel?.isHidden = true
                overlayView?.setMode(.left)
            }
            overlayView?.alpha = min(fabs(distance)/100, 0.4)
        }
        func rightClickAction() {
            rightAction()
        }
        
        func leftClickAction() {
            leftAction()
        }
        
        func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
        func imageResize (_ image: UIImage, sizeChange:CGSize)-> UIImage{
            
            let hasAlpha = true
            let scale: CGFloat = 0.0 // Use scale factor of main screen
            
            UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
            image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            return scaledImage!
        }
        
        func setVideo(_ video: RealmObject?) {
         print(self.subviews.count)
         DispatchQueue.main.async {
            self.backgroundColor = UIColor.black
            let dateFormatter = DateFormatter()
             let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            overlayView.backgroundColor = UIColor(white: 0, alpha: 0.3)
             // self.profileImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
              self.DisplayTitle = UILabel(frame: CGRect(x: 10, y: 20, width: self.frame.width, height: 40))
              self.DisplayAddress = UILabel(frame: CGRect(x: 10, y: 50, width: self.frame.width, height: 40))
              self.timeLabel = UILabel(frame: CGRect(x: 10, y: self.frame.height - 40, width: self.frame.width, height: 40))
//            self.priceLabel = UILabel(frame: CGRect(x: 20, y: self.frame.height - 80, width: self.frame.width, height: 30))
              self.distanceLabel = UILabel(frame: CGRect(x: 10, y: self.frame.height - 60, width: self.frame.width, height: 40))
            self.poweredBy = UIImageView(image: UIImage(named: "powered_by_google_on_non_white"))
           self.poweredBy?.frame = CGRect(x: self.bounds.width - self.poweredBy!.bounds.width, y: self.bounds.height - self.poweredBy!.bounds.height, width: self.poweredBy!.bounds.width, height: self.poweredBy!.bounds.height)
            // self.profileLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 100, height: 40))

            
                    //    let TapLabel = UILabel(frame: CGRectMake(80, self.frame.height - 40, self.frame.width, 40))
            self.yesLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2 - 150) / 2, y: self.frame.height / 2, width: 150, height: 40))
            self.noLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2 - 150) / 2, y: self.frame.height / 2, width: 150, height: 40))
            
            self.yesLabel!.textColor = self.UIColorFromRGB(0xFFFFFF)
            ()
            self.yesLabel!.font = UIFont(name: "HelveticaNeue", size: 40)
            self.yesLabel!.textAlignment = NSTextAlignment.right
            self.yesLabel!.text = "YES!"
            self.yesLabel!.backgroundColor = self.UIColorFromRGB(0x74d300)
            
            self.noLabel!.textColor =  self.UIColorFromRGB(0xFFFFFF)
            self.noLabel!.font = UIFont(name: "HelveticaNeue", size: 40)
            self.noLabel!.textAlignment = NSTextAlignment.right
            self.noLabel!.text = "NOPE!"
            self.noLabel!.backgroundColor = self.UIColorFromRGB(0xdb0202)
            
            //self.profileLabel?.textColor = UIColor.white
            // self.profileLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
          //   self.profileLabel?.textAlignment = NSTextAlignment.right
            
            
             self.timeLabel?.textColor = UIColor.white
               self.timeLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
            
//            self.priceLabel?.textColor = UIColor.white
//            self.priceLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
            
             self.DisplayTitle?.textColor = UIColor.white
             self.DisplayTitle?.font = UIFont(name: "HelveticaNeue", size: 16)
             self.DisplayTitle?.numberOfLines = 5
            
             self.DisplayAddress?.textColor = UIColor.white
            self.DisplayAddress?.font = UIFont(name: "HelveticaNeue", size: 15)
             self.DisplayAddress?.numberOfLines = 5
            
             self.distanceLabel?.textColor = UIColor.white
             self.distanceLabel?.font = UIFont(name: "HelveticaNeue", size: 19)
             self.distanceLabel?.numberOfLines = 5
            
            
//
//            TapLabel.textColor = UIColor.whiteColor()
//            TapLabel.font = UIFont(name: "HelveticaNeue", size: 16)
//            TapLabel.numberOfLines = 5
//            TapLabel.text = "Tap for more Info"
            
          //  DisplayTitle.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            
           
            let height = self.frame.size.height
            let width = self.frame.size.width

            SingletonData.staticInstance.setSelectedObject(nil)
            SingletonData.staticInstance.setSelectedObject(video)
            SingletonData.staticInstance.setVideoFrameWidth(width)
            SingletonData.staticInstance.setVideoFrameHeight(height)
           
            
           
            
            let origin = CGPoint.zero
            let size = CGSize(width: SingletonData.staticInstance.videoFrameWidth!, height: SingletonData.staticInstance.videoFrameHeight!)
            
            self.videoNode.asset = self.asset
            self.videoNode.shouldAutorepeat = true
            self.videoNode.muted = false
            self.videoNode.frame = CGRect(origin: origin, size: size)
            self.videoNode.gravity = AVLayerVideoGravityResizeAspectFill
            self.videoNode.zPosition = 0
            self.videoNode.shouldAutoplay = true
        
            
            self.videoNode.url = URL(string: video!.imagePath)!
            self.videoNode.layer.shouldRasterize = true
            self.videoNode.layer.borderColor = UIColor.clear.cgColor
            if video != nil {
                
                SingletonData.staticInstance.setKey(video!.key)
                
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
               dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                let date = dateFormatter.date(from: video!.createdAt)
                if(date != nil){
                self.timeLabel?.text = SingletonData.staticInstance.timeAgoSinceDate(date!, numericDates: true)
                }
               self.profileLabel?.text = video?.displayName
                let divisor = pow(10.0, Double(2))
              
         //       let distance : String = String(describing:  round(Double((1000 * (video!.distanceFromLoc) / 1000)) * divisor) / divisor)
             //    self.distanceLabel?.text = distance + "mi"
                 self.DisplayTitle?.text = video?.displayTitle
                 self.DisplayAddress?.text = video?.address
                // self.priceLabel?.text = "Cheap"
             //   let url = URL(string: video!.userPhoto)
               
              //   self.profileImage?.asCircle()
                
               // let processor = ResizingImageProcessor(targetSize: CGSize(width: 40, height: 40))
              //   let imgPlaceholder = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
               // imgPlaceholder.image = UIImage(named: "placeholder-person")!
               // imgPlaceholder.asCircle()
              //   self.profileImage?.kf.setImage(with: url, placeholder: imgPlaceholder.image, options: [.processor(processor)], progressBlock: nil, completionHandler: nil)
                
              
            }

     
            
            if(video?.createdAt != nil){
                self.addSubview(self.videoNode.view)
                if(video!.createdAt == ""){
                    self.addSubview(self.poweredBy!)
                }
                
                self.addSubview(overlayView)
                self.addSubview(self.timeLabel!)
               // self.addSubview(self.priceLabel!)
               // self.addSubview(self.profileLabel!)
                self.addSubview(self.distanceLabel!)
                self.addSubview(self.DisplayTitle!)
                  self.addSubview(self.DisplayAddress!)
              //  self.addSubview(self.profileImage!)
                //  self.addSubview(TapLabel)
                self.addSubview(self.yesLabel!)
                self.addSubview(self.noLabel!)
             
                 self.profileImage?.translatesAutoresizingMaskIntoConstraints = false
                 self.profileImage?.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
                 self.profileImage?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
                
//                 self.profileLabel?.translatesAutoresizingMaskIntoConstraints = false
//                 self.profileLabel?.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//                 self.profileLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 65).isActive = true
//                
                 self.DisplayTitle?.translatesAutoresizingMaskIntoConstraints = false
                 self.DisplayTitle?.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
                 self.DisplayTitle?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
                
                
                self.yesLabel?.isHidden = true
                self.noLabel?.isHidden = true
            }
            }
           
        }
        
        
        func videoPlaybackDidFinish(_ videoNode: ASVideoNode) {
            print("video finished")
        }
        
        func videoNode(_ videoNode: ASVideoNode, willChange state: ASVideoNodePlayerState, to toState: ASVideoNodePlayerState) {
            switch toState {
            case ASVideoNodePlayerState.paused:
             print("video paused")
            
            default: break
            }
        }
    
        
        deinit {
            print("deinit drag view")
        }
        
    }



protocol DraggableViewDelegate {
    func cardTapped(_ card: DraggableView)
    func cardSwipedLeft(_ card: DraggableView)
    func cardSwipedRight(_ card: DraggableView)
}
