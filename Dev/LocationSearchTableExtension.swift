//
//  LocationSearchTableExtension.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 21/05/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit
import MapKit

extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return matchingItems.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            let selectedItem = matchingItems[(indexPath as NSIndexPath).row].placemark
            cell.textLabel?.text = selectedItem.name
            cell.detailTextLabel?.text = parseAddress(selectedItem)
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let cell = tableView.cellForRow(at: indexPath)
         
        if(cell?.detailTextLabel?.text != "  "){
        searchMap(cell?.detailTextLabel?.text)
        }
        else{
           searchMap(cell?.textLabel?.text)
        }
    }
    
  func searchMap(_ input : String?){
    
     DispatchQueue.main.async {
      let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(input!) { (placemarks, error) -> Void in
            
            if error != nil {
               
            } else {
                if placemarks!.count > 0 {
                    let placemark = placemarks![0] as CLPlacemark
                    let location = placemark.location
                    
                    
                    self.view.endEditing(true)
                    self.tabBarController?.tabBar.isHidden = false
                    let center = location!.coordinate
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                    
                    self.mapView!.setRegion(region, animated: true)
                     self.tableView.reloadData()
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        } 
    }
}
}
