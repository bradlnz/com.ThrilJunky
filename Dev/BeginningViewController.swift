//
//  BeginningViewController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 10/09/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
//import ImageSlideshow

class BeginningViewController: UIViewController  {

//    var arrayImages : [ImageSource] = [ImageSource(image: UIImage(named: "Intro1")!), ImageSource(image: UIImage(named: "Intro2")!), ImageSource(image: UIImage(named: "Intro3")!), ImageSource(image: UIImage(named: "Intro4")!), ImageSource(image: UIImage(named: "Intro5")!), ImageSource(image: UIImage(named: "Intro6")!)]
//    
//    
//    @IBOutlet weak var sliderView: ImageSlideshow!
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//  DispatchQueue.main.async{
//     self.sliderView.setImageInputs(self.arrayImages)
//    self.sliderView.slideshowInterval = 3
//    self.sliderView.contentScaleMode = UIViewContentMode.ScaleAspectFill
//    self.sliderView.circular = false
//        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func begin(_ sender: AnyObject) {
           DispatchQueue.main.async {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Now")
        self.present(viewController, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        print("deinit") // never gets called
    }
}
