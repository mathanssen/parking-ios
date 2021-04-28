//
//  ParkingListViewController.swift
//  Parking
//
//  Created by Matheus Hanssen on 2021-01-24.
//  101303562
//  Group 2

import UIKit

class ParkingListViewController: UIViewController {

    // Variables
    let parkingController = ParkingController()
    var parkingList:[Parking] = []
    var parking:Parking?
    let email = UserDefaults.standard.value(forKey: "wx.useremail") as! String
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Default function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reverse array to show the most recent before
        self.parkingList = []
        let list = self.parkingController.getParkingList()
        for item in list {
            if item.email == self.email {
                self.parkingList.append(item)
            }
        }
        self.parkingList = self.parkingList.reversed()
        
        // Refresh TableView each time the screen is called
        self.tableView.reloadData()
        
        // Table view settings
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    
    // Transfer data to details screen
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "detailSegue" {
            let detailsScreen = segue.destination as! DetailViewController
            detailsScreen.parking = self.parking!
        }
    }
}

// Extensions for the TableView
extension ParkingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.parking = parkingList[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
}

extension ParkingListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Convert Date to String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let date = parkingList[indexPath.row].parkingDate
        let strDate = dateFormatter.string(from: date!)
        
        // Retrieve the values on the screen
        cell.textLabel?.text = strDate
        cell.detailTextLabel?.text = parkingList[indexPath.row].building
        
        return cell
    }
    
}
