//
//  categoryController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 10/05/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit



class CategoryController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var activityCategories : [String]?
      @IBOutlet weak var collectionView: UICollectionView!
    
   // var categories : String[[[]]] = ["Indoor Sports" ["Ball Sports" ["Basketball", "Indoor Soccer", ""]], "Outdoor Sports", "Extreme Activities", "Water Sports", "Night Life", "Day Life", "Groups/Teams"]
    
    var images = [UIImage(named: "IndoorActivities"),
                  UIImage(named: "OutdoorActivities"),
                  UIImage(named: "FoodDining"),
                  UIImage(named: "Nightlife"),
                  UIImage(named: "Events"),
                  UIImage(named: "sightseeingIcon")]
    
    var categories: [String] = ["Indoor Activities",
                                "Outdoor Activities",
                                "Food & Dining",
                                "Nightlife",
                                "Events",
                                "Other"]
    
   
            
    override func viewWillAppear(_ animated: Bool) {
        
   
        
        if SingletonData.staticInstance.businessTagged == nil {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "businessInfo")
        self.present(viewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {

        
        
      UIApplication.shared.isStatusBarHidden = false
      self.collectionView.delegate = self
      self.collectionView.dataSource = self
        self.activityCategories = self.categories
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          if self.activityCategories!.count > 0 {
             return activityCategories!.count
          }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var cat = self.categories[(indexPath as NSIndexPath).row]

        switch(cat){
            case "Indoor Activities":
                cat = "IndoorActivities"
            break
            case "Outdoor Activities":
                cat = "OutdoorActivities"
            break
            case "Food & Dining":
                cat = "FoodDining"
            break
            default:
            break
        }
       
        
        SingletonData.staticInstance.setActivityCategory(cat)
        
     //   self.dismissViewControllerAnimated(true, completion:  nil)
        
    }
    
    @IBAction func postVideo(_ sender: AnyObject) {
        
         self.dismiss(animated: true) {
           
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.textLabelInCell.text = nil
        cell.imageViewInCell.image = nil
        
        
        for (i, item) in self.activityCategories!.enumerated() {
            if (indexPath as NSIndexPath).row == i {
                cell.imageViewInCell.image = self.images[(indexPath as NSIndexPath).row]
                    cell.textLabelInCell.text = item
                    return cell
            }
        }
      
         return cell
       
        }
    
    }

