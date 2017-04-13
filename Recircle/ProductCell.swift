//
//  ProductCell.swift
//  Recircle
//
//  Created by synerzip on 13/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import Cosmos

class ProductCell: UITableViewCell {

    
    @IBOutlet weak var imageProduct: UIImageView!
    
    @IBOutlet weak var textProductName: UILabel!
    
    
    @IBOutlet weak var textOwnerName: UILabel!
    
    @IBOutlet weak var viewRating: CosmosView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
