//
//  ProductDetailViewController.swift
//  Recircle
//
//  Created by synerzip on 03/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ReadMoreTextView
import Cosmos
import MBProgressHUD

class ProductDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {

    public var userProdId : String!
    
    @IBOutlet weak var prodImage: UIImageView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var prodImagescollection: UICollectionView!
    
    @IBOutlet weak var descriptionTextView: ReadMoreTextView!
    
    @IBOutlet weak var prodName: UILabel!
    
    @IBOutlet weak var prodRating: CosmosView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var descriptionText: ReadMoreTextView!
    
    @IBOutlet weak var conditionText: ReadMoreTextView!
    
    @IBOutlet weak var reviewRating: CosmosView!
    
    @IBOutlet weak var tableReviews: UITableView!
    
    @IBOutlet weak var btnRent: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var prodReviews : [UserProdReviews] = []
    
    var prodImagesURLs : [String] = []
    
    var progressBar : MBProgressHUD!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(userProdId)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
        let nib = UINib(nibName: "RenterReviewView", bundle: nil)
        
        tableReviews.register(nib, forCellReuseIdentifier: "cell")

        tableReviews.dataSource = self
        tableReviews.delegate = self
        
        // Do any additional setup after loading the view.
            
        let url = RecircleWebConstants.ProductsApi + "/" + userProdId
        
        progressBar = MBProgressHUD.showAdded(to: self.view, animated: true);
        
        progressBar.mode = MBProgressHUDMode.indeterminate
        
        progressBar.label.text = "Loading";
        
        progressBar.isUserInteractionEnabled = false;
        

        prodRating.isUserInteractionEnabled = false
        
        reviewRating.isUserInteractionEnabled = false
        
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
                    
                    let product = Product.init(dictionary: json.object as! NSDictionary)
                    
                    self.prodName.text = product?.product_info?.product_title
                    
                   
                    
                    if let prodImages = product?.user_product_info?.user_prod_images {
                        for image in prodImages {
                            if !(image.user_prod_image_url?.isEmpty)! {
                            self.prodImagesURLs.append(image.user_prod_image_url!)
                                
                            }
                        }
                        self.prodImagescollection.reloadData()
                         self.prodImage.setImageFromURl(stringImageUrl: (prodImages[0].user_prod_image_url)!)
                    }
                    
                    if let imageUrl = product?.user_info?.user_image_url {
                    self.userImage.setImageFromURl(stringImageUrl: imageUrl)
                    }
                    
                    self.userName.text = (product?.user_info?.first_name)! + " " + (product?.user_info?.last_name)!
                    
                    self.descriptionText.text = product?.product_info?.product_category_description
                    
                    self.conditionText.text = product?.user_product_info?.user_prod_desc
                    
                    
                    
                    if let rating = product?.user_product_info?.product_avg_rating {
                        
                        if rating > 0 {
                            self.reviewRating.isHidden = false
                            self.reviewRating.rating = Double(rating)
                            self.reviewRating.text = "(" + String(describing: rating) + ")"
                        } else {
                            self.reviewRating.isHidden = true
                        }

                    }
                    
                    self.prodReviews = (product?.user_product_info?.user_prod_reviews)!
                    
                    self.tableReviews.reloadData()
                    
                    self.navigationController?.title = product?.product_info?.product_title
                    
                    if let price = product?.user_product_info?.price_per_day {
                    let btnText : String = "Rent this item at $ " + String(describing: price) + " per day"
                    
                    self.btnRent.setTitle(btnText, for: .normal)
                    }
                }
                    
                else {
                    
                }
        }
        
        descriptionTextView.shouldTrim = true
        descriptionTextView.maximumNumberOfLines = 2
        descriptionTextView.attributedReadMoreText = NSAttributedString(string: "... See more")
        descriptionTextView.attributedReadLessText = NSAttributedString(string: " See less")
        
        conditionText.shouldTrim = true
        conditionText.maximumNumberOfLines = 2
        conditionText.attributedReadMoreText = NSAttributedString(string: "... See more")
        conditionText.attributedReadLessText = NSAttributedString(string: " See less")
    
        let longPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageLongPressed(_:)))
    
        longPressRecognizer.numberOfTapsRequired = 1
        
    
        self.prodImage.isUserInteractionEnabled = true

        self.prodImage.addGestureRecognizer(longPressRecognizer)
        
        
    }
    
    func imageLongPressed (_ sender : AnyObject) {
        
        self.performSegue(withIdentifier: "imageView", sender: self)
    }

    @IBAction func locationTapped(_ sender: AnyObject) {
        
        UIApplication.shared.canOpenURL(URL(string:"https://www.google.com/maps/@42.585444,13.007813,6z")!)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.layer.masksToBounds = true
        
        scrollView.isScrollEnabled = true
        scrollView.contentSize=CGSize(width : self.view.frame.width,height : 1400);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CalendarState.productDetail {
            print(CalendarState.startDate)
            CalendarState.productDetail = false
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prodImagesURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProdImageCellView
        
        cell.productImage.setImageFromURl(stringImageUrl: prodImagesURLs[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProdImageCellView
        cell.productImage.backgroundColor = UIColor.blue

        self.prodImage.setImageFromURl(stringImageUrl: prodImagesURLs[indexPath.row])
    }
    
    
    @IBAction func rentItem(_ sender: AnyObject) {
        
        CalendarState.productDetail = true
        performSegue(withIdentifier: "datePicker", sender: self)
    }
    
    // Table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.prodReviews.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewTableViewCell
        
        let review = self.prodReviews[indexPath.row]
        
        cell.userImage.setImageFromURl(stringImageUrl: (review.user?.user_image_url)!)
        
        cell.userImage.layer.cornerRadius = userImage.frame.size.width/2
        
        cell.userImage.layer.masksToBounds = true

        
        cell.userName.text = (review.user?.first_name)! + " " + (review.user?.last_name)!
        
        if let rating = review.prod_rating {
            
            if rating>0 {
                cell.userRating.isUserInteractionEnabled = false
                cell.userRating.isHidden = false
                cell.userRating.rating = Double(rating)
                cell.userRating.text = "(" + String(describing: rating) + ")"
            } else {
                cell.userRating.isHidden = true
            }
        }
    
        
        cell.userReviewText.text = review.prod_review
        
        cell.userReviewText.shouldTrim = true
        
        cell.userReviewText.maximumNumberOfLines = 2
                
        return cell
    }
    
    
    @IBAction func goToAllReviews(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let allReviewVC = storyboard.instantiateViewController(withIdentifier: "AllReviewsVC") as! AllReviewsTableViewController
        
        allReviewVC.allReviews = prodReviews
        
        self.navigationController?.pushViewController(allReviewVC, animated: true)
    }

//    @IBAction func goToAllReviews(_ sender: AnyObject) {
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let allReviewVC = storyboard.instantiateViewController(withIdentifier: "AllReviewsVC") as! AllReviewsTableViewController
//        
//        allReviewVC.allReviews = prodReviews
//        
//        self.navigationController?.pushViewController(allReviewVC, animated: true)
//        
//        
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "imageView" {
           let vc =  segue.destination as! ProdImageViewController
            vc.prodImagesUrls = self.prodImagesURLs
            vc.imageUrl = prodImagesURLs[0]
        }
    }
    

    
    
}
