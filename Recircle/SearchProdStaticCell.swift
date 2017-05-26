//
//  SearchProdStaticCell.swift
//  Recircle
//
//  Created by synerzip on 24/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class SearchProdStaticCell: UICollectionViewCell {
    
    
    @IBOutlet weak var btnArrowProtection: UIButton!

    @IBOutlet weak var txtPickDropHeight: NSLayoutConstraint!

    @IBOutlet weak var txtPickDrop: UILabel!
    @IBOutlet weak var btnArrowPickDrop: UIButton!

    @IBOutlet weak var txtPayment: UILabel!

    @IBOutlet weak var btnArrowPayments: UIButton!

    @IBAction func paymentTapped(_ sender: AnyObject) {
        
        print("cell")
       // txtPayment.isHidden = true
    }


    @IBAction func PickUpDropTapped(_ sender: AnyObject) {
        
        print("cell tapped")
//        txtPickDropHeight.constant = 0.0
//        self.contentView.layoutIfNeeded()
    }
}
