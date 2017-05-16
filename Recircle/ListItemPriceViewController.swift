//
//  ListItemPriceViewController.swift
//  Recircle
//
//  Created by synerzip on 16/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class ListItemPriceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x2C3140)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func next(_ sender: AnyObject) {
        
//        performSegue(withIdentifier: "photos", sender: self)
//        
        let popoverContent = (self.storyboard?.instantiateViewController(withIdentifier: "ListItemPhotosViewController"))! as UIViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width :500,height : 600)
       // popover?.delegate = self
        popover?.sourceView = self.view
        popover?.accessibilityNavigationStyle = .separate
        popover?.sourceRect = CGRect(x: 0, y : 0, width : 100,height : 100)
        
        self.present(nav, animated: true, completion: nil)

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
