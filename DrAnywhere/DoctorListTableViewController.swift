//
//  DoctorListTableViewController.swift
//  DrAnywhere
//
//  Created by Jonathan Field on 20/05/2017.
//  Copyright © 2017 Cisco. All rights reserved.
//

import UIKit

class DoctorListTableViewController: UITableViewController, WXTeamsCallingDelegate {
    
    let doctors = NSArray(contentsOf:Bundle.main.url(forResource: "doctors", withExtension: "plist")!)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : (self.doctors?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "titleCell")!
        }
        else if indexPath.section == 1 {
            let doctor = self.doctors?.object(at: indexPath.row) as! NSDictionary
            let doctorCell = self.tableView.dequeueReusableCell(withIdentifier: "medicalProfessionalCell") as! MedicalProfessionalTableViewCell
            doctorCell.doctorName.text = doctor.value(forKey: "doctorName") as? String
            doctorCell.doctorSpecialism.text = doctor.value(forKey: "doctorSpecialism") as? String
            doctorCell.doctorImage.image = UIImage(named: (doctor.value(forKey: "doctorImage") as? String)!)
            doctorCell.doctorImage.layer.cornerRadius = doctorCell.doctorImage.frame.size.height/2
            doctorCell.doctorImage.layer.borderWidth = 3
            doctorCell.doctorImage.layer.borderColor = Int(arc4random_uniform(UInt32(9))) % 2 == 0 ? UIColor.green.cgColor : UIColor.red.cgColor
            doctorCell.doctorImage.clipsToBounds = true
            return doctorCell
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 150 : 95
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let doctor = self.doctors?.object(at: indexPath.row) as! NSDictionary
        
        let alertController = UIAlertController(title: "Interact with \(doctor.value(forKey: "doctorName") as! String)", message: "Do you wish to start a Chat or a Video Call?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Chat", style: .default) { (action) in
            print("Chat is pressed.....")
            
            /**
                Complete Chat Functionality Here 💬
            */
           
        }
        let action2 = UIAlertAction(title: "Video Call", style: .default) { (action) in
            print("Video Call is pressed......")
            
            /**
                Complete Video Calling Functionality Here ☎️
            */
            
        }
        let action3 = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            print("Cancel is pressed......")
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func callDidComplete() {
        
    }
    
    func callFailed(withError: String) {
        
    }

}
