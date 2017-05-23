//
//  DayCellView.swift
//  Recircle
//
//  Created by synerzip on 06/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DayCellView: JTAppleDayCellView {

    @IBOutlet weak var textDate: UILabel!
    
    @IBOutlet weak var selectedView: UIView!
    
    @IBOutlet weak var cross: UIImageView!
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if !selectedView.isHidden {
            self.selectedView.bringSubview(toFront: textDate)
            textDate.textColor = UIColor(colorLiteralRed: 0, green: 151, blue: 167, alpha: 0)
        }
    }
 

}
