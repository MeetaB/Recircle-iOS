//
//  SettingsViewController.swift
//  Recircle
//
//  Created by synerzip on 10/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userInfo : UserInfo!
    
    var userFields : [String] = ["Email","Mobile","Street Address", "City","State","Zipcode"]
    
    var userFieldsValue = [String?](repeating: nil, count: 6)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x2C3140)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SettingsViewController.goBack))

        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        let nibPhoto = UINib(nibName: "SettingsPhotoCellView", bundle: nil)
        tableView.register(nibPhoto, forCellReuseIdentifier: "cellPhoto")
        
        let nibNotifications = UINib(nibName: "NotificationsCellView", bundle: nil)
        tableView.register(nibNotifications, forCellReuseIdentifier: "cellNotifications")
        
        let nibLabel = UINib(nibName: "SettingsLabelCellView", bundle: nil)
        tableView.register(nibLabel, forCellReuseIdentifier: "cellLabel")
        
        let nibCell = UINib(nibName: "SettingsCellView", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "cell")
        
        tableView.isHidden = true
        
        getUserData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "edit" {
            let editVC = segue.destination as! EditUserViewController
            editVC.userInfo = self.userInfo
        }
    }
    
    
    func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getUserData() {
        
        UIUtils.showProgressBar(self.view)
        
        if let token = KeychainWrapper.standard.string(forKey: RecircleAppConstants.TOKENKEY) {
            
            if let userId = KeychainWrapper.standard.string(forKey: RecircleAppConstants.USERIDKEY) {
                let url = URL(string: RecircleWebConstants.USERSAPI + "/" + userId)
                
                let headers : HTTPHeaders = ["authorization" : "Bearer " + token,
                                             "content-type" : "application/json"]
                
                
                Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON { response in
                        
                        UIUtils.hideProgresBar()
                        
                        if let value = response.result.value {
                            let json = JSON(value)
                            print(json)
                            self.userInfo = UserInfo(dictionary: json.object as! NSDictionary)
                            if self.userInfo != nil {
                                self.userFieldsValue.insert(self.userInfo.email!, at: 0)
                                if let mobNo = self.userInfo.user_mob_no {
                                    self.userFieldsValue.insert(String(describing: mobNo), at: 1)
                                }
                                
                                if self.userInfo.userAddress != nil {
                                    
                                    print(self.userInfo.userAddress?.street)
                                    self.userFieldsValue.insert(self.userInfo.userAddress?.street!, at : 2)
                                    self.userFieldsValue.insert((self.userInfo.userAddress?.city!)!, at : 3)
                                    self.userFieldsValue.insert((self.userInfo.userAddress?.state!)!, at : 4)
                                    if let zip = self.userInfo.userAddress?.zip {
                                        self.userFieldsValue.insert(String(describing: zip), at : 5)
                                    }
                                }
                                
                            }
                            print(self.userFieldsValue)
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }
                        
                }
            }
        }
    }
    
    func editUser() {
        print("editing")
        self.performSegue(withIdentifier: "edit", sender: self)
    }
    
}


extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cellPhoto = tableView.dequeueReusableCell(withIdentifier: "cellPhoto") as! SettingsPhotoCellView
            
            cellPhoto.backgroundColor =  UIColor(rgb: 0x2C3140)
            
            if userInfo != nil {
                
                if let imageUrl = userInfo.user_image_url {
                    cellPhoto.imgUser.setImageFromURl(stringImageUrl: imageUrl)
                }
                
                if let fisrtName = userInfo.first_name, let lastName = userInfo.last_name {
                    cellPhoto.txtUserName.text = fisrtName + " " + lastName
                }
                
                
                cellPhoto.btnEdit.addTarget(self, action: #selector(SettingsViewController.editUser), for: .touchUpInside)
            }
            
            return cellPhoto
            
        } else if indexPath.section == 1 {
            
            let cellLabel = tableView.dequeueReusableCell(withIdentifier: "cellLabel") as! SettingsLabelCellView
            
            cellLabel.txtHeading.text = userFields[indexPath.row]
            if userInfo != nil {
                cellLabel.txtValue.text = userFieldsValue[indexPath.row]
            }
            return cellLabel
            
        } else if indexPath.section == 2 {
            
            let cellNotifications = tableView.dequeueReusableCell(withIdentifier: "cellNotifications") as! NotificationsCellView
            
            return cellNotifications
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingsCellView
            
            cell.txtLabel.text = "Payments"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return 6
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 183
        } else if indexPath.section == 1 {
            return 78
        } else if indexPath.section == 2 {
            return 95
        } else {
            return 43
        }
        
    }
    
    
}
