//
//  RentSummaryViewController.swift
//  Recircle
//
//  Created by synerzip on 15/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class RentSummaryViewController: UIViewController,UITextFieldDelegate {

    public var rentItem : RentItem!
    
    @IBOutlet weak var txtDuration: UILabel!
    
    @IBOutlet weak var txtFromDate: UILabel!
    
    @IBOutlet weak var txtEndDate: UILabel!
    
    @IBOutlet weak var txtSubTotal: UILabel!
    
    @IBOutlet weak var txtPricePerDay: UILabel!
    
    @IBOutlet weak var txtDiscount: UILabel!
    
    @IBOutlet weak var txtTotal: UILabel!
    
    @IBOutlet weak var btnPay: UIButton!
    
    @IBOutlet weak var prodImageView: UIImageView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var prodTitle: UILabel!
    
    @IBOutlet weak var txtUserName: UILabel!
    
    @IBOutlet weak var txtMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(rentItem.order_from_date)
        print(rentItem.order_to_date)
        print(rentItem.price_per_day)
        
       // setUpNavigationBar()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Summary"

         self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x2C3140)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        

        
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
        txtMessage.delegate = self

        setUpData()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setUpData(){
        
        txtUserName.text = rentItem.user_name
        
        prodTitle.text = rentItem.product_title
        
        prodImageView.setImageFromURl(stringImageUrl: rentItem.prod_image_url!)
        
        if let userImage = rentItem.user_image_url {
        userImageView.setImageFromURl(stringImageUrl: userImage)
        }
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.layer.masksToBounds = true
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'00:00:000'Z'"
        
        if let fromDate = rentItem.order_from_date {
            
            if let endDate = rentItem.order_to_date {
            
            let dateFrom = formatter.date(from:fromDate)
             let dateTo = formatter.date(from:endDate)
            
            formatter.dateFormat = "MMM d, yyyy"
            txtFromDate.text = formatter.string(from:dateFrom!)
            txtEndDate.text = formatter.string(from:dateTo!)
        }
        }
        
       // txtEndDate.text = formatter.string(for: rentItem.order_to_date)
        
        if let duration = rentItem.duration {
        txtDuration.text =
            String(describing: duration) + " days"
        
        if let price = rentItem.price_per_day {
            txtPricePerDay.text = "$ " + String(describing: price) + "/day"
            let subTotal = price * duration
            txtSubTotal.text = "$" + String(subTotal)
            txtTotal.text = "$" + String(subTotal)
            btnPay.setTitle("Pay $" + String(subTotal), for: .normal)
        }
        }
        
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
    
    
     @IBAction func editDates(_ sender: AnyObject) {
        
     }
 

    
    @IBAction func confirmOrder(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "success", sender: self)
    }
    
}
