//
//  ForgotPwdViewController.swift
//  Recircle
//
//  Created by synerzip on 07/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ForgotPwdViewController: UIViewController {

    
    @IBOutlet weak var btnSendOTP: UIButton!
    
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    
    var progressBar : MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtEmail.selectedTitleColor = UIColor.black
        btnSendOTP.layer.cornerRadius = 10
        btnSendOTP.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func crossTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func sendOTPTapped(_ sender: AnyObject) {
        
        progressBar = MBProgressHUD.showAdded(to: self.view, animated: true);
        
        progressBar.mode = MBProgressHUDMode.indeterminate
        
        progressBar.label.text = "Loading";
        
        progressBar.isUserInteractionEnabled = false;
        
        if let email = txtEmail.text {
        
            let url = URL(string: RecircleWebConstants.FORGOTPASSWORDAPI + "?user_name=" + email)
        
        
            Alamofire.request(url!,
                              method: .get)
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                    
                    self.progressBar.hide(animated: true)
                    
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

        
        self.progressBar.hide(animated: true)

        
    }
}
