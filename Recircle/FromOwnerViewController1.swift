//
//  FromOwnerViewController1.swift
//  Recircle
//
//  Created by synerzip on 14/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class FromOwnerViewController1: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var ownerMessages : [ProdMsgs] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        let nib = UINib(nibName: "MessageCellView", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        if ownerMessages.count > 0 {
            tableView.reloadData()
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

    
    func setUpDate(_ createdDate : String) -> String{
    
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
        
        var dateText : String = ""
        
        if let date = formatter.date(from: createdDate) {
            
            print(date)
            
            let calendar = NSCalendar.current
            var components = calendar.dateComponents([.day,.month,.year], from: Date.init())
            
            let currentYear =  components.year
            let currentMonth = components.month
            let currentDay = components.day
            
            components = calendar.dateComponents([.day,.month,.year,.hour,.minute], from: date)
            let msgDate  = components.day
            let msgMonth = components.month
            let msgYear =  components.year
            let msgHour = components.hour
            let msgMin = components.minute
            
            let months = formatter.monthSymbols
            let monthSymbol = months?[msgMonth!-1]
            
            
            
            
            if currentYear == msgYear {
                
                if currentDay == msgDate {
                    
                    dateText = String(describing: msgHour!) + ":" + String(describing: msgMin!)
                } else {
                    dateText = String(describing: msgDate!) + " " + monthSymbol!
                }
                
            } else {
                dateText = String(describing: msgYear) + " " + String(describing: msgDate) +  " " + monthSymbol!
            }
            
        }
            return dateText
    }
}


extension FromOwnerViewController1 : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ownerMessages.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView != nil {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCellView
            
            let index = indexPath.row
            
            cell.txtUserName.text = (ownerMessages[index].user?.first_name)! + " " + (ownerMessages[index].user?.last_name)!
            
            cell.txtProdName.text = ownerMessages[index].user_product_id
            
            print(ownerMessages[index].user_product?.user_prod_desc)
            
            if let createdDate = ownerMessages[index].created_at {
                
                print(createdDate)
                
                let dateText = setUpDate(createdDate)
                
                print(dateText)
                    
                cell.txtDate.text = dateText
            }
            
            cell.txtMessage.text = ownerMessages[index].user_msg
            
            if let imageURL = ownerMessages[index].user?.user_image_url {
                cell.userImage.setImageFromURl(stringImageUrl: imageURL)
            }
            
            return cell
            
        } else {
            return UITableViewCell()
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
}

