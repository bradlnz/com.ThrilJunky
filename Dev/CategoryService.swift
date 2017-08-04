////
////  CategoryService.swift
////  ThrilJunky
////
////  Created by Brad Lietz on 25/03/2016.
////  Copyright © 2016 ThrilJunky LLC. All rights reserved.
////
//
//import UIKit
//
//class CategoryService: NSObject {
//    private static var __once: () = {
//            static.instance = CategoryService()
//        }()
//    class var sharedInstance: CategoryService {
//        struct Static {
//            static var onceToken: Int = 0
//            
//            static var instance: CategoryService? = nil
//        }
//        _ = CategoryService.__once
//        return Static.instance!
//    }
//    var selectedCatItem: String?
//    
//    func setItem(_ item: String?){
//        selectedCatItem = item
//    }
//}
