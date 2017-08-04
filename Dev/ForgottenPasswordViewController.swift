//
//  ForgottenPasswordViewController.swift
//  Dev
//
//  Created by Brad Lietz on 20/01/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import Firebase

class ForgottenPasswordViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var result: UILabel!
    
    var delegate : ForgotPasswordDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailField.text!) { (error) in
            if(error != nil){
                
                self.dismiss(animated: true, completion: {
                    self.delegate?.returnToHome(input: true)
                })
                
            } else {
                
                self.dismiss(animated: true, completion: {
                    self.delegate?.returnToHome(input: false)
                })
            }
        }
    }
}
protocol ForgotPasswordDelegate {
    func returnToHome(input : Bool)
}
