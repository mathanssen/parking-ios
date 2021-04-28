//
//  CreateAccountViewController.swift
//  Parking
//
//  Created by Wei Xu on 2021-01-23.
//  101059762
//  Group 2

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfrimPassword: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtCarPlateNumber: UITextField!
    
    let accountController = AccountController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        let email = self.txtEmail.text
        let pwd = self.txtPassword.text
        let confirmPwd = self.txtConfrimPassword.text
        let firstNM = self.txtFirstName.text
        let lastNM = self.txtLastname.text
        let contactNo = self.txtContactNumber.text
        let plateNo = self.txtCarPlateNumber.text
        
        // validate the input length of car plate number between 2 and 8
        if plateNo != "" {
            let plateNumber = plateNo as! NSString
            if plateNumber.length>8 || plateNumber.length<2 {
                self.ShowAlertController(tl: "Invalid Input", msg: "The length of Car Plate Number must between 2 and 8!")
                return
            }
        }
        
        // check email and password must have value
        if(email != "" && pwd != "" && confirmPwd != "") {
            
            if (pwd == confirmPwd){
                
                let insertionStatus = self.accountController.insertAccount(email: email!, password: pwd!, firstname: firstNM, lastname: lastNM, contactNumber: contactNo, carPlateNumber: plateNo)
                
                switch insertionStatus {
                case .INSERT_SUCCESS:
                    let alert = UIAlertController(title: "Create Successfully", message: "Account has been created successfully!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: {_ in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)

                case .USER_EXISTS:
                    self.ShowAlertController(tl: "Account Exist", msg: "Account with same email already exists!")
                case .INSERT_FAILURE:
                    self.ShowAlertController(tl: "System Error", msg: "Somethign went wrong. Sorry for the inconvenience!")
                }
            }else{
                print(#function, "both passwords must be same.")
                self.ShowAlertController(tl: "Input Error", msg: "Password and Confirm Password must be same!")
            }
        } else {
            self.ShowAlertController(tl: "Invalid Input", msg: "Email Address ,Password and Confirm Password are required!")
        }
        
        
    }
    

}

extension CreateAccountViewController {
    func ShowAlertController(tl: String, msg: String) {
        let alert = UIAlertController(title: tl, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
