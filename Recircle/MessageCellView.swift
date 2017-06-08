//
//  MessageCell.swift
//  Recircle
//
//  Created by synerzip on 08/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class MessageCellView : UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBOutlet weak var txtUserName: UILabel!
    
    
    @IBOutlet weak var txtProdName: UILabel!
    
    
    @IBOutlet weak var txtDate: UILabel!
    
    
    @IBOutlet weak var statusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
