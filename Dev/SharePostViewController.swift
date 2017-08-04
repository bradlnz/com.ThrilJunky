//
//  SharePostViewController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 29/06/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

class SharePostViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
     var placeholderLabel : UILabel!
    
    var images = [UIImage(named: "IndoorActivities"),
                  UIImage(named: "OutdoorActivities"),
                  UIImage(named: "FoodDining"),
                  UIImage(named: "Nightlife"),
                  UIImage(named: "Events"),
                  UIImage(named: "Other")]
    
    var categories: [String] = ["Indoor Activities",
                                "Outdoor Activities",
                                "Food & Dining",
                                "Nightlife",
                                "Events",
                                "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Add a hint.."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: textView.font!.pointSize)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        

        placeholderLabel.frame.origin = CGPoint(x: 5, y: textView.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !textView.text.isEmpty
        // Do any additional setup after loading the view.
        

    }

    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PostCollectionViewCell
        
        cell.imageView.image = self.images[(indexPath as NSIndexPath).row]
        cell.category.text =  self.categories[(indexPath as NSIndexPath).row]
        
        
        return cell
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
