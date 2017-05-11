//
//  ProdImagesTableViewCell.swift
//  Recircle
//
//  Created by synerzip on 11/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class ProdImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var prodImage: UIImageView!
    
    @IBOutlet weak var prodImagesCollection: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
