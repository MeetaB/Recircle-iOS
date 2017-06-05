//
//  ListItemSuccessViewController.swift
//  Recircle
//
//  Created by synerzip on 23/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class ListItemSuccessViewController: UIViewController {

    public var listedProductId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        
        print(listedProductId)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func viewItemTapped(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "viewProduct", sender: self)
    }
    
    
    @IBAction func listItemTapped(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "listItem", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewProduct" {
            let vc = segue.destination as! TestViewController
            vc.userProdId = self.listedProductId
        }
    }
    

}
