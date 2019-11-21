//
//  GetAllDataTableViewCell.swift
//  Note_App _Application
//
//  Created by vijay on 11/3/19.
//  Copyright © 2019 vijay. All rights reserved.
//

import UIKit

class GetAllDataTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var editBtn: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editBtn(_ sender: UIButton) {
        
    }
    
    
}
