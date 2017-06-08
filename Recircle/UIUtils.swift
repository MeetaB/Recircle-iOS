//
//  UIUtilities.swift
//  Recircle
//
//  Created by synerzip on 08/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation
import MBProgressHUD
import UIKit

public class UIUtils {
    
    static var progressBar : MBProgressHUD!
    
    public static func showProgressBar (_ view : UIView) {
        
        progressBar = MBProgressHUD.showAdded(to: view, animated: true);
        
        progressBar.mode = MBProgressHUDMode.indeterminate
        
        progressBar.label.text = "Loading";
        
        progressBar.isUserInteractionEnabled = false;

    }
    
    
    public static func hideProgresBar () {
        
        progressBar.hide(animated: true)
    }
    
    
    public static func showAlertNoAction (viewController : UIViewController, title : String, message : String, positiveButton : String , negativeButton : String) {
        
        let alertView = UIAlertController(title: title,
                                          message: message as String, preferredStyle:.alert)
        
        let okAction = UIAlertAction(title: positiveButton, style: .default){
            UIAlertAction in

        }
        
        let cancelAction = UIAlertAction(title: negativeButton, style: .default, handler: nil)
        
        alertView.addAction(okAction)
        alertView.addAction(cancelAction)
        
        viewController.present(alertView, animated: true, completion: nil)
        
    }
}
