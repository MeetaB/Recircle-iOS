//
//  ListItemSummaryViewController.swift
//  Recircle
//
//  Created by synerzip on 22/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD


struct ListItemObject {
    static var listItem : ListItem!
    static var listItemImages : [UIImage]!
    static var listItemName : String!
    static var listItemUnavailableCount : Int!
}


class ListItemSummaryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var listItem : ListItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var txtProdName: UILabel!
    
    @IBOutlet weak var txtRentalPrice: UILabel!
    
    @IBOutlet weak var txtRentDays: UILabel!
    
    @IBOutlet weak var txtDiscount1: UILabel!
    
    @IBOutlet weak var txtDiscount2: UILabel!
    
    @IBOutlet weak var txtDescription: UILabel!
    
    @IBOutlet weak var txtListingDays: UILabel!
    
    @IBOutlet weak var txtUnavailableDates: UILabel!
    
    var listedProductId : String!
    
    var prodImages : [UIImage] = []
    
    var progressBar : MBProgressHUD!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x2C3140)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        self.listItem = ListItemObject.listItem
        
        let nib = UINib(nibName: "ProductImageCell", bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        if let price = listItem.price_per_day {
            txtRentalPrice.text = String(describing: price)
        }
        
        if let days = listItem.min_rental_day {
            txtRentDays.text = String(describing: days)
        }
        
        if (listItem.user_prod_discounts?.count)! == 1 {
            self.txtDiscount1.text = "30% discount for 5 days"
        } else if (listItem.user_prod_discounts?.count)! == 2 {
            self.txtDiscount1.text = "30% discount for 5 days"
            self.txtDiscount2.text = "40% discount for 10 days"
        }
        
        txtDescription.text = listItem.user_prod_desc
        
        txtUnavailableDates.text = String(describing: listItem.user_prod_unavailability?.count) + " days"
        
        txtUnavailableDates.text = String(ListItemObject.listItemUnavailableCount) + " days"
        
        txtProdName.text = ListItemObject.listItemName
        
        prodImages = ListItemObject.listItemImages
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize=CGSize(width : self.view.frame.width,height : 700);
    }
    
    
    @IBAction func showDates(_ sender: AnyObject) {
        
        CalendarState.listItemSummary = true
        self.performSegue(withIdentifier: "datePicker", sender: self)
        
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "success" {
            let vc = segue.destination as! ListItemSuccessViewController
            vc.listedProductId = self.listedProductId
        }
     }
    
    
    @IBAction func listItem(_ sender: AnyObject) {
        
        progressBar = MBProgressHUD.showAdded(to: self.view, animated: true);
        
        progressBar.mode = MBProgressHUDMode.indeterminate
        
        progressBar.label.text = "Loading";
        
        progressBar.isUserInteractionEnabled = false;
        
        //Hardcoding as it is not merged with s3 bucket yet
        let user_prod_images : UserProdImages = UserProdImages(createdAt: "2017-06-05", imageUrl: "https://s3.ap-south-1.amazonaws.com/recircleimages/1398934243000_1047081.jpg")
        let images = user_prod_images.dictionaryRepresentation()

        var discountsDict : [NSDictionary] = []
        
        if let discounts = listItem.user_prod_discounts {

            for discount in discounts {
                discountsDict.append (discount.dictionaryRepresentation())
            }
        }
        
        var unavailableDict : [NSDictionary] = []
        
        if let unavailableDates = listItem.user_prod_unavailability {
            
            for unavailableDate in unavailableDates {
                unavailableDict.append (unavailableDate.dictionaryRepresentation())
            }
        }
        
        
        if let productId = listItem.product_id,
            let productTitle = txtProdName.text,
            let price = listItem.price_per_day,
            let minRentDays = listItem.min_rental_day,
            let description = listItem.user_prod_desc,
            let zipcode = listItem.user_product_zipcode,
            let fromAustin = listItem.fromAustin
        {
            let parameters : [String : Any] = ["product_id" : productId as Any ,
                                                     "product_title" : productTitle as Any,
                                                     "price_per_day" : price as Any,
                                                     "min_rental_days" : minRentDays as Any,
                                                     "user_prod_desc" : description as Any,
                                                     "user_prod_discounts" : discountsDict as Any,
                                                     "user_prod_images" : images as Any,
                                                     "user_prod_unavailability" : unavailableDict as Any,
                                                     "user_product_zipcode" : zipcode as Any,
                                                     "fromAustin" : fromAustin as Any]
            
            print(parameters)
            
            if let token = KeychainWrapper.standard.string(forKey: RecircleAppConstants.TOKENKEY) {
                
                print(token)
                
                let headers = [
                    "content-type": "application/json",
                    "authorization" : "Bearer "+token
                ]
                
                print(headers)
                
                //  let headers : [String : String] = ["authorization" : "Bearer "+token]
                
                
                Alamofire.request(URL(string: RecircleWebConstants.ProductsApi)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    //        Alamofire.request(URL(string: RecircleWebConstants.ProductsApi)!,
                    //                          method: .post, parameters: parameters)
                    // .validate(contentType: ["application/json"])
                    .responseJSON { response in
                        
                        //  self.progressBar.hide(animated: true)
                        
                        print(response.request)  // original URL request
                        print(response.response) // HTTP URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        self.progressBar.hide(animated: true)

                        
                        if let dataResponse = response.result.value {
                            let json = JSON(dataResponse)
                            print("JSON SearchApi: \(json)")
                            
                            if response.response?.statusCode == 200 {
                                self.listedProductId = json["user_product_id"].string
                                self.performSegue(withIdentifier: "success", sender: self)
                            }
                        }
                            
                        else {
                            self.progressBar.hide(animated: true)

                        }
                }
            } else {
                self.progressBar.hide(animated: true)
            }
        }
        
    }
    
    
    //Collection View Methods
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prodImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProdImageCellView
        
        cell.productImage.image = prodImages[indexPath.item]
        
        return cell
    }
    
    
    @IBAction func editTapped(_ sender: AnyObject) {
        
      _ =  self.navigationController?.popViewController(animated: true)
        
    }
    
}


// MARK: UICollectionViewDelegateFlowLayout protocol methods
extension ListItemSummaryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100 , height: 100)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // if section == 2 {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
        //}
    }
}


