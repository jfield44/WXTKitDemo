//
//  MedicalProfessionalTableViewCell.swift
//  DrAnywhere
//
//  Created by Jonathan Field on 21/05/2017.
//  Copyright © 2017 Cisco. All rights reserved.
//

import UIKit

class MedicalProfessionalTableViewCell: UITableViewCell {

    @IBOutlet weak var doctorImage: UIImageView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorSpecialism: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
