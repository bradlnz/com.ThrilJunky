////
////  FactualClient.swift
////  ThrilJunky
////
////  Created by Brad Lietz on 2/04/2016.
////  Copyright © 2016 ThrilJunky LLC. All rights reserved.
////
//
//import UIKit
//import AFNetworking
////import SwiftHTTP
////import JSONJoy
//import OAuthSwift
//class FactualClient : NSObject {
//    
//    let apiConsoleInfo : OAuthSwiftClient?
//    override init() {
//      apiConsoleInfo = OAuthSwiftClient(consumerKey : "x2Ro67ADUXJcs5gmJqVbLZuEzonD6kF2OYCMetHk", consumerSecret : "Febf7ZOlzHkuAe27FgsDP6GtzlBaG5kz2wtUgmZO")
//        super.init()
//    }
//    
//
//    func parseJSON(_ inputData: Data) -> NSDictionary?{
//        let dictionary: NSDictionary
//        do{
//            dictionary = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//            
//            return dictionary
//        } catch{
//            return nil
//        }
//    }
//    
//    
//    func authorize(){
//        
//     var req = self.apiConsoleInfo?.makeRequest("https://api.v3.factual.com/t/places?filters={\"name\":\"Stand\"}&geo={\"$circle\":{\"$center\":[34.06018, -118.41835],\"$meters\": 2500}}", method: OAuthSwiftHTTPRequest.Method.GET)
//
//        
//        self.apiConsoleInfo?.request("https://api.v3.factual.com/t/places?filters={\"name\":\"Stand\"}&geo={\"$circle\":{\"$center\":[34.06018, -118.41835],\"$meters\": 2500}}", method: OAuthSwiftHTTPRequest.Method.GET, success: { (data, response) in
//            print(data)
//            }, failure: { (error) in
//                print(error)
//        })
//      
////        apiConsoleInfo!.get("https://api.v3.factual.com/t/places?filters={\"name\":\"Stand\"}&geo={\"$circle\":{\"$center\":[34.06018, -118.41835],\"$meters\": 2500}}", success: { (data, response) -> Void in
////                     print(data)
////            }) { (error) -> Void in
////                     print(error)
////        }
//    }
//    
//    
//}
