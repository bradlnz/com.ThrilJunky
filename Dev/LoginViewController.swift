//
//  LoginViewController.swift
//  Dev
//
//  Created by Brad Lietz on 20/01/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
//import SCLAlertView
//import SwiftHTTP//
//import JSONJoy

import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Photos
import PKHUD
class LoginViewController: UIViewController, ForgotPasswordDelegate, FBSDKLoginButtonDelegate, CLLocationManagerDelegate {


//    struct Data : JSONJoy {
//        var url : String?
//        init(_ decoder: JSONDecoder) throws {
//            url = try decoder["Location"].getString()
//        }
//    }

   // @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginWithFacebook: UIView!

    let locationManager = CLLocationManager()
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
    var blurEffectView : UIVisualEffectView?
    var myLoginButton: FBSDKLoginButton! = FBSDKLoginButton()
    var cameraChecked : Bool = false
    var photosChecked : Bool = false
    var microphoneChecked : Bool = false
    var locationChecked : Bool = false
    
    
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(_ sender: Any) {
        HUD.show(.progress)
        
        Auth.auth().signIn(withEmail: emailAddress.text!, password: password.text!) { (user, error) in
            if user != nil {
                HUD.hide()
                self.goToHomeView()
            }
            
            if error != nil {
                HUD.show(.error)
                HUD.hide()
            }
        }
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        DispatchQueue.main.async{
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "forgotPassword") as! ForgottenPasswordViewController
            
            viewController.delegate = self
            
            
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: true, completion: nil)
        }
    }
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
     
                if error != nil {
                      HUD.show(.error)
                      HUD.hide()
                }
                else {
        
            if let accessToken = FBSDKAccessToken.current(){
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        
                Auth.auth().signIn(with: credential) { (user, error) in
                     HUD.show(.progress)
        
                       }
                    }
                }
        
                if ((error) != nil)
                {
                    // Process error
                    HUD.show(.error)
                    HUD.hide()
                }
                else if result.isCancelled {
                    // Handle cancellations
                }
                else {
                    // If you ask for multiple permissions at once, you
                    // should check if specific permissions missing
                    if result.grantedPermissions.contains("email")
                    {
                        // Do work
                      
                    }
                }
    }
    
 
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
   

    
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
//       
//        
//        if error != nil {
//            print(error?.localizedDescription)
//        
//        }
//        else {
//            
//    if let accessToken = FBSDKAccessToken.current(){
//        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//        
//        Auth.auth()?.signIn(with: credential) { (user, error) in
//             HUD.show(.progress)
//            
//               }
//            }
//        }
//        
//        if ((error) != nil)
//        {
//            // Process error
//        }
//        else if result.isCancelled {
//            // Handle cancellations
//        }
//        else {
//            // If you ask for multiple permissions at once, you
//            // should check if specific permissions missing
//            if result.grantedPermissions.contains("email")
//            {
//                // Do work
//            }
//        }
//    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    

    
    func returnToHome(input: Bool) {
        
        if(input == true){
            let alertController = UIAlertController(title: "An Error occured", message: "Something went wrong, please try again.",  preferredStyle: .alert)
            
            // Initialize Actions
            let  okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                print("The user is okay.")
                
            }
            alertController.addAction(okAction)
            
            // Present Alert Controller
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        if(input == false){
            let alertController = UIAlertController(title: "Forgotten Password Sent", message: "A link to reset your password has been sent to your email address linked to your ThrilJunky account.", preferredStyle: .alert)
            
            // Initialize Actions
            let  okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                print("The user is okay.")
                
            }
            alertController.addAction(okAction)
            
            // Present Alert Controller
            self.present(alertController, animated: true, completion: nil)
            
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {

              
        self.myLoginButton.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - 213 / 2, y: 0, width: 213, height: 50)
        self.loginWithFacebook.addSubview(self.myLoginButton)
        // Handle clicks on the button
        
        
        checkLocationPermission()
        
        
  
        Auth.auth().addStateDidChangeListener({ (auth: Auth, user: User?) in
            
            user?.reload(completion: { (error) in
             
                if(error != nil){
                       HUD.show(.error)
                       HUD.hide()
                } else {
                    if let accessToken = FBSDKAccessToken.current(){
                        print(accessToken)
                        HUD.hide()
                              if(self.cameraChecked && self.photosChecked && self.microphoneChecked){
                        
                        self.goToHomeView()
                        }
                    }
                }

            })
         
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.myLoginButton.delegate = self
        self.myLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
      //  scrollView.contentSize.height = view.bounds.height + 10
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    
    func checkLocationPermission(){
      
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        if self.locationManager.location != nil {
            self.locationChecked = true
            SingletonData.staticInstance.setLocation(self.locationManager.location)
        
        }

    }
    func checkMicrophonePermission(){
        let microPhoneStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        
        switch microPhoneStatus {
        case .authorized:
            self.microphoneChecked = true
            
            break
        // Has access
        case .denied:
             self.microphoneChecked = false
            break
        // No access granted
        case .restricted:
             self.microphoneChecked = false
            break
        // Microphone disabled in settings
        case .notDetermined:
             self.microphoneChecked = true
             AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted: Bool) in
                if granted == true
                {
                    // User granted
                    self.microphoneChecked = true
                    
                }
                else
                {
                    
                    self.cameraChecked = false
                    
                }
             })
            break
            // Didn't request access yet
        }
    }
    
    func checkPhotoLibraryPermission()  {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
           self.photosChecked = true
           if(self.photosChecked){
            checkCameraPermissions()
           }
            break
        //handle authorized status
        case .denied, .restricted :
            self.photosChecked = false
            break
        //handle denied status
        case .notDetermined:
            
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                     self.photosChecked = true
                     if(self.photosChecked){
                        self.checkCameraPermissions()
                     }
                    break
                // as above
                case .denied, .restricted:
                     self.photosChecked = false
                    break
                // as above
                case .notDetermined:
                     self.photosChecked = false
                    break
                    // won't happen but still
                }
            }
            break
        }
    }
    
    func checkCameraPermissions() {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized
        {
            // Already Authorized
            self.cameraChecked = true
         
            if(self.cameraChecked){
                checkMicrophonePermission()
            }
        }
        else
        {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted :Bool) -> Void in
                if granted == true
                {
                    // User granted
                    self.cameraChecked = true
                    
                    if(self.cameraChecked){
                        self.checkMicrophonePermission()
                    }
                }
                else
                {
                
                    self.cameraChecked = false
                    
                }
            });
        }
    }
    
    func goToHomeView(){
        DispatchQueue.main.async{
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Now")
        self.present(viewController, animated: true, completion: nil)
        }
    }

    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                
                break
                
            case .authorizedAlways, .authorizedWhenInUse:
                if self.locationManager.location != nil {
                    self.locationManager.startUpdatingLocation()
                    SingletonData.staticInstance.setLocation(self.locationManager.location)
                    self.locationChecked = true
                    
                    if(self.locationChecked){
                        checkPhotoLibraryPermission()
                    }
                }
                break
            }
            
        } else {
            print("Location services are not enabled")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            SingletonData.staticInstance.setLocation(location)
        }
        
    }

    
}
