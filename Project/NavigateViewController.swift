//
//  EvantDetailsViewController.swift
//  Project
//
//  Created by admin on 14/01/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class NavigateViewController: UIViewController {
    
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func button3(_ sender: AnyObject) {
        getDirections()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        //self.mapView.showsUserLocation = true
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
    }
    
    func getDirections(){
        let geocoder = CLGeocoder()
        let str = "1600 Pennsylvania Ave. 20500" // A string of the address info you already have
        geocoder.geocodeAddressString(str) { (placemarksOptional, error) -> Void in
            if let placemarks = placemarksOptional {
                let mkPlacemark = MKPlacemark(coordinate: (placemarks[0].location?.coordinate)!, addressDictionary: placemarks[0].addressDictionary as! [String : Any]?)
                let mapItem = MKMapItem(placemark: mkPlacemark)
                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: launchOptions)
//                print("placemark| \(placemarks.first)")
//                if let location = placemarks.first?.location {
//                    let query = "?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
//                    let path = "http://maps.apple.com/" + query
//                    if let url = NSURL(string: path) {
//                        UIApplication.sharedApplication().openURL(url)
//                    } else {
//                        // Could not construct url. Handle error.
//                    }
//                } else {
//                    // Could not get a location from the geocode request. Handle error.
//                }
            } else {
                // Didn't get any placemarks. Handle error.
            }
        }
//        guard let selectedPin = selectedPin else { return }
//        let mapItem = MKMapItem(placemark: selectedPin)
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        mapItem.openInMaps(launchOptions: launchOptions)
    }
}

extension NavigateViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }

}

extension NavigateViewController: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
}

extension NavigateViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        let reuseId = "pin"
        guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView else { return nil }
        
        pinView.pinTintColor = UIColor.orange
        pinView.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        var button: UIButton?
        button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button?.setBackgroundImage(UIImage(named: "car"), for: UIControlState())
        button?.addTarget(self, action: #selector(NavigateViewController.getDirections), for: .touchUpInside)
        pinView.leftCalloutAccessoryView = button
        
        return pinView
    }
}
