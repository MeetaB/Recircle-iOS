//
//  ListItemDescViewController.swift
//  Recircle
//
//  Created by synerzip on 16/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import M13Checkbox

class ListItemDescViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtZip: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtDescription: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtUnavailbleDates: UITextField!
    
    @IBOutlet weak var checkBox: M13Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x2C3140)
        self.navigationController?.navigationBar.tintColor = UIColor.white

        // Do any additional setup after loading the view.
        
        txtZip.selectedTitleColor = UIColor.black
        txtDescription.selectedTitleColor = UIColor.black
        
        txtUnavailbleDates.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextTapped(_ sender: AnyObject) {
        
        if checkBox.checkState == M13Checkbox.CheckState.unchecked {
            let alert = UIAlertController(title: "Alert", message: "Please check terms & conditions", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "summary", sender: self)
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.performSegue(withIdentifier: "datePicker", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
