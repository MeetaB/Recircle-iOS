//
//  MessagesTabBarController
//  Recircle
//
//  Created by synerzip on 08/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MessagesTabBarController: UITabBarController {
    
    public var fromOwnerMessages : [ProdMsgs] = []
    
    public var fromRenterMessages : [ProdMsgs] = []
    
    var test : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test = "test"
        
        getAllMessages()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getAllMessages () {
        
        let url = URL(string: RecircleWebConstants.MESSAGESAPI)
        
        if let token = KeychainWrapper.standard.string(forKey: RecircleAppConstants.TOKENKEY) {
            
            let headers : HTTPHeaders = ["content-type" : "application/json",
                                         "authorization" : "Bearer " + token]
            
            Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    
                    print(response.data)
                    
                    if let value = response.result.value {
                            let json = JSON(value)
                            print(json)
                           let messages = Messages.init(dictionary: json.object as! NSDictionary)
                            self.fromRenterMessages = (messages?.ownerRequestMsgs)!
                            self.fromOwnerMessages = (messages?.ownerProdRelatedMsgs)!
                        
                        
                        print(self.tabBarController?.selectedViewController?.childViewControllers[0])
                        
                            let ownerVC = self.viewControllers?[1] as! FromOwnerViewController1
                        
                            ownerVC.ownerMessages = self.fromOwnerMessages
                        
                            let renterVC = self.viewControllers?[0] as! FromRenterViewController
                        
                        renterVC.renterMessages = self.fromRenterMessages
                        
                        renterVC.getMessages()
                        
//                            ownerVC.getOwnerMessages(self.fromOwnerMessages)
                    }
                    
            }
            
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
