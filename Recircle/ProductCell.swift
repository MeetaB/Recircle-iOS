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

    
    @IBOutlet weak var prodImage: UIImageView!
    
    
    @IBOutlet weak var prodName: UILabel!
    
    
    @IBOutlet weak var prodPrice: UILabel!
    
    
    @IBOutlet weak var prodOwner: UILabel!
    
    @IBOutlet weak var prodRating: CosmosView!
    
    
    @IBOutlet weak var prodFavourite: UIButton!
    
    //
    
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
