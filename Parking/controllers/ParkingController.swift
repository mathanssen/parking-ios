//
//  ParkingController.swift
//  Parking
//
//  Created by Wei Xu on 2021-01-23.
//  101059762
//  Group 2

import Foundation
import CoreData
import UIKit

class ParkingController {
    private var moc : NSManagedObjectContext
    
    init(){
        self.moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func insertParking(email: String, building: String, hours: String, plate: String, suit: String, lat: Double, lng: Double) -> ParkingStatus{
        do{
            
            let newParking = NSEntityDescription.insertNewObject(forEntityName: "Parking", into: moc) as! Parking
            newParking.email = email
            newParking.building = building
            newParking.hours = hours
            newParking.carPlateNo = plate
            newParking.suit = suit
            newParking.locationLat = lat
            newParking.locationLng = lng
            newParking.parkingDate = Date()
            
            try moc.save()
            
            print(#function, "Parking Record successfully created")
            return ParkingStatus.INSERT_SUCCESS
            
        }catch let error as NSError{
            print(#function, "Something went wrong. Couldn't create account")
            print(#function, error, error.localizedDescription)
            return ParkingStatus.INSERT_FAILURE
        }
    }
    
    // Created by Matheus:
    // Retrieve array of parkings
    func getParkingList() -> [Parking] {
        let fetchRequest = NSFetchRequest<Parking>(entityName: "Parking")
        do {
            let result = try moc.fetch(fetchRequest)
            let parkingList = result as [Parking]
            return parkingList
            
        } catch let error {
            print(#function, "Couldn't fetch records", error.localizedDescription)
            return []
        }
    }
    
}

enum ParkingStatus{
    case INSERT_SUCCESS
    case INSERT_FAILURE
}
