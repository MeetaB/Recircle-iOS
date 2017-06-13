//
//  SettingsViewController.swift
//  Recircle
//
//  Created by synerzip on 10/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.isNavigationBarHidden = false
//        
//        self.navigationController?.navigationBar.isHidden = false
//        
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x2C3140)
        self.navigationController?.navigationBar.tintColor = UIColor.white

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

}


extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cellPhoto = tableView.dequeueReusableCell(withIdentifier: "cellPhoto") as! SettingsPhotoCellView
        
            cellPhoto.backgroundColor =  UIColor(rgb: 0x2C3140)
            
            return cellPhoto
        } else if indexPath.section == 1 {
            
            let cellLabel = tableView.dequeueReusableCell(withIdentifier: "cellLabel") as! SettingsLabelCellView
            
            return cellLabel

        } else if indexPath.section == 2 {
            
            let cellNotifications = tableView.dequeueReusableCell(withIdentifier: "cellNotifications") as! NotificationsCellView
            
            return cellNotifications
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingsCellView
            
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
