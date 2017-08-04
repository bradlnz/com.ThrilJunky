////
////  Clarifai.swift
////  ThrilJunky
////
////  Created by Brad Lietz on 16/03/2016.
////  Copyright © 2016 ThrilJunky LLC. All rights reserved.
////
//
//import UIKit
//import AFNetworking
////import SwiftHTTP
////import JSONJoy
//
//let clarifaiClientId = "vs9eZ021aicoeKJRA7AEL0VagYfDIdfwanCdXMkd"
//let clarifaiClientSecret = "kPW0A05l09GQKvdgDheIEwyDT34YW3YvCw-12tgn"
//let clarifaiToken = "uMNCtyG1rPDbXyWERvQXqJJ49KbKXg"
//
// class ClarifaiClient {
//
//    static var staticInstance = ClarifaiClient()
//    var retData : [String]?
//    
//    func getJSON(_ urlToRequest: String) -> Data{
//        return (try! Data(contentsOf: URL(string: urlToRequest)!))
//    }
//    
//    func parseJSON(_ inputData: Data) -> NSDictionary?{
//         let dictionary: NSDictionary
//        do{
//            dictionary = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//            
//            return dictionary
//        } catch{
//           return nil
//        }
//    }
//    
//    func retrieveTags(_ url: String?) -> String?
//    {
//      
//            let urlEncoded = url
//            let reqUrl = "https://api.clarifai.com/v1/tag/?url=" + urlEncoded! + "&access_token=uMNCtyG1rPDbXyWERvQXqJJ49KbKXg"
//            let json = getJSON(reqUrl)
//          
//            
//          return String(data: json, encoding: String.Encoding.utf8)
//     
//    }
//}
