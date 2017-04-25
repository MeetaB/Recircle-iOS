//
//  SearchResultViewController.swift
//  Recircle
//
//  Created by synerzip on 20/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    public var products : [Product]!

    @IBOutlet weak var tableProducts: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        print(products.count)
        
        tableProducts.dataSource = self
        
        tableProducts.delegate = self
        
        let nib = UINib(nibName: "ProductCellView", bundle: nil)
        
        tableProducts.register(nib, forCellReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view.
        
        let view = Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)?.first as! UIView
      //  self.view.addSubview(view)
        
        self.view.insertSubview(view, at: 1)
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingToParentViewController {
            print("dismiss")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
        
        cell.prodName.text = products[indexPath.row].product_info?.product_title
        cell.prodOwner.text = (products[indexPath.row].user_info?.first_name)! + " " + (products[indexPath.row].user_info?.last_name)!
        
        if let userProdInfo = products[indexPath.row].user_product_info {
        
            cell.prodPrice.text = "$ " + String(describing: userProdInfo.price_per_day) + "/day"
            
        }

        cell.prodImage.setImageFromURl(stringImageUrl: (products[indexPath.row].product_info?.product_image_url)!)
        
        cell.prodRating.rating = Double((products[indexPath.row].user_product_info?.product_avg_rating)!)
        
        cell.prodRating.text = String(describing: products[indexPath.row].user_product_info?.product_avg_rating)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
