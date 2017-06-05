//
//  DrawerViewController.swift
//  Recircle
//
//  Created by synerzip on 29/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import KYDrawerController

class DrawerViewController: UIViewController {

    var iconImages: [UIImage] = [
        UIImage(named: "login")!,
        UIImage(named: "settings")!,
        UIImage(named: "help_gray")!,
        UIImage(named: "logout")!
    ]
    
    var itemName : [String] = ["Login","Settings","FAQ","Logout"]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "DrawerCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        let nibHeader = UINib(nibName: "DrawerHeaderCell", bundle: nil)
        
        tableView.register(nibHeader, forCellReuseIdentifier: "cellHeader")

        // Do any additional setup after loading the view.
        
        let closeButton    = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: UIControlState())
        closeButton.addTarget(self,
                              action: #selector(didTapCloseButton),
                              for: .touchUpInside
        )
        closeButton.sizeToFit()
        closeButton.setTitleColor(UIColor.blue, for: UIControlState())
       // view.addSubview(closeButton)
//        view.addConstraint(
//            NSLayoutConstraint(
//                item: closeButton,
//                attribute: .centerX,
//                relatedBy: .equal,
//                toItem: view,
//                attribute: .centerX,
//                multiplier: 1,
//                constant: 0
//            )
//        )
//        view.addConstraint(
//            NSLayoutConstraint(
//                item: closeButton,
//                attribute: .centerY,
//                relatedBy: .equal,
//                toItem: view,
//                attribute: .centerY,
//                multiplier: 1,
//                constant: 0
//            )
//        )
      //  view.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        tableView.bounces = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if KeychainWrapper.standard.hasValue(forKey: RecircleAppConstants.ISLOGGEDINKEY) {
   // if KeychainWrapper.standard.hasValue(forKey: RecircleAppConstants.ISLOGGEDINKEY, withAccessibility: KeychainItemAccessibility.afterFirstUnlock) {
        if KeychainWrapper.standard.bool(forKey: RecircleAppConstants.ISLOGGEDINKEY)! {
            print("logged In")
        }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapCloseButton(_ sender: UIButton) {
        if let drawerController = parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
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
    
    
    
    @IBAction func arrowTapped(_ sender: AnyObject) {
        if let drawerController = parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
        }
    }

}

extension DrawerViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 174.0
        } else {
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            let cellHeader = tableView.dequeueReusableCell(withIdentifier: "cellHeader", for: indexPath) as! DrawerHeaderCell
            
            cellHeader.userImage.image = UIImage(named: "user")
            cellHeader.userName.text = "Meeta Lalwani"
            cellHeader.userEmail.text = "meeta.bijlani@synerzip.com"
            
            return cellHeader
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DrawerCell
        cell.imageView?.image = iconImages[indexPath.row]
        cell.label.text = itemName[indexPath.row]
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.section == 1 && indexPath.row == 2 {
            if let url = NSURL(string:"http://recirkle.com/#/help") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open( url as URL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        } else if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegue(withIdentifier: "login", sender: self)
        }

    }
}
