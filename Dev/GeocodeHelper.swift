//
//  GeocodeHelper.swift
//  ThrilJunky
//
//  Created by Lietz on 12/11/16.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//


import Foundation
import CoreLocation
import MapKit
//import PKHUD
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GeocodePlace {
    var name: String?
    var address: String?
    var location: CLLocation?
}

typealias GeocodeHelperResultHandler = (_ places: [GeocodePlace]?) -> ()
private let MIN_REQUEST_DELAY = 1.0
private let MIN_QUERY_LENGTH = 2

class GeocodeHelper {
    static let shared = GeocodeHelper()
    
    var completionHandler: GeocodeHelperResultHandler?
    
    var minRequestDelay = MIN_REQUEST_DELAY
    var minQueryLength = MIN_QUERY_LENGTH
    
    fileprivate weak var lastSearch: MKLocalSearch?
    fileprivate var performBlock: PerformAfterClosure?
    fileprivate var cache = NSCache<AnyObject, AnyObject>()
    
    func decode(_ searchTerm: String, completion: @escaping GeocodeHelperResultHandler) {
        completionHandler = completion
        if searchTerm.characters.count >= minQueryLength {
            cancel()
            if let cached = cachedResult(searchTerm) {
                completeRequest(cached)
            } else {
                performBlock = performAfter(minRequestDelay, closure: {[weak self] () -> Void in
                    self?.startGeocodeSearch(searchTerm)
                    })
            }
        } else {
            completeRequest(nil)
        }
    }
    
    func cancel() {
        cancelPerformAfter(performBlock)
        lastSearch?.cancel()
    }
    
    // MARK: Private
    
    fileprivate func completeRequest(_ places: [GeocodePlace]?) {
        completionHandler?(places)
    }
    
    fileprivate func startGeocodeSearch(_ searchTerm: String) {
     //   HUD.show(.progress)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchTerm
        let search = MKLocalSearch(request: request)
        search.start { [weak self](response, error) -> Void in
            if let err = error {
                self?.didFailDecode(searchTerm, error: err as NSError!)
            } else {
                let res = (response!.mapItems as [MKMapItem]).map{$0.placemark.geocoderPlace}
                self?.didDecode(searchTerm, places: res)
             //   HUD.hide()
            }
        }
        lastSearch = search
    }
    
    fileprivate func didFailDecode(_ searchTerm: String, error: NSError!) {
        switch MKError(_nsError: error) {
            
            
        case MKError.placemarkNotFound:
            fallthrough
        case MKError.directionsNotFound:
            didDecode(searchTerm, places: nil)
        default:
            print("GeocodeHelper error decode \(searchTerm) \(error.localizedDescription)")
        }
    }
    
    fileprivate func didDecode(_ searchTerm: String, places: [GeocodePlace]?) {
        cacheResult(searchTerm, places: places)
        completeRequest(places)
    }
    
    fileprivate func cacheResult(_ searchTerm: String, places: [GeocodePlace]?) {
        let cachePlace = places == nil ? [GeocodePlace]() : places!
        cache.setObject(cachePlace as AnyObject, forKey: searchTerm as AnyObject)
    }
    
    fileprivate func cachedResult(_ searchTerm: String) -> [GeocodePlace]? {
        let cahced = cache.object(forKey: searchTerm as AnyObject) as? [GeocodePlace]
        return cahced?.count > 0 ? cahced : nil
    }
}

extension CLPlacemark {
    var geocoderPlace: GeocodePlace {
        let place = GeocodePlace()
        place.name = name
         if let addrList = addressDictionary!["FormattedAddressLines"] as? [String] {
        place.address = addrList.joined(separator: ", ")
        }
        place.location = location
        return place
    }
}
