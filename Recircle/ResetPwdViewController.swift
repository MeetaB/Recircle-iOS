//
//  ResetPwdViewController.swift
//  Recircle
//
//  Created by synerzip on 07/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField
import SwiftyJSON

class ResetPwdViewController: UIViewController {

    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtOTP: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtNewPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtEmail.selectedTitleColor = UIColor.black
        
        txtOTP.selectedTitleColor = UIColor.black
        
        txtNewPassword.selectedTitleColor = UIColor.black
        
        btnSubmit.layer.cornerRadius = 10
        
        btnSubmit.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func crossTapped(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resendOTP(_ sender: AnyObject) {
        
        if let email = txtEmail.text {
            
            let url = URL(string: RecircleWebConstants.FORGOTPASSWORDAPI + "?user_name=" + email)
            
            
            Alamofire.request(url!,
                              method: .get)
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                    
                    self.performSegue(withIdentifier: "resetPassword", sender: self)
                    
                    print(response.request)  // original URL request
                    print(response.response) // HTTP URL response
                    print(response.data)     // server data
                    print(response.result)
                    
                    if let dataResponse = response.result.value {
                        let json = JSON(dataResponse)
                        print("JSON forgotpassword : \(json)")
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

    @IBAction func resetPassword(_ sender: AnyObject) {
        
        if let email = txtEmail.text, let otp = txtOTP.text,
            let password = txtNewPassword.text
        {
            
            let url = URL(string: RecircleWebConstants.FORGOTPASSWORDAPI)
            
            let parameters : [String : Any] = [
                "otp" : otp,
                "user_name" : email,
                "new_password" : password]
            
            Alamofire.request(url!,
                              method: .put,
                              parameters : parameters)
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                    
                    
                    print(response.request)  // original URL request
                    print(response.response) // HTTP URL response
                    print(response.data)     // server data
                    print(response.result)
                    
                    if let dataResponse = response.result.value {
                        let json = JSON(dataResponse)
                        print("JSON forgotpassword : \(json)")
                    }
                    
                  _ = self.navigationController?.popViewController(animated: true)
                    
                    
                    
            }
            
        }

        
    }
}
