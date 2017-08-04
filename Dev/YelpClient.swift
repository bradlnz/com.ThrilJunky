////
////  YelpClient.swift
////  Yelp
////
////  Created by Timothy Lee on 9/19/14.
////  Copyright (c) 2014 Timothy Lee. All rights reserved.
////
//
//import UIKit
//import AFNetworking
//import BDBOAuth1Manager
//
//// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
//let yelpConsumerKey = "vuN6V17h7SsUoGXG2JSORg"
//let yelpConsumerSecret = "D-R_vsI-EyvdjTR6ooB_OcDq9Aw"
//let yelpToken = "bgI0xdIdlzxk9Rm0F5jLpe6-4qU3eHpg"
//let yelpTokenSecret = "nfInJE7H5scNDVhDEhYj0MRF5Ss"
//
//enum YelpSortMode: Int {
//    case bestMatched = 0, distance, highestRated
//}
//
//class YelpClient: BDBOAuth1RequestOperationManager {
//    private static var __once: () = {
//            Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
//        }()
//    var accessToken: String!
//    var accessSecret: String!
//    
//    class var sharedInstance : YelpClient {
//        struct Static {
//            static var token : Int = 0
//            static var instance : YelpClient? = nil
//        }
//        
//        _ = YelpClient.__once
//        return Static.instance!
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
//        self.accessToken = accessToken
//        self.accessSecret = accessSecret
//        let baseUrl = URL(string: "https://api.yelp.com/v2/")
//        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
//        
//        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
//        self.requestSerializer.saveAccessToken(token)
//    }
//    
//    func searchWithTerm(_ term: String, location: String, completion: @escaping ([Business]?, NSError?) -> Void) -> AFHTTPRequestOperation {
//        return searchWithTerm(term, sort: nil, location: location, categories: nil, deals: nil, completion: completion)
//    }
//    
//    func searchWithTerm(_ term: String, sort: YelpSortMode?, location: String, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, NSError?) -> Void) -> AFHTTPRequestOperation {
//        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
//        
//        // Default the location to San Francisco
//        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": location as AnyObject]
//        
//        if sort != nil {
//            parameters["sort"] = sort!.rawValue as AnyObject?
//        }
//        
//        if categories != nil && categories!.count > 0 {
//            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
//        }
//        
//        if deals != nil {
//            parameters["deals_filter"] = deals! as AnyObject?
//        }
//        
//        print(parameters)
//        
//        return self.get("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            let dictionaries = response["businesses"] as? [NSDictionary]
//            if dictionaries != nil {
//                completion(Business.businesses(array: dictionaries!), nil)
//            }
//            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
//                completion(nil, error)
//        })!
//    }
//}
