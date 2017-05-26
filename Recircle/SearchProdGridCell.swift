//
//  SearchProdGridCell.swift
//  Recircle
//
//  Created by synerzip on 25/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import Cosmos

class SearchProdGridCell: UICollectionViewCell {
    
    @IBOutlet weak var imageProduct: UIImageView!
    
    @IBOutlet weak var txtProdName: UILabel!
    
    @IBOutlet weak var txtOwnerName: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var txtPrice: UILabel!
}
