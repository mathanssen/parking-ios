//
//  DetailViewController.swift
//  Parking
//
//  Created by Matheus Hanssen on 2021-01-25.
//  101303562
//  Group 2

import UIKit
import MapKit

// Location class
struct Locations {
    var name : String
    var coordinates : CLLocationCoordinate2D
}

class MapViewController: UIViewController, MKMapViewDelegate {

    // Variables
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var parking:Parking?
    
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // Default Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting for the MapView
        self.mapView?.delegate = self
        
        // Ask for permisson and show the route
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    // Actions
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


// Extensions for the MapView
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Check the current location
        guard let myLocation : CLLocationCoordinate2D = manager.location?.coordinate
        else { return }
        
        // Get the destination values (latitude and longitude)
        let latDestination = self.parking!.value(forKey:"locationLat")! as! Double
        let lngDestination = self.parking!.value(forKey:"locationLng")! as! Double
                
        // Display the markers and show the route on map
        let locationArray = [
            Locations(name: "My Location",
                      coordinates: CLLocationCoordinate2D(latitude: myLocation.latitude,
                                                          longitude: myLocation.longitude)),
            Locations(name: "Destination",
                      coordinates: CLLocationCoordinate2D(latitude: latDestination,
                                                          longitude: lngDestination))
        ]
        self.displayMarkers(locations: locationArray)
        self.showRouteOnMap(pickupCoordinate: locationArray[0].coordinates, destinationCoordinate: locationArray[1].coordinates)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension MapViewController {
    func displayMarkers(locations: [Locations]){
        for loc in locations{
            let annotation = MKPointAnnotation()
            annotation.coordinate = loc.coordinates
            annotation.title = loc.name
            self.mapView?.addAnnotation(annotation)
        }
    }
    
    func showRouteOnMap(pickupCoordinate : CLLocationCoordinate2D, destinationCoordinate : CLLocationCoordinate2D){
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate,
                                                          addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate,
                                                               addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: { response, error in
            guard let response = response else {return}
            if let route = response.routes.first{
                self.mapView?.addOverlay(route.polyline)
                self.mapView?.setVisibleMapRect(route.polyline.boundingMapRect,
                                                edgePadding: UIEdgeInsets.init(top: 80,
                                                                               left: 20,
                                                                               bottom: 100,
                                                                               right: 20),
                                                animated: true)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 5.0
        return renderer
    }
}
