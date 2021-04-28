//
//  AccountController.swift
//  Parking
//
//  Created by Wei Xu on 2021-01-23.
//  101059762
//  Group 2

import Foundation
import CoreData
import UIKit

class AccountController {
    private var moc : NSManagedObjectContext
    
    init(){
        self.moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func insertAccount(email: String, password: String, firstname: String?, lastname: String?, contactNumber: String?, carPlateNumber: String?) -> AccountStatus{
        do{
            
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: moc) as! User
            newUser.email = email
            newUser.password = password
            newUser.dateCreated = Date()
            
            // Only save date which have value
            if firstname != "" {
                newUser.firstname = firstname
            }
            if lastname != "" {
                newUser.lastname = lastname
            }
            if contactNumber != "" {
                newUser.contactNo = contactNumber
            }
            if carPlateNumber != "" {
                newUser.carPlateNo = carPlateNumber
            }
            
            try moc.save()
            
            print(#function, "Account successfully created")
            return AccountStatus.INSERT_SUCCESS
            
        }catch let error as NSError{
            if error.code == 133021{
                print(#function, "Account already exists")
                return AccountStatus.USER_EXISTS
            }else{
                print(#function, "Something went wrong. Couldn't create account")
                print(#function, error, error.localizedDescription)
                return AccountStatus.INSERT_FAILURE
            }
        }
    }
    
    func validateAccount(email: String, password: String) -> Bool{
        //search for record
        //check if the account is active
        
        let userToValidate = self.searchAccount(email: email)
        
        if userToValidate != nil{
            if (userToValidate!.password == password){
                return true
            }
        }
        
        return false
    }

    func searchAccount(email: String) -> User?{
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        
        do{
            let result = try moc.fetch(fetchRequest).first
            
            if result != nil{
                print(#function, "Matching user found with email \(email)")
                
                let user = result as! User
                return user
            }
        }catch let error{
            print(#function, error.localizedDescription)
        }
        
        print(#function, "No Account found with \(email)")
        return nil
    }
    
    func saveProfile(email: String, firstname: String?, lastname: String?, contactNumber: String?, carPlateNumber: String?) -> UpdateStatus{
        let userProfile = self.searchAccount(email: email)
        
        if userProfile != nil{
            do{
                // Only save date which have value
                if firstname != "" {
                    userProfile!.firstname = firstname
                }
                if lastname != "" {
                    userProfile!.lastname = lastname
                }
                if contactNumber != "" {
                    userProfile!.contactNo = contactNumber
                }
                if carPlateNumber != "" {
                    userProfile!.carPlateNo = carPlateNumber
                }
                
                try moc.save()
                print(#function, "Profile updates successfully")
                return UpdateStatus.UPDATE_SUCCESS
            }catch let error{
                print(#function, "Unable to update profile")
                print(#function, error)
                return UpdateStatus.UPDATE_FAILURE
            }
        }
        
        return UpdateStatus.UPDATE_FAILURE
    }
    
    func deleteAccount(email: String){
        let accountToDelete = self.searchAccount(email: email)
        
        if accountToDelete != nil{
            do{
                //to delete the record from database
                moc.delete(accountToDelete!)
                
                try moc.save()

            }catch let error{
                print(#function, "Cannot delete account" ,error)
            }
        }
    }
}

enum AccountStatus{
    case INSERT_SUCCESS
    case USER_EXISTS
    case INSERT_FAILURE
}

enum UpdateStatus{
    case UPDATE_SUCCESS
    case UPDATE_FAILURE
}
