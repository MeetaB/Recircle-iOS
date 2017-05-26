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
    
    var listItem : ListItem!
    
    var unavailableDates : [String] = []
    
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
        
        addDoneButtonOnKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CalendarState.unavailableDates.count > 0 {
            txtUnavailbleDates.text = String(CalendarState.unavailableDates.count) + " days"
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width : 320, height : 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ListItemDescViewController.doneButtonAction))
        
        var items : [UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.txtDescription.inputAccessoryView = doneToolbar
        self.txtZip.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.txtDescription.resignFirstResponder()
        self.txtZip.resignFirstResponder()
    }

    
    @IBAction func nextTapped(_ sender: AnyObject) {
        
        if checkBox.checkState == M13Checkbox.CheckState.unchecked {
            let alert = UIAlertController(title: "Alert", message: "Please check terms & conditions", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            if ListItemObject.listItem != nil {
                self.listItem = ListItemObject.listItem
            } else {
                self.listItem = ListItem()
            }
            
            self.listItem.user_prod_desc = self.txtDescription.text
            self.listItem.user_product_zipcode = Int(self.txtZip.text!)
            
            var userProdUnavailDates : [UserProdUnavailability] = []
            
            for date in self.unavailableDates {
                
                let unavailableDate = UserProdUnavailability()
                unavailableDate.unavai_from_date = date
                unavailableDate.unavai_to_date = date
                userProdUnavailDates.append(unavailableDate)
            }
            
            listItem.user_prod_unavailability = userProdUnavailDates
            
            print(listItem.user_prod_unavailability?.count)
            
            ListItemObject.listItem = self.listItem
            
            self.performSegue(withIdentifier: "summary", sender: self)
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        CalendarState.listItem = true
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
