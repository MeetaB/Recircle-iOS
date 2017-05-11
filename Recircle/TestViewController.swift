//
//  TestViewController.swift
//  Recircle
//
//  Created by synerzip on 10/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON

class TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate
{
    
    public var userProdId : String!
    
    @IBOutlet weak var tableView: UITableView!
    
    var prodReviews : [UserProdReviews] = []
    
    var prodImagesURLs : [String] = []
    
    var progressBar : MBProgressHUD!
    
    var tapRecognizer : UITapGestureRecognizer!
    
    var product : Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(userProdId)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.black

        
        let nib = UINib(nibName: "RenterReviewView", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "cellReview")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getProdDetails()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageLongPressed(_:)))
        
        tapRecognizer.numberOfTapsRequired = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageLongPressed (_ sender : AnyObject) {
        
        self.performSegue(withIdentifier: "imageView", sender: self)
    }
    

    func getProdDetails() {
        
        let url = RecircleWebConstants.ProductsApi + "/" + userProdId
        
        progressBar = MBProgressHUD.showAdded(to: self.view, animated: true);
        
        progressBar.mode = MBProgressHUDMode.indeterminate
        
        progressBar.label.text = "Loading";
        
        progressBar.isUserInteractionEnabled = false;
        
        
        Alamofire.request(URL(string: url)!,
                          method: .get)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                self.progressBar.hide(animated: true)
                
                if let dataResponse = response.result.value {
                    
                    let json = JSON(dataResponse)
                    print("JSON Product: \(json)")
                    
                    self.product = Product.init(dictionary: json.object as! NSDictionary)
                    
        
                    if let prodImages = self.product?.user_product_info?.user_prod_images {
                        for image in prodImages {
                            if !(image.user_prod_image_url?.isEmpty)! {
                                self.prodImagesURLs.append(image.user_prod_image_url!)
                                
                            }
                        }
                    }
                    
                   self.prodReviews = (self.product?.user_product_info?.user_prod_reviews)!
                    
                    self.navigationController?.title = self.product?.product_info?.product_title
                    
//                    if let price = product?.user_product_info?.price_per_day {
//                        let btnText : String = "Rent this item at $ " + String(describing: price) + " per day"
//                        
//                        self.btnRent.setTitle(btnText, for: .normal)
//                    }
                    
                    self.tableView.reloadData()
                }
                    
                else {
                    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0  || section == 1 || section == 3 {
        return 1
        } else {
            return 4
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellImages", for: indexPath) as! ProdImagesTableViewCell
            
            cell.prodImage.isUserInteractionEnabled = true
            
            cell.prodImage.addGestureRecognizer(tapRecognizer)

            cell.prodImagesCollection.reloadData()
            
            cell.prodImage.setImageFromURl(stringImageUrl: prodImagesURLs[0])
            
            print(cell.frame.maxY)
            
            
            
            return cell
        }
        else if indexPath.section == 1
        {
           let cell1 = tableView.dequeueReusableCell(withIdentifier: "cellDescription", for: indexPath) as! ProdDescTableViewCell
            
            cell1.txtProdName.text = product?.product_info?.product_title
            
            if let imageUrl = product?.user_info?.user_image_url {
            
            cell1.userImage.setImageFromURl(stringImageUrl: imageUrl)
            
            }
                
            cell1.txtOwnerName.text = (product?.user_info?.first_name)! + " " + (product?.user_info?.last_name)!
                
            cell1.descTextView.text = product?.product_info?.product_description
                
            cell1.condnTextView.text = product?.user_product_info?.user_prod_desc
                
            if let rating = product?.user_product_info?.product_avg_rating {
                
                if rating > 0 {
                    cell1.renterRatingView.isHidden = false
                    cell1.renterRatingView.rating = Double(rating)
                    cell1.renterRatingView.text = "(" + String(describing: rating) + ")"
                    } else {
                    cell1.renterRatingView.isHidden = true
                    }
                                        
            }

            
            return cell1
        }
        else if indexPath.section == 2
        {
            if indexPath.row <= 3 {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cellReview", for: indexPath) as! ReviewTableViewCell
            
            cell2.userName.text = prodReviews[indexPath.row].user?.first_name
            cell2.userImage.setImageFromURl(stringImageUrl: (prodReviews[indexPath.row].user?.user_image_url!)!)
            cell2.userReviewText?.text = prodReviews[indexPath.row].prod_review
            return cell2
            } else {
                return UITableViewCell()
            }
            
        }
        else  {
             let cell3 = tableView.dequeueReusableCell(withIdentifier: "cellAddress", for: indexPath) as! ProdAddressTableViewCell
            return cell3
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 261
        }
        else if indexPath.section == 1 {
        return 381
        } else if indexPath.section == 2 {
            return 157
        } else {
            return 169
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print("scroll view")
        print(tableView.contentOffset.y)
        
    }
    
}
