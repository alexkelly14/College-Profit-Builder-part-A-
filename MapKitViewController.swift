//
//  MapKitViewController.swift
//  College Profile Builder
//
//  Created by Alexandra Kelly  on 3/8/17.
//  Copyright © 2017 Alexandra Kelly . All rights reserved.
//

import UIKit
import MapKit
class MapKitViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var college = Colleges()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            findLocation(location: college.name)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            dismiss(animated: true, completion: nil)
            findLocation(location: searchBar.text!)
        }
        func findLocation(location: String) {
            let localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = location
            let localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch.start { (localSearchResponse, error) in
                if localSearchResponse == nil {
                    let alertController = UIAlertController (title: nil, message: "Place Not Found", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                let locations = localSearchResponse!.mapItems
                if locations.count > 1 {
                    let alert = UIAlertController(title: "Select a Location", message: nil, preferredStyle: .actionSheet)
                    for location in locations {
                        let name = "\(location.placemark.name!), \(location.placemark.administrativeArea!)"
                        let locationAction = UIAlertAction(title: name, style: .default, handler: { (action) in
                            self.displayMap(placemark: location.placemark)
                        })
                        alert.addAction(locationAction)
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    self.displayMap(placemark: locations.first!.placemark)
                }
            }
        }
        func displayMap(placemark : MKPlacemark) {
            self.navigationItem.title = placemark.name
            let center = placemark.location!.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
            let region = MKCoordinateRegion(center: center, span: span)
            let pin = MKPointAnnotation()
            pin.coordinate = center
            pin.title = placemark.name
            mapView.addAnnotation(pin)
            mapView.setRegion(region, animated: true)
            
        }
        @IBAction func showSearchBar(_ sender: Any) {
            let searchContoller = UISearchController(searchResultsController: nil)
            searchContoller.hidesNavigationBarDuringPresentation = false
            searchContoller.searchBar.delegate = self
            present(searchContoller, animated: true, completion: nil)
        }
}

  
