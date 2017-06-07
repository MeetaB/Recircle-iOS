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
import Alamofire
import SwiftyJSON

class ListItemDescViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtZip: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtDescription: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtUnavailbleDates: UITextField!
    
    @IBOutlet weak var checkBox: M13Checkbox!
    
    var listItem : ListItem!
    
    var unavailableDates : [String] = []
    
    var isZipcodeValid : Bool = false
    
    var austinZipCodes : [String] = [
        "73301","73344","78613","78617","78652","78653","78660","78701",
        "78702","78703","78704","78705","78708","78709","78710","78708",
        "78709","78710","78711",
        
        "78712",
        
        "78713",
        
        "78714",
        
        "78715",
        
        "78716",
        
        "78717",
        
        "78718",
        
        "78719",
        
        "78720",
        
        "78721",
        
        "78722",
        
        "78723",
        
        "78724",
        
        "78725",
        
        "78726",
        
        "78727",
        
        "78728",
        
        "78729",
        
        "78730",
        
        "78731",
        
        "78732",
        
        "78733",
        
        "78734",
        
        "78735",
        
        "78736",
        
        "78739",
        
        "78741",
        
        "78742",
        
        "78744",
        
        "78745",
        
        "78746",
        
        "78747",
        
        "78748",
        
        "78749",
        
        "78750",
        
        "78751",
        
        "78752",
        
        "78753",
        
        "78754",
        
        "78755",
        
        "78756",
        
        "78757",
        
        "78758",
        
        "78759",
        
        "78760",
        
        "78761",
        
        "78762",
        
        "78763",
        
        "78764",
        
        "78765",
        
        "78766",
        
        "78767",
        
        "78768",
        
        "78769",
        
        "78772",
        
        "78773",
        
        "78774",
        
        "78778",
        
        "78779",
        
        "78783",
        
        "78799"]
    
    var fromAustin : Int = 0
    
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
        
        txtZip.delegate = self
        
        addDoneButtonOnKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CalendarState.unavailableDates.count > 0 {
            self.unavailableDates = CalendarState.unavailableDates
            txtUnavailbleDates.text = String(CalendarState.unavailableDates.count) + " days"
            ListItemObject.listItemUnavailableCount = CalendarState.unavailableDates.count
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
        
        if !isZipcodeValid {
            let alert = UIAlertController(title: "Alert", message: "Please enter valid zipcode", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
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
            self.listItem.fromAustin = self.fromAustin
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
        
        if textField == txtUnavailbleDates {
            textField.resignFirstResponder()
            self.txtDescription.resignFirstResponder()
            self.txtZip.resignFirstResponder()
            
            CalendarState.listItem = true
            self.performSegue(withIdentifier: "datePicker", sender: self)
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtZip {
            if textField.text?.characters.count == 5 {
                checkZipCodeValidation(textField.text!)
            }
        }
    }
    
    
    func checkZipCodeValidation(_ zipCode : String) {
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address="+zipCode)
        
        Alamofire.request(url!)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if response.response?.statusCode != 200 {
                    self.txtZip.errorColor = UIColor.red
                    self.txtZip.errorMessage = "Invalid Zip"
                    self.isZipcodeValid = false
                } else {
                    let json = JSON(response.result.value)
                    if json["results"].arrayValue.count <= 0 {
                        self.txtZip.errorColor = UIColor.red
                        self.txtZip.errorMessage = "Invalid Zip"
                        self.isZipcodeValid = false
                    }
                    else {
                        self.txtZip.errorMessage = nil
                        self.isZipcodeValid = true
                        if self.austinZipCodes.contains(zipCode) {
                           self.fromAustin = 1
                        }
                    }
                }
        }
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
