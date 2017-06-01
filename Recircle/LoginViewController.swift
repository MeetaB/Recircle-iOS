//
//  LoginViewController.swift
//  Recircle
//
//  Created by synerzip on 01/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnSignIn: UIButton!
    
    var progressBar : MBProgressHUD!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        btnSignIn.layer.cornerRadius = 10
        btnSignIn.layer.masksToBounds = true


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
    @IBAction func forgotPassword(_ sender: AnyObject) {
        
    }

    @IBAction func login(_ sender: AnyObject) {
        
        progressBar = MBProgressHUD.showAdded(to: self.view, animated: true);
        
        progressBar.mode = MBProgressHUDMode.indeterminate
        
        progressBar.label.text = "Loading";
        
        progressBar.isUserInteractionEnabled = false;
        
        if (txtEmail.text == "" || txtPassword.text == "") {
           
            self.progressBar.hide(animated: true)
            
            let alertView = UIAlertController(title: "Login Problem",
                                              message: "Wrong username or password." as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Try Again!", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
            return
        }
    
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        
        
        if let email = txtEmail.text , let password = txtPassword.text{
            let parameters : [String : AnyObject] = ["user_name" : email as AnyObject , "password" : password as AnyObject]
            
            Alamofire.request(URL(string: RecircleWebConstants.LoginApi)!,
                              method: .post, parameters: parameters)
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                    
                    self.progressBar.hide(animated: true)
                    
                    print(response.request)  // original URL request
                    print(response.response) // HTTP URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let dataResponse = response.result.value {
                        let json = JSON(dataResponse)
                        print("JSON LoginAPI: \(json)")
                        self.dismiss(animated: true, completion : nil)
                    }
                    else {
                        self.progressBar.hide(animated: true)
                    }
        }
        
        
        
        }

    }
    
    
    @IBAction func createAccount(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "signup", sender: self)
    }
    
    
}
