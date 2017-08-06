//
//  ArMapViewController.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 17/7/17.
//  Copyright © 2017 ThrilJunky LLC. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Realm
import RealmSwift

class ArMapViewController: UIViewController {
    
    var realm : Realm! = nil
    var places = [Place]()
    fileprivate let locationManager = CLLocationManager()
    var arViewController: ARViewController!
    
    
    
    override func viewDidLoad() {
        
            
    }
}

extension ArMapViewController: CLLocationManagerDelegate {
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            let location = locations.last!
            if location.horizontalAccuracy < 100 {
                manager.stopUpdatingLocation()
                
            }
        }
    }
}

extension ArMapViewController: ARDataSource {
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        
        return annotationView
    }
}

extension ArMapViewController: AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView) {
        if let annotation = annotationView.annotation as? Place {
            
            
        }
    }
}

