//
//  ParkingViewController.swift
//  Parking
//
//  Created by Wei Xu on 2021-01-23.
//  101059762
//  Group 2

import UIKit
import CoreLocation

class ParkingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let geocoder = CLGeocoder()
    
    let parkingController = ParkingController()
    let accountController = AccountController()
    let locationManager = CLLocationManager()
    
    let email = UserDefaults.standard.value(forKey: "wx.useremail") as! String
    
    let hourData = ["1", "4", "12", "24"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hourData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hourData[row]
    }
    
    @IBOutlet weak var buildingCode: UITextField!
    @IBOutlet weak var NoOfHours: UIPickerView!
    @IBOutlet weak var carPlateNumber: UITextField!
    @IBOutlet weak var suitNo: UITextField!

    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var street: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.NoOfHours.delegate = self
        self.NoOfHours.dataSource = self
        
        self.loadInitialPlateNumber()
    }
    
    @IBAction func getCurrentLocation(_ sender: Any) {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func addParkingRecord(_ sender: Any) {
        
        let building = buildingCode.text
        let carPlate = carPlateNumber.text
        let suit = suitNo.text
        let cou = country.text
        let cty = city.text
        let st = street.text
        
        
        if InputValidation(building: building, carPlate: carPlate, suit: suit, cou: cou, cty: cty, st: st) {
            let selectedIndex = self.NoOfHours.selectedRow(inComponent: 0)
            let hours = hourData[selectedIndex]
            
            let address = "\(cou!), \(cty!), \(st!)"
            print(#function, address)
            geocoder.geocodeAddressString(address, completionHandler: { (placemark, error) in
                if error != nil{
                    print(#function, error)
                    self.ShowAlertController(tl: "Error", msg: "We are unable to get the coordinates!")
                }else{
                    var location : CLLocation?
                    
                    if let place = placemark, placemark!.count > 0{
                        location = place.first?.location
                    }
                    
                    if let location = location{
                        let addStatus = self.parkingController.insertParking(email: self.email, building: building!, hours: hours, plate: carPlate!, suit: suit!, lat: location.coordinate.latitude, lng: location.coordinate.longitude)
                        
                        switch addStatus {
                        case .INSERT_SUCCESS:
                            self.ShowAlertController(tl: "Add Successfully", msg: "Parking Record has been created successfully!")
                        case .INSERT_FAILURE:
                            self.ShowAlertController(tl: "System Error", msg: "Somethign went wrong. Sorry for the inconvenience!")
                        }
                    }else{
                        self.ShowAlertController(tl: "Invalid Address Input", msg: "Coordinates not found!")
                    }
                }
            })
        }
    }
}

extension ParkingViewController {
    
    // Retrieve Car Plate Number from DB and display as default value
    func loadInitialPlateNumber(){
        let userProfile = self.accountController.searchAccount(email: self.email)
        
        if userProfile != nil{
            carPlateNumber.text = userProfile?.carPlateNo
        }
    }
    
    func InputValidation(building: String?, carPlate: String?, suit: String?, cou: String?, cty: String?, st: String?) -> Bool {

        if building == "" {
            self.ShowAlertController(tl: "Invalid Input", msg: "Building Code is required!")
            return false
        } else {
            let buildingNo = building as! NSString
            if buildingNo.length != 5 {
                self.ShowAlertController(tl: "Invalid Input", msg: "The length of Building Code must be 5!")
                return false
            }
        }
        
        if carPlate == "" {
            self.ShowAlertController(tl: "Invalid Input", msg: "Car Plate Number is required!")
            return false
        } else {
            let plateNumber = carPlate as! NSString
            if plateNumber.length > 8 || plateNumber.length < 2 {
                self.ShowAlertController(tl: "Invalid Input", msg: "The length of Car Plate Number must between 2 and 8!")
                return false
            }
        }
        
        if suit == "" {
            self.ShowAlertController(tl: "Invalid Input", msg: "Suit No is required!")
            return false
        } else {
            let suitNo = suit as! NSString
            if suitNo.length > 5 || suitNo.length < 2 {
                self.ShowAlertController(tl: "Invalid Input", msg: "The length of Suit No must between 2 and 5!")
                return false
            }
        }
        
        if cou == "" {
            self.ShowAlertController(tl: "Invalid Input", msg: "Parking Location(Country) is required!")
            return false
        }
        if cty == "" {
            self.ShowAlertController(tl: "Invalid Input", msg: "Parking Location(City) is required!")
            return false
        }
        if st == "" {
            self.ShowAlertController(tl: "Invalid Input", msg: "Parking Location(Street) is required!")
            return false
        }
        
        return true

    }
    
    func ShowAlertController(tl: String, msg: String) {
        let alert = UIAlertController(title: tl, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ParkingViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let myLocation : CLLocationCoordinate2D = manager.location?.coordinate
        else{ return }
        
        print("\(myLocation.latitude)")
        print("\(myLocation.longitude)")
        
        self.getAddress(location: CLLocation(latitude: myLocation.latitude, longitude: myLocation.longitude))
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error)
    }
    
}

extension ParkingViewController{
    func getAddress(location : CLLocation){
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemark, error) in
            self.processGeoResponse(withPlacemarks: placemark, error: error)
        })
    }
    
    func processGeoResponse(withPlacemarks placemarks : [CLPlacemark]?, error : Error?){
        if error != nil{
            self.ShowAlertController(tl: "Error", msg: "Unable to find the address.")
        }else{
            
            if let placemarks = placemarks, let placemark = placemarks.first{
                print(#function, "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)")
                
                self.street.text = placemark.locality!
                self.city.text = placemark.administrativeArea!
                self.country.text = placemark.country!
            }else{
                self.ShowAlertController(tl: "Error", msg: "Address is not found.")
            }
        }
    }
}
