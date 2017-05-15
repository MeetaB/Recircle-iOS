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

class TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    public var userProdId : String!
    
    @IBOutlet weak var tableView: UITableView!
    
    var prodReviews : [UserProdReviews] = []
    
    var prodImagesURLs : [String] = []
    
    var progressBar : MBProgressHUD!
    
    var tapRecognizer : UITapGestureRecognizer!
    
    var product : Product!
    
    var indexImageSelected : Int = 0
    
    var prodName : String = ""
    
    var yOffset : CGFloat = 0.0
    
    public var navigation: UINavigationController?
    
    
    @IBOutlet weak var btnRent: UIButton!
    
    
    func getNavigationController() -> UINavigationController {
        return self.navigationController!
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        print(userProdId)
        
        navigation = self.navigationController
        
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
                    
                self.btnRent.titleLabel?.text = "Rent this item at " + "$ " + String(describing: self.product.user_product_info?.price_per_day) + " per day"
                    
//                    if let price = product?.user_product_info?.price_per_day {
//                        let btnText : String = "Rent this item at $ " + String(describing: price) + " per day"
//                        
//                        self.btnRent.setTitle(btnText, for: .normal)
//                    }
                    
                    self.prodName = (self.product.product_info?.product_title)!
                    
                    self.tableView.reloadData()
                }
                    
                else {
                    
                }
        }
        

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageView" {
            let vc =  segue.destination as! ProdImageViewController
            vc.prodImagesUrls = self.prodImagesURLs
            vc.imageUrl = prodImagesURLs[indexImageSelected]
        }
    }
    
    override func viewDidLayoutSubviews() {
        print(self.tableView.contentSize.height)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0  || section == 1 || section == 3 {
        return 1
        } else {
            let count = min(prodReviews.count,4)
            return count
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

            if prodImagesURLs.count > 1 {
                
                cell.prodImagesCollection.isHidden = false
                
                cell.prodImagesCollection.delegate = self
            
                cell.prodImagesCollection.dataSource = self
            
                cell.prodImagesCollection.reloadData()
                
                let nib = UINib(nibName: "ProductImageCell", bundle: nil)
                
                cell.prodImagesCollection.register(nib, forCellWithReuseIdentifier: "cell")

            } else {
                cell.prodImagesCollection.isHidden = true
            }
            
            if prodImagesURLs.count > 0 {
            cell.prodImage.setImageFromURl(stringImageUrl: prodImagesURLs[indexImageSelected])
            }
            
            print(cell.frame.maxY)
            
            //calculating this offset to display name of the product after this is scrolled
            self.yOffset = cell.frame.maxY
            
            
            
            return cell
        }
        else if indexPath.section == 1
        {
           let cell1 = tableView.dequeueReusableCell(withIdentifier: "cellDescription", for: indexPath) as! ProdDescTableViewCell
            
            cell1.txtProdName.text = product?.product_info?.product_title
            
            print(cell1.txtProdName.frame.maxY)
            
            if let imageUrl = product?.user_info?.user_image_url {
            
            cell1.userImage.setImageFromURl(stringImageUrl: imageUrl)
            
            }
            
            if product?.user_info != nil {
            cell1.txtOwnerName.text = (product?.user_info?.first_name)! + " " + (product?.user_info?.last_name)!
                
            }
            cell1.descTextView.text = product?.product_info?.product_description
            
            cell1.descTextView.shouldTrim = true
            
            cell1.descTextView.isUserInteractionEnabled = true
            
            cell1.descTextView.maximumNumberOfLines = 2
            
            cell1.descTextView.attributedReadLessText = NSAttributedString(string : " .. Read Less")
            
            cell1.descTextView.attributedReadMoreText = NSAttributedString(string : " .. Read More")
            
            cell1.descTextView.setNeedsUpdateTrim()
            
            cell1.descTextView.layoutIfNeeded()
            
            cell1.condnTextView.text = product?.user_product_info?.user_prod_desc
            
            
                
            if let rating = product?.user_product_info?.product_avg_rating {
                
                if rating > 0 {
                    cell1.prodRatingView.isHidden = false
                    cell1.prodRatingView.isUserInteractionEnabled = false
                    cell1.prodRatingView.rating = Double(rating)
                    cell1.prodRatingView.text = "(" + String(describing: rating) + ")"
                    
                    cell1.renterRatingView.isHidden = false
                    cell1.renterRatingView.isUserInteractionEnabled = false
                    cell1.renterRatingView.rating = Double(rating)
                    cell1.renterRatingView.text = "(" + String(describing: rating) + ")"
                    } else {
                    cell1.renterRatingView.isHidden = true
                    cell1.prodRatingView.isHidden = true
                    }
                cell1.btnSeeAllReviews.addTarget(self, action: #selector(TestViewController.goToReviews(_:)), for: .touchUpInside)
                cell1.btnAllReviews.addTarget(self, action: #selector(TestViewController.goToReviews(_:)), for: .touchUpInside)
            } else {
                cell1.renterRatingView.isHidden = true
                cell1.prodRatingView.isHidden = true
            }
            
            cell1.selectionStyle = .none
            
            return cell1
        }
        else if indexPath.section == 2
        {
            if indexPath.row <= 3 {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cellReview", for: indexPath) as! ReviewTableViewCell
            
                if prodReviews.count > 0 {
                    cell2.userName.text = prodReviews[indexPath.row].user?.first_name
                    cell2.userImage.setImageFromURl(stringImageUrl: (prodReviews[indexPath.row].user?.user_image_url!)!)
                    cell2.userReviewText?.text = prodReviews[indexPath.row].prod_review
                }
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
    //
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let indexPathTable = NSIndexPath(row: 0, section: 0)
        let tableCell = tableView.cellForRow(at: indexPathTable as IndexPath) as! ProdImagesTableViewCell
        print(prodImagesURLs[indexPath.item])
        tableCell.prodImage.setImageFromURl(stringImageUrl: prodImagesURLs[indexPath.item])
        indexImageSelected = indexPath.item
        tableView.reloadRows(at: [indexPathTable as IndexPath], with: .none)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.prodImagesURLs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProdImageCellView
            if prodImagesURLs.count > 0 {
                cell.productImage.setImageFromURl(stringImageUrl: prodImagesURLs[indexPath.item])
                return cell
            }
        return UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print("scroll view")
        print(tableView.contentOffset.y)
        if tableView.contentOffset.y >= self.yOffset {
            self.title = self.prodName
        } else {
            self.title = ""
        }
        
    }
    
    func goToReviews(_ sender: AnyObject){
        
        performSegue(withIdentifier: "allReviews", sender: self)
    }
    
    @IBAction func rentItem(_ sender: AnyObject) {
        
        CalendarState.productDetail = true
//        performSegue(withIdentifier: "datePicker", sender: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController2 = storyboard.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        self.present(navController2, animated: true, completion: nil)
    }
  
  
}
