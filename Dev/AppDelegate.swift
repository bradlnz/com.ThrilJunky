//
//  AppDelegate.swift
//  Dev
//
//  Created by Brad Lietz on 10/01/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
//import SwiftHTTP
//import JSONJoy
import UberRides
import OAuthSwift
import MapKit
import ReachabilitySwift
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import SlideMenuControllerSwift
import GoogleMaps
import GooglePlaces
import Rollbar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    var reachability: Reachability? = nil
    
   
//    // The callback to handle data message received via FCM for devices running iOS 10 or above.
//    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
//        print(remoteMessage.appData)
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
    
        GMSServices.provideAPIKey("AIzaSyB1CfDdCqRr4Xx6lBVNCcXigG1lWA1MJiI")
        GMSPlacesClient.provideAPIKey("AIzaSyDx-_HkMZEHQEoZLt66laEsTfeGx2I4irc")
        Rollbar.initWithAccessToken("bb83b1fe28104a30ba16deb2427f7c23")
//
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//            // For iOS 10 data message (sent via FCM
//            FIRMessaging.messaging().remoteMessageDelegate = self
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
//
       
      //  FIRDatabase.database().persistenceEnabled = true
       
      //  UIApplication.shared.isStatusBarHidden = true
        //UIApplication.shared.statusBarStyle = UIStatusBarStyle.
        
        UINavigationBar.appearance().tintColor = UIColor.black
        
        //UINavigationBar.appearance().barTintColor = uicolorFromHex(0xFFFFFF)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
//        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//            print("TEST")
//
//        }
        
//        var colors = [UIColor]()
//     
//       
//        colors.append(uicolorFromHex(0x00c6ff))
//   colors.append(uicolorFromHex(0x0072ff))
//            UINavigationBar.appearance().setGradientBackground(colors: colors)
//        
            //  GMSServices.provideAPIKey("AIzaSyAF_DWfU5iYBKnfUBYYoMZ1eB2_Dk8oNV8")
       
 
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

    
        
      //  RidesClient.sharedInstance.configureClientID("KAY4uD_Hmlm--y1wJZvF7O_jVEk-UgZz")
              
       reachability = Reachability()
        
        reachability!.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        reachability!.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                print("Not reachable")
            }
        }
        
        do {
            try reachability!.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        return true
    }
    
   
//    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
//        if (url.host == "oauth-callback") {
//            OAuthSwift.handleOpenURL(url)
//        }
//        
//        return true
//    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      
               if (url.host == "oauth-callback") {
                   OAuthSwift.handle(url: url)
               }
        
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                open: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
        
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
      
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        
    }
    
    override init(){
         FIRApp.configure()
    }
}

