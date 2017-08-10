//
//  RegisterViewController.swift
//  Dev
//
//  Created by Brad Lietz on 20/01/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics
//import Answers
//import PKHUD
//import SCLAlertView


class RegisterViewController: UIViewController {



    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func registerUser(_ sender: AnyObject) {
         // SwiftSpinner.show("")
        if firstName.text != "" && lastName.text != "" && passwordField.text != "" && emailAddress.text != ""
        {
              //  HUD.show(.progress)
            
            FIRAuth.auth()?.createUser(withEmail: emailAddress.text!, password: passwordField.text!, completion: { (user: FIRUser?, error: Error?) in
                if let user = user {
                    let changeRequest = user.profileChangeRequest()
                    
                    changeRequest.displayName = self.firstName.text! + " " + self.lastName.text!
                    
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print(error)
                         //   HUD.show(.error)
                         //   HUD.hide()
                        } else {
                            Answers.logSignUp(withMethod: "Signed up",
                                                        success: true,
                                                        customAttributes: [
                                                            "First name": self.firstName.text!,
                                                            "Last name": self.lastName.text!,
                                                            "Email address": self.emailAddress.text!
                                ])
                          //  HUD.hide()
                            self.goToHomeView()
                        }
                    }
                } else {
                   // HUD.show(.error)
                   // HUD.hide()
                }
 
            })
           
        }
         else {
            let alertController = UIAlertController(title: "Fields Error", message: "Please insert all of the required fields.", preferredStyle: .alert)
            
            // Initialize Actions
            let  okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                print("The user is okay.")
                
            }
            alertController.addAction(okAction)
            
            
           // Present Alert Controller
           self.present(alertController, animated: true, completion: nil)
                
            

           // let alertView = SCLAlertView()
           // alertView.showCloseButton = true
           // let errorString = "Please insert all of the required fields."
           // alertView.showError("Registration Failed", subTitle: errorString)
        }

    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    func goToHomeView(){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Now")
        self.present(viewController, animated: true, completion: nil)
    }

     func dismissKeyboard() {
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
