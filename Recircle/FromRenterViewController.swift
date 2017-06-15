//
//  FromRenterViewController
//  Recircle
//
//  Created by synerzip on 08/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class FromRenterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var renterMessages : [ProdMsgs] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("did appear")
        
        print(renterMessages.count)
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        let nib = UINib(nibName: "MessageCellView", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        if renterMessages.count > 0 {
            tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        print("will appear")
    }
    
    func getMessages() {
        print(renterMessages[0].user_prod_msg_id)
        tableView.reloadData()
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

extension FromRenterViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return renterMessages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView != nil {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCellView
        
        let index = indexPath.row
        
        cell.txtUserName.text = renterMessages[index].user?.first_name
        
        cell.txtProdName.text = renterMessages[index].user_product?.product?.product_title
        
        cell.txtDate.text = renterMessages[index].created_at
        
        if let imageURL = renterMessages[index].user?.user_image_url {
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

