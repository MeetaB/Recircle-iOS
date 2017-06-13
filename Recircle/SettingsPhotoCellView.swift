//
//  SettingsPhotoCellView.swift
//  Recircle
//
//  Created by synerzip on 12/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class SettingsPhotoCellView: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var txtUserName: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
