//
//  ViewController.swift
//  Parking
//
//  Created by Wei Xu on 2021-01-19.
//  101059762
//  Group 2

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let accountController = AccountController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInPressed(_ sender: Any) {
        if (txtEmail.text != nil && txtPassword.text != nil){
            if (self.accountController.validateAccount(email: txtEmail.text!, password: txtPassword.text!)){
                print(#function, "Login successful")
                self.loginSuccessful()
                
            }else{
                let alert = UIAlertController(title: "Login Unsuccessful", message: "Incorrect email and/or password. Try again!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func loginSuccessful(){
        UserDefaults.standard.setValue(txtEmail.text!, forKey: "wx.useremail")
        
        let alert = UIAlertController(title: "Login successful", message: "You have successfully logged in.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: {_ in
            print(#function, "Navigating to the home screen")
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let tabContainer = storyboard.instantiateViewController(withIdentifier: "TabContainer")
            
            tabContainer.navigationItem.hidesBackButton = true
            tabContainer.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(self.signout))
            
            self.navigationController?.pushViewController(tabContainer, animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    func signout(){
        self.navigationController?.popToRootViewController(animated : true)
    }
}

