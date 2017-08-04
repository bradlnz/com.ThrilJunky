//
//  IntroScreenController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 1/04/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import Firebase
class IntroScreenController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var images = [String]()
    var titles = [String]()
    var descs = [String]()
   
    
    override func viewWillAppear(_ animated: Bool) {
        
             images.append("find")
             titles.append("Find")
             descs.append("AWESOME ACTIVITIES NEAR YOU")
         images.append("share")
        titles.append("Share")
           descs.append("YOUR EXPERIENCES WITH OTHERS")
  
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
 
        tableView.rowHeight = (UIScreen.main.bounds.height / 2)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IntroScreenCell
      
        cell.imgView.image = UIImage(named: images[(indexPath as NSIndexPath).row])
        cell.textVal.setTitle(titles[(indexPath as NSIndexPath).row], for: UIControlState())
        cell.desc.text = descs[(indexPath as NSIndexPath).row]
        switch (titles[(indexPath as NSIndexPath).row]){
            case "Find":
                cell.textVal.addTarget(self, action: #selector(IntroScreenController.Find_Clicked(_:)), for: UIControlEvents.touchUpInside)
            break
        case "Share":
            cell.textVal.addTarget(self, action: #selector(IntroScreenController.Share_Clicked(_:)), for: UIControlEvents.touchUpInside)
            break
        default:
            break
        }

        return cell
    }
    
    @objc func Find_Clicked(_ sender:UIButton)
    {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Now")
        self.present(viewController, animated: true, completion: nil)
    }
    @objc func Share_Clicked(_ sender:UIButton)
    {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Share")
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)

    }
    // Change the ratio or enter a fixed value, whatever you need
    var cellHeight: CGFloat {
        return tableView.frame.width * 9 / 16
    }
    
    // Just an alias to make the code easier to read
    var imageVisibleHeight: CGFloat {
        return cellHeight
    }
    
    // Change this value to whatever you like (it sets how "fast" the image moves when you scroll)
    let parallaxOffsetSpeed: CGFloat = 25
    
    // This just makes sure that whatever the design is, there's enough image to be displayed, I let it up to you to figure out the details, but it's not a magic formula don't worry :)
    var parallaxImageHeight: CGFloat {
        let maxOffset = (sqrt(pow(cellHeight, 2) + 4 * parallaxOffsetSpeed * tableView.frame.height) - cellHeight) / 2
        return imageVisibleHeight + maxOffset
    }
    
    // Used when the table dequeues a cell, or when it scrolls
    func parallaxOffsetFor(_ newOffsetY: CGFloat, cell: UITableViewCell) -> CGFloat {
        return ((newOffsetY - cell.frame.origin.y) / parallaxImageHeight) * parallaxOffsetSpeed
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        print("deinit")
    }
}
