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
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var prodReviews : [UserProdReviews] = []
    
    
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
        
        Alamofire.request(URL(string: url)!,
                          method: .get)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let dataResponse = response.result.value {
                    
                    let json = JSON(dataResponse)
                    print("JSON Product: \(json)")
                    
                    let product = Product.init(dictionary: json.object as! NSDictionary)
                    
                    self.prodName.text = product?.product_info?.product_title
                    
                    self.prodImage.setImageFromURl(stringImageUrl: (product?.user_product_info?.user_prod_images?[0].user_prod_image_url)!)
                    
                    self.userImage.setImageFromURl(stringImageUrl: (product?.user_info?.user_image_url)!)
                    
                    self.userName.text = (product?.user_info?.first_name)! + " " + (product?.user_info?.last_name)!
                    
                    self.descriptionText.text = product?.product_info?.product_description
                    
                    self.conditionText.text = product?.user_product_info?.user_prod_desc
                    
                    self.reviewRating.rating = Double((product?.user_product_info?.product_avg_rating)!)
                    
                    if let rating = product?.user_product_info?.product_avg_rating {
                        self.reviewRating.text = "(" + String(describing: rating) + ")"

                    }
                    
                    self.prodReviews = (product?.user_product_info?.user_prod_reviews)!
                    
                    self.tableReviews.reloadData()
                    
                    self.navigationController?.title = product?.product_info?.product_title
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    
    @IBAction func rentItem(_ sender: AnyObject) {
        
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
        
        cell.userName.text = (review.user?.first_name)! + " " + (review.user?.last_name)!
        
        cell.userRating.rating = Double(review.prod_rating!)
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}
