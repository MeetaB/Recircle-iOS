//
//  EditUserViewController.swift
//  Recircle
//
//  Created by synerzip on 13/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON

class EditUserViewController: UIViewController {

    var userInfo : UserInfo!
    
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var txtStreetAddress: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var txtCity: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var txtState: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var txtZipcode: SkyFloatingLabelTextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EditUserViewController.saveData))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named : "done"), style: .plain, target: self, action: #selector(EditUserViewController.saveData))
        
        txtFirstName.selectedTitleColor = UIColor.black
        
        txtFirstName.text = userInfo.first_name
        
        txtLastName.selectedTitleColor = UIColor.black
        
        txtLastName.text = userInfo.last_name
        
        txtEmail.selectedTitleColor = UIColor.black
        
        txtEmail.text = userInfo.email
        
        txtMobile.selectedTitleColor = UIColor.black
        
        if let mobile = userInfo.user_mob_no {
            txtMobile.text = String(describing: mobile)
        }
        
        txtStreetAddress.selectedTitleColor = UIColor.black
        
        txtStreetAddress.text = userInfo.userAddress?.street
        
        txtCity.selectedTitleColor = UIColor.black
        
        txtCity.text = userInfo.userAddress?.city
        
        txtState.selectedTitleColor = UIColor.black
        
        txtState.text = userInfo.userAddress?.state
        
        txtZipcode.selectedTitleColor = UIColor.black

        if let zip = userInfo.userAddress?.zip {
            txtZipcode.text = String(describing: zip)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveData() {
        
        if let token = KeychainWrapper.standard.string(forKey: RecircleAppConstants.TOKENKEY) {
            let url = URL(string: RecircleWebConstants.USERSAPI)
            
            if let firstName = txtFirstName.text, let lastName = txtLastName.text, let email = txtEmail.text, let mobile = txtMobile.text {
                
                var street = "" , city = "" , state = "" , zip = "", addressId = ""
                
                if !(txtStreetAddress.text?.isEmpty)!{
                    street = txtStreetAddress.text!
                }
                
                if !(txtCity.text?.isEmpty)!{
                    city = txtCity.text!
                }
                
                if !(txtState.text?.isEmpty)!{
                    state = txtState.text!
                }
                
                if !(txtZipcode.text?.isEmpty)!{
                    zip = txtZipcode.text!
                }
                
                if userInfo.userAddress != nil && userInfo.userAddress?.user_address_id != nil {
                    addressId = (userInfo.userAddress?.user_address_id)!
                }
                
                let userAddress : [String : Any] = ["user_address_id" : addressId as Any,
                                                    "street" : street as Any,
                                                    "city" : city as Any,
                                                    "state" : state as Any,
                                                    "zip" : zip as Any]
                
                let parameters : [String : Any] = ["first_name" : firstName,
                                                      "last_name" : lastName,
                                                      "email" : email,
                                                      "user_mob_no" : mobile,
                                                      "notification_flag" : true,
                                                      "userAddress" : userAddress]
                
                print(JSON(parameters))
                
                let headers : HTTPHeaders = ["content-type" : "application/json",
                                             "authorization" : "Bearer " + token]
                
                Alamofire.request(url!, method: .put , parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON {
                        response in
                        print(response.result)
                        print(response.response?.statusCode)
                        self.navigationController?.popViewController(animated: true)
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
