//
//  DrawerHeaderCell.swift
//  Recircle
//
//  Created by synerzip on 29/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class DrawerHeaderCell: UITableViewCell {

    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
