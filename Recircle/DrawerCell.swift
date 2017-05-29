//
//  DrawerCell.swift
//  Recircle
//
//  Created by synerzip on 29/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class DrawerCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
