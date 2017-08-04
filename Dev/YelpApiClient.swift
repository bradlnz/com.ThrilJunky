//import Foundation
//import OAuthSwift
//
//struct YelpAPIConsole {
//    var consumerKey = "vuN6V17h7SsUoGXG2JSORg"
//    var consumerSecret = "D-R_vsI-EyvdjTR6ooB_OcDq9Aw"
//    var accessToken = "bgI0xdIdlzxk9Rm0F5jLpe6-4qU3eHpg"
//    var accessTokenSecret = "nfInJE7H5scNDVhDEhYj0MRF5Ss"
//}
//
//class YelpAPIClient: NSObject {
//    
//    let APIBaseUrl = "https://api.yelp.com/v2/"
//    let clientOAuth: OAuthSwiftClient?
//    let apiConsoleInfo: YelpAPIConsole
//    
//    override init() {
//        apiConsoleInfo = YelpAPIConsole()
//        self.clientOAuth = OAuthSwiftClient(consumerKey: apiConsoleInfo.consumerKey, consumerSecret: apiConsoleInfo.consumerSecret, accessToken: apiConsoleInfo.accessToken, accessTokenSecret: apiConsoleInfo.accessTokenSecret)
//        super.init()
//    }
//    
//    /*
//     
//     searchPlacesWithParameters: Function that can search for places using any specified API parameter
//     
//     Arguments:
//     
//     searchParameters: Dictionary<String, String>, optional (See https://www.yelp.co.uk/developers/documentation/v2/search_api )
//     successSearch: success callback with data (NSData) and response (NSHTTPURLResponse) as parameters
//     failureSearch: error callback with error (NSError) as parameter
//     
//     Example:
//     
//     var parameters = ["ll": "37.788022,-122.399797", "category_filter": "burgers", "radius_filter": "3000", "sort": "0"]
//     
//     searchPlacesWithParameters(parameters, successSearch: { (data, response) -> Void in
//     println(NSString(data: data, encoding: NSUTF8StringEncoding))
//     }, failureSearch: { (error) -> Void in
//     println(error)
//     })
//     
//     
//     */
//    
//    func searchPlacesWithParameters(_ searchParameters: Dictionary<String, String>, successSearch: (_ data: Data, _ response: HTTPURLResponse) -> Void, failureSearch: (_ error: NSError) -> Void) {
//        let searchUrl = APIBaseUrl + "search/"
//        clientOAuth!.get(searchUrl, parameters: searchParameters, success: successSearch, failure: failureSearch)
//    }
//    
//    /*
//     
//     getBusinessInformationOf: Retrieve all the business data using the id of the place
//     
//     Arguments:
//     
//     businessId: String
//     localeParameters: Dictionary<String, String>, optional (See https://www.yelp.co.uk/developers/documentation/v2/business )
//     successSearch: success callback with data (NSData) and response (NSHTTPURLResponse) as parameters
//     failureSearch: error callback with error (NSError) as parameter
//     
//     Example:
//     
//     getBusinessInformationOf("custom-burger-san-francisco", successSearch: { (data, response) -> Void in
//     println(NSString(data: data, encoding: NSUTF8StringEncoding))
//     }) { (error) -> Void in
//     println(error)
//     }
//     
//     */
//    
//    func getBusinessInformationOf(_ businessId: String, localeParameters: Dictionary<String, String>? = nil, successSearch: (_ data: Data, _ response: HTTPURLResponse) -> Void, failureSearch: (_ error: NSError) -> Void) {
//        let businessInformationUrl = APIBaseUrl + "business/" + businessId
//        var parameters = localeParameters
//        if parameters == nil {
//            parameters = Dictionary<String, String>()
//        }
//        clientOAuth!.get(businessInformationUrl, parameters: parameters!, success: successSearch, failure: failureSearch)
//    }
//    
//    /*
//     
//     searchBusinessWithPhone: Search for a business using a telephone number
//     
//     Arguments:
//     
//     phoneNumber: String
//     searchParameters: Dictionary<String, String>, optional (See https://www.yelp.co.uk/developers/documentation/v2/phone_search )
//     successSearch: success callback with data (NSData) and response (NSHTTPURLResponse) as parameters
//     failureSearch: error callback with error (NSError) as parameter
//     
//     Example:
//     
//     searchBusinessWithPhone("+15555555555", successSearch: { (data, response) -> Void in
//     println(NSString(data: data, encoding: NSUTF8StringEncoding))
//     }) { (error) -> Void in
//     println(error)
//     }
//     
//     */
//    
//    func searchBusinessWithPhone(_ phoneNumber: String, searchParameters: Dictionary<String, String>? = nil, successSearch: (_ data: Data, _ response: HTTPURLResponse) -> Void, failureSearch: (_ error: NSError) -> Void) {
//        let phoneSearchUrl = APIBaseUrl + "phone_search/"
//        var parameters = searchParameters
//        if parameters == nil {
//            parameters = Dictionary<String, String>()
//        }
//        
//        parameters!["phone"] = phoneNumber
//        
//        clientOAuth!.get(phoneSearchUrl, parameters: parameters!, success: successSearch, failure: failureSearch)
//    }
//}
