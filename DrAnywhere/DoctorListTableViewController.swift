//
//  DoctorListTableViewController.swift
//  DrAnywhere
//
//  Created by Jonathan Field on 20/05/2017.
//  Copyright © 2017 Cisco. All rights reserved.
//

import UIKit
import AABlurAlertController

class DoctorListTableViewController: UITableViewController {
    
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
        let vc = AABlurAlertController()
        vc.addAction(action: AABlurAlertAction(title: "Cancel", style: AABlurActionStyle.cancel) { _ in
            print("cancel")
        })
        vc.addAction(action: AABlurAlertAction(title: "Start", style: AABlurActionStyle.default) { _ in
            print("start")
        })
        vc.blurEffectStyle = .light
        vc.alertImage.image = UIImage(named: (doctor.value(forKey: "doctorImage") as? String)!)
        vc.imageHeight = 110
        vc.alertImage.layer.masksToBounds = true
        vc.alertTitle.text = "Video Call"
        vc.alertSubtitle.text = "Are you sure you wish to begin a remote consultation with \(doctor.value(forKey: "doctorName") as! String)?"
        self.present(vc, animated: true, completion: nil)
    }
    
}
