//
//  SearchProductCell.swift
//  Recircle
//
//  Created by synerzip on 24/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import SearchTextField

class SearchProductCell: UICollectionViewCell {
    
    @IBOutlet weak var prodNameSearchTextField: SearchTextField!
    
    
    @IBOutlet weak var txtProdLocation: UITextField!
    
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var btnSearch: UIButton!
}
