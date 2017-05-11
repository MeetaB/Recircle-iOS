//
//  ProdDescTableViewCell.swift
//  Recircle
//
//  Created by synerzip on 11/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import Cosmos
import ReadMoreTextView

class ProdDescTableViewCell: UITableViewCell {

    @IBOutlet weak var txtProdName: UILabel!
    
    @IBOutlet weak var prodRatingView: CosmosView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var txtOwnerName: UILabel!
    
    @IBOutlet weak var btnMessages: UIButton!
    
    @IBOutlet weak var descTextView: ReadMoreTextView!
    
    @IBOutlet weak var condnTextView: ReadMoreTextView!
    
    @IBOutlet weak var renterRatingView: CosmosView!
    
    @IBOutlet weak var btnSeeAllReviews: UIButton!
    
    @IBOutlet weak var btnAllReviews: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
