//
//  RentSummaryViewController.swift
//  Recircle
//
//  Created by synerzip on 15/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class RentSummaryViewController: UIViewController {

    public var rentItem : RentItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(rentItem.order_from_date)
        print(rentItem.price_per_day)
        
       // setUpNavigationBar()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Summary"

        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    func setUpNavigationBar(){
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:44)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.white
        
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Title"
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(RentSummaryViewController.btn_clicked(_:)))
        
        let rightButton = UIBarButtonItem(title: "Right", style: .plain, target: self, action: nil)
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
       // self.view.addSubview(navigationBar)

    }
    
    func btn_clicked(_ sender: UIBarButtonItem) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let testVC = storyboard.instantiateViewController(withIdentifier: "TestVC") as! TestViewController
//        self.navigationController?.popToViewController(testVC, animated: true)
//
        _ = self.navigationController?.popViewController(animated: true)
        
//            self.dismiss(animated: true) {
//       }
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
