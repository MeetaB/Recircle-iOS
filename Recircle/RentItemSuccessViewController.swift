//
//  RentItemSuccessViewController.swift
//  Recircle
//
//  Created by synerzip on 26/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class RentItemSuccessViewController: UIViewController {

    @IBOutlet weak var btnViewRequests: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.navigationItem.setHidesBackButton(true, animated:false);
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goToAllRequests(_ sender: AnyObject) {

        self.performSegue(withIdentifier: "requests", sender: self)
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
