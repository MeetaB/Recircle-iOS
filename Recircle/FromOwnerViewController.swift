//
//  FromOwnerViewController.swift
//  Recircle
//
//  Created by synerzip on 07/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class FromOwnerViewController: UIViewController {

   
    @IBOutlet weak var tableView: UITableView!
    
    var ownerMessages : [ProdMsgs] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.parent?.tabBarController?.tabBar.isHidden = true
//        
//        self.parent?.tabBarController?.tabBar.frame.size.height = 0.0
        
        let parent = self.tabBarController as! MessagesTabBarController
        
        ownerMessages = parent.fromOwnerMessages
        
        print(ownerMessages)
        
        let messagesTabBar = self.tabBarController as! MessagesTabBarController
        
        print(messagesTabBar.test)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
    

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("view did appear")
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        let nib = UINib(nibName: "MessageCellView", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        if ownerMessages.count > 0 {
            tableView.reloadData()
        }

        
      //  tableView.register(nib, forCellReuseIdentifier: "cell")
        
    }
    
    override func loadView() {
        print("load view")
    }
    
    func getOwnerMessages(_ msgs : [ProdMsgs]) {
        self.ownerMessages = msgs
        print("ownermessages \(ownerMessages.count)")
        if tableView != nil  {
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

}


extension FromOwnerViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ownerMessages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCellView
        
        let index = indexPath.row
        
        cell.txtUserName.text = ownerMessages[index].user?.first_name
        
        cell.txtProdName.text = ownerMessages[index].user_product?.product?.product_title
        //
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'00:00:000'Z'"
        
        let date = formatter.date(from: ownerMessages[index].created_at!)
        
        formatter.dateFormat = "dd MMM,yyyy"
        
        formatter.string(from: date!)
        
        formatter.dateFormat = "yyyy-MM-dd'T'00:00:000'Z'"
        
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.day,.month,.year], from: Date.init())
        
        let currentYear =  components.year
        let currentMonth = components.month
        let currentDay = components.day

        components = calendar.dateComponents([.day,.month,.year,.hour,.minute], from: date!)
        let msgDate = components.day
        let msgMonth = components.month
        let msgYear =  components.year
        let msgHour = components.hour
        let msgMin = components.minute
        
        let months = formatter.monthSymbols
        let monthSymbol = months?[msgMonth!-1]
        
        
        var dateText : String = ""
        
        if currentYear == msgYear {
            
                if currentDay == msgDate {
                    
                    dateText = String(describing: msgHour) + ":" + String(describing: msgMin)
                } else {
                    dateText = String(describing: msgDate) + monthSymbol!
                }
            
        } else {
            dateText = String(describing: msgYear) + String(describing: msgDate) + monthSymbol!
        }
        
        
        print(dateText)
        
        //
        cell.txtDate.text = dateText
        
        cell.txtMessage.text = ownerMessages[index].user_msg
        
        cell.userImage.setImageFromURl(stringImageUrl: (ownerMessages[index].user?.user_image_url!)!)
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
}
