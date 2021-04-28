//
//  ProfileViewController.swift
//  Parking
//
//  Created by Wei Xu on 2021-01-23.
//  101059762
//  Group 2

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtPlateNumber: UITextField!
    
    let email = UserDefaults.standard.value(forKey: "wx.useremail") as! String
    let accountController = AccountController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadInitialProfile()
        
    }
    
    
    @IBAction func updatePressed(_ sender: Any) {
        let fname = txtFirstName.text
        let lname = txtLastname.text
        let ctNo = txtContactNumber.text
        let ptNo = txtPlateNumber.text
        
        // validate the input length of car plate number between 2 and 8
        if(ptNo != "") {
            let plateNumber = ptNo as! NSString
            if plateNumber.length>8 || plateNumber.length<2 {
                let alert = UIAlertController(title: "Invalid Input", message: "The length of Car Plate Number must between 2 to 8!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
        }
        
        let updateStatus = self.accountController.saveProfile(email: email , firstname: fname, lastname: lname, contactNumber: ctNo, carPlateNumber: ptNo)
        
        switch updateStatus {
        case .UPDATE_SUCCESS:
            self.ShowAlertController(tl: "Update Successfully", msg: "Account has been updated successfully!")
        case .UPDATE_FAILURE:
            self.ShowAlertController(tl: "System Error", msg: "Somethign went wrong. Sorry for the inconvenience!")
        }
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Caution", message: "Are you sure want to delete the account?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
        
            self.accountController.deleteAccount(email: self.email)
            
            UserDefaults.standard.removeObject(forKey: "wx.useremail")
            
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension ProfileViewController {
    // Retrieve existing data from DB and display as default value
    func loadInitialProfile(){
        let userProfile = self.accountController.searchAccount(email: email)
        
        if userProfile != nil{
            txtFirstName.text = userProfile?.firstname
            txtLastname.text = userProfile?.lastname
            txtContactNumber.text = userProfile?.contactNo
            txtPlateNumber.text = userProfile?.carPlateNo
        }
    }
    
    func ShowAlertController(tl: String, msg: String) {
        let alert = UIAlertController(title: tl, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
