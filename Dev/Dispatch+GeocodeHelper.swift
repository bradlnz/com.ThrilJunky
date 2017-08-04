//
//  Dispatch+GeocodeHelper.swift
//  ThrilJunky
//
//  Created by Lietz on 12/11/16.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import Foundation

typealias PerformAfterClosure = (_ cancel: Bool) -> ()

func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func performAfter(_ delayTime: Double, closure: @escaping ()->()) -> PerformAfterClosure? {
    
    var performClosure: PerformAfterClosure?
    
    let delayedClosure: PerformAfterClosure = { cancel in
       
            if !cancel {
                DispatchQueue.main.async(execute: closure)
            }
        
        performClosure = nil
    }
    
    performClosure = delayedClosure
    
    delay(delayTime, closure: {
        if let delayedClosure = performClosure {
            delayedClosure(false)
        }
    })
    
    return performClosure
}

func cancelPerformAfter(_ closure: PerformAfterClosure?) {
    if let uclosure = closure {
        uclosure(true)
    }
}
