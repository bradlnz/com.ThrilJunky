//
//  IntroViewController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 25/04/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import Firebase

class IntroViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController!
    var pageTitles: [String]!
    var pageImages: [String]!
    var pageScreenshots: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            
            
            if let user = user {
                // User is signed in.
                print(user.email)
                self.goToHomeView()
            } else {
                // No user is signed in.
            }
        }
        self.pageTitles = ["Find", "Share", "Explore", ""]
        self.pageImages = ["miami", "los_angeles", "new_york", "share"]
        self.pageScreenshots = ["screenshot_find", "screenshot_share", "screenshot_explore", "textNavBar"]
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? UIPageViewController
        self.pageViewController.dataSource = self
        let startVC = self.viewControllerAtIndex(0) as ContentViewController
        var viewControllers = [UIViewController]()
        viewControllers.append(startVC)
        self.pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
       // self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToHomeView(){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IntroScreen")
        self.present(viewController, animated: true, completion: nil)
    }
    
    func viewControllerAtIndex(_ index: Int) -> ContentViewController {
        
        if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)){
            return ContentViewController()
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "contentViewController") as! ContentViewController
        
        vc.imageFile = self.pageImages[index] as String?
        vc.screenshot = self.pageScreenshots[index] as String?
        vc.titleText = pageTitles[index] as String?
        vc.pageIndex = index
        vc.subTitleSet = false
        vc.continueButtonSet = true
         vc.screenshotHidden = false
        if(index == 3){
      
            vc.subTitleSet = true
            vc.continueButtonSet = false
        }
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if(index == 0 || index == NSNotFound){
            return nil
        }
        index -= 1
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if(index == NSNotFound){
            return nil
        }
        index += 1
        
        if (index == self.pageTitles.count){
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
