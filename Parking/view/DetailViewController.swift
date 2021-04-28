//
//  DetailViewController.swift
//  Parking
//
//  Created by Matheus Hanssen on 2021-01-24.
//  101303562
//  Group 2

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {

    // Variables
    var parking:Parking?
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    // Outlets
    @IBOutlet weak var lblBuildingCode: UILabel!
    @IBOutlet weak var lblHoursNo: UILabel!
    @IBOutlet weak var lblSuit: UILabel!
    @IBOutlet weak var lblCarPlate: UILabel!
    @IBOutlet weak var lblParkingLocation: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    // Default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create variables from the entity
        let building = (self.parking!.value(forKey:"building")! as! String)
        let hoursNo = (self.parking!.value(forKey:"hours")! as! String)
        let suit = (self.parking!.value(forKey:"suit")! as! String)
        let carPlate = (self.parking!.value(forKey:"carPlateNo")! as! String)
                
        // For the date, we need to convert to String before
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy hh:mm:ss"
        let date = self.parking!.value(forKey:"parkingDate")!
        let strDate = formatter.string(from: date as! Date)
        
        // Show the values on the screen
        lblBuildingCode.text = building
        lblHoursNo.text = hoursNo
        lblSuit.text = suit
        lblCarPlate.text = carPlate
        lblDate.text = strDate
        
        // Get the location address and display on the label
        let lat = self.parking!.value(forKey:"locationLat")! as! Double
        let lng = self.parking!.value(forKey: "locationLng")! as! Double
        self.getAddress(location: CLLocation(latitude: lat, longitude: lng))
    }
    
    // Go back
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Transfer data to details screen
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "mapSegue" {
            let mapScreen = segue.destination as! MapViewController
            mapScreen.parking = self.parking
        }
    }
    
}

// Extension to display the destination address
extension DetailViewController {
    func getAddress(location: CLLocation){
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemark, error) in
            self.processGeoResponse(withPlacemarks: placemark, error: error)
        })
    }
    
    func processGeoResponse(withPlacemarks placemarks : [CLPlacemark]?, error : Error?) {
        if error != nil {
            lblParkingLocation.text = "Unable to find the address"
        } else {
            
            if let placemarks = placemarks, let placemark = placemarks.first{
                let address = (placemark.locality! + ", " + placemark.administrativeArea! + ", " + placemark.country!)
                lblParkingLocation.text = address
            } else {
                lblParkingLocation.text = "Address is not found"
            }
        }
    }
}
