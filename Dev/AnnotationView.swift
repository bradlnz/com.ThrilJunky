/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

protocol AnnotationViewDelegate {
  func didTouch(annotationView: AnnotationView)
}


class AnnotationView: ARAnnotationView {
  var titleLabel: UILabel?
  var distanceLabel: UILabel?
  var delegate: AnnotationViewDelegate?
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    loadUI()
  }
  
  func loadUI() {
    titleLabel?.removeFromSuperview()
    distanceLabel?.removeFromSuperview()

    let viewLayer = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 70))
    
    viewLayer.backgroundColor = UIColor.black
    
    let label = UILabel(frame: CGRect(x: 60, y: 0, width: self.frame.size.width, height: 60))
    label.font = UIFont.systemFont(ofSize: 18)
    label.numberOfLines = 0
    label.backgroundColor = UIColor.black
    label.textColor = UIColor.white
    self.addSubview(label)
    self.titleLabel = label
    
    distanceLabel = UILabel(frame: CGRect(x: 60, y: 30, width: self.frame.size.width, height: 20))
    distanceLabel?.backgroundColor = UIColor.black
    distanceLabel?.textColor = UIColor.white
    distanceLabel?.font = UIFont.systemFont(ofSize: 12)
    
   
    
    viewLayer.addSubview(distanceLabel!)
    
    viewLayer.addSubview(titleLabel!)
    
    
    if let annotation = annotation as? Place {
      titleLabel?.text = annotation.placeName
      distanceLabel?.text = String(format: "%.2f mi", (annotation.distanceFromUser / 1000) / 1.60934)
      
     let imgView = annotation.img
        imgView?.frame = CGRect(x: 15, y: 10, width: imgView!.frame.width, height: imgView!.frame.height)
        imgView?.layer.cornerRadius = 25
        imgView?.layer.masksToBounds = true
       
        viewLayer.layer.cornerRadius = 10
        viewLayer.layer.masksToBounds = true
        
        viewLayer.layer.addSublayer(imgView!.layer)
        
        self.addSubview(viewLayer)
    }
   
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    titleLabel?.frame = CGRect(x: 80, y: 0, width: self.frame.size.width, height: 30)
    distanceLabel?.frame = CGRect(x: 80, y: 30, width: self.frame.size.width, height: 20)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    delegate?.didTouch(annotationView: self)
  }
}
