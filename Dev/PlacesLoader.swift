import Foundation
import CoreLocation

struct PlacesLoader {
    
  func loadPOIS(location: CLLocation, radius: Int = 30, handler: @escaping (NSDictionary?, NSError?) -> Void) {
    print("Load pois")
  
  }
  
  func loadDetailInformation(forPlace: Place, handler: @escaping (NSDictionary?, NSError?) -> Void) {
    
    }
}
