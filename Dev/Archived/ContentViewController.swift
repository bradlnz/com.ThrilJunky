//
//  ContentViewController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 25/04/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var screenshotImage: UIImageView!
    
    var imageFile: String!
    var titleText: String!
    var screenshot: String!
    var pageIndex: Int!
    var subTitleSet: Bool!
    var continueButtonSet: Bool!
    var screenshotHidden: Bool!
    
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.previewImage.image = UIImage(named: self.imageFile)
        self.previewImage.makeBlurImage(self.previewImage)
        self.screenshotImage.image = UIImage(named: screenshot)
        self.titleLabel?.text = self.titleText
        print(subTitleSet)
        self.subTitle?.isHidden = subTitleSet
        self.continueBtn?.isHidden = continueButtonSet
        self.screenshotImage.isHidden = screenshotHidden
    }
    
    
    @IBAction func continueAction(_ sender: AnyObject) {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController")
        self.present(viewController, animated: true, completion: nil)
        
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
