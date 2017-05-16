//
//  ListItemPhotosViewController.swift
//  Recircle
//
//  Created by synerzip on 16/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class ListItemPhotosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func crossTapped(_ sender: AnyObject) {
        
        self.dismiss(animated: true) { 
        
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

    @IBAction func proceed(_ sender: AnyObject) {
        performSegue(withIdentifier: "description", sender: self)
    }
}
