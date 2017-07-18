//
//  CreateAccountViewController.swift
//  Recircle
//
//  Created by synerzip on 01/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import MBProgressHUD
import SwiftyJSON

class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var btnSendOTP: UIButton!
    
    @IBOutlet weak var txtMobileNumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!

    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtVerificationCode: SkyFloatingLabelTextField!
    
    var progressBar : MBProgressHUD!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSignUp.layer.cornerRadius = 10
        btnSignUp.layer.masksToBounds = true
        
        txtMobileNumber.delegate = self
        
        txtFirstName.selectedTitleColor = UIColor.black
        txtLastName.selectedTitleColor = UIColor.black
        txtEmail.selectedTitleColor = UIColor.black
        txtPassword.selectedTitleColor = UIColor.black
        txtMobileNumber.selectedTitleColor = UIColor.black
        txtVerificationCode.selectedTitleColor = UIColor.black
        
        btnSendOTP.isHidden = true
        // Do any additional setup after loading the view.
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func crossTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func sendOTP(_ sender: AnyObject) {
        
        if let mobile = txtMobileNumber.text {
            
           if let email = txtEmail.text {
        
            let parameters : [String : AnyObject] = [
            "user_mob_no" : mobile as AnyObject,
            "email" : email as AnyObject]
        
            Alamofire.request(URL(string : RecircleWebConstants.OTPAPI)!,
                              method : .get, parameters: parameters )
                .validate(contentType : ["application/json"])
                .responseJSON { response in
                    
                    print(response.request)  // original URL request
                    print(response.response) // HTTP URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    
            }
        }
        
        }
    }
    
    
    @IBAction func signUpTapped(_ sender: AnyObject) {
        
        if (txtFirstName.text == "" || txtLastName.text == "" || txtEmail.text == "" || txtPassword.text == "" || txtMobileNumber.text == "" || txtVerificationCode.text == "" ) {
            
            self.progressBar.hide(animated: true)
            
            let alertView = UIAlertController(title: "Account Creation Problem",
                                              message: "Please fill all details" as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Try Again!", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
            return
        }
        
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtMobileNumber.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtVerificationCode.resignFirstResponder()

        
        if let firstName = txtFirstName.text, let lastName = txtLastName.text ,
            let mobile = Int(txtMobileNumber.text!), let email = txtEmail.text,
            let password = txtPassword.text, let otp = Int(txtVerificationCode.text!)
        {
            progressBar = MBProgressHUD.showAdded(to: self.view, animated: true);
            
            progressBar.mode = MBProgressHUDMode.indeterminate
            
            progressBar.label.text = "Loading";
            
            progressBar.isUserInteractionEnabled = false;
            
            let encodedPassword = TextUtils.converToBase64(password)
            
            let parameters : [String : AnyObject] = [
                    "first_name" : firstName as AnyObject,
                    "last_name" :  lastName as AnyObject,
                    "password" :   encodedPassword as AnyObject,
                    "user_mob_no" : mobile as AnyObject,
                    "email" : email as AnyObject,
                    "otp" :  otp as AnyObject
                ]
            
            print(parameters)
    
            
        Alamofire.request(URL(string : RecircleWebConstants.USERSAPI)!,
                          method : .post, parameters: parameters,
                          encoding: JSONEncoding.default,headers : nil)
           // .validate(contentType : ["application/json"])
            .responseJSON { response in
                
                self.progressBar.hide(animated: true)

                print(response.request!)  // original URL request
                print(response.response!) // HTTP URL response
                print(response.data!)     // server data
                print(response.result)   // result of response serialization
                
                if let dataResponse = response.result.value {
                    let json = JSON(dataResponse)
                    print("JSON Create Account : \(json)")
                    let login = Login(dictionary: json.object as! NSDictionary)
                    
                    if let userId = login?.user_id {
                        KeychainWrapper.standard.set(userId, forKey: RecircleAppConstants.USERIDKEY)
                    }
                    
                    if let email = login?.email {
                        KeychainWrapper.standard.set(email, forKey: RecircleAppConstants.EMAILKEY)
                    }
                    
                    if let token = login?.token {
                        KeychainWrapper.standard.set(token, forKey: RecircleAppConstants.TOKENKEY)
                    }
                    
                    KeychainWrapper.standard.set(true, forKey: RecircleAppConstants.ISLOGGEDINKEY)
                    
                    if let firstName = login?.first_name, let lastName = login?.last_name {
                        
                        KeychainWrapper.standard.set(firstName + " " + lastName, forKey: RecircleAppConstants.NAMEKEY)
                        
                    }
                    
                    self.dismiss(animated: true, completion : nil)
                    
                    let searchVC = SearchProdViewController()
                    self.navigationController?.popToViewController(searchVC, animated: true)
                    
                }
            }
        } else{
            
            
        }

    }
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion : nil)
        
       // self.performSegue(withIdentifier: "signin", sender: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.characters.count)! >= 10 {
            btnSendOTP.isHidden = false
        }
    }
}
