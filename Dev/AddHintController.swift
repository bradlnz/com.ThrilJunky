//
//  AddHintController.swift
//  ThrilJunky
//
//  Created by Lietz on 6/07/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

class AddHintController: UIViewController, UITextViewDelegate{

    
    @IBOutlet weak var addAHintTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.addAHintTextView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textViewDidBeginEditing(textView: UITextView) {
        print("Begin Editing")
    }
    
    func textViewDidChange(textView: UITextView) {
         textView.resolveHashTags()
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
