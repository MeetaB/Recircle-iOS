//
//  SearchViewController.swift
//  Recircle
//
//  Created by synerzip on 03/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import SearchTextField
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var prodSearchTextField: SearchTextField!
    
    @IBOutlet weak var buttonSearch: UIButton!
    
    @IBOutlet weak var textPayment: UILabel!
    
    @IBOutlet weak var textPickDrop: UILabel!
    
    @IBOutlet weak var textProtection: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var arrowProtection: UIButton!
    @IBOutlet weak var arrowPickDrop: UIButton!
    @IBOutlet weak var arrowPayment: UIButton!
    
    @IBOutlet weak var tablePopularItems: UITableView!
  
    @IBOutlet weak var tableRecentItems: UITableView!
    
    var productDetails : ProductDetails!
    
    var popularProducts : [Product] = []
    
    var recentProducts : [Product] = []

    
    var prodNames : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableRecentItems.dataSource = self
        tableRecentItems.delegate = self
        
        tablePopularItems.dataSource = self
        tablePopularItems.delegate = self
       
//        self.navigationBar.backgroundColor = UIColor(cgColor: UIColor.black as! CGColor)
        self.navigationItem.title = "New"
        locationTextField.leftViewMode = UITextFieldViewMode.always
        dateTextField.leftViewMode = UITextFieldViewMode.always
        prodSearchTextField.leftViewMode = UITextFieldViewMode.always
        
        let imageViewLocation = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        var image = UIImage(named: "location")
        imageViewLocation.image = image
        locationTextField.leftView = imageViewLocation
        
        let imageViewDate = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        image = UIImage(named : "calendar")
        imageViewDate.image = image
        let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.showCalendar))
        tapRecogniser.numberOfTapsRequired = 1;
        imageViewDate.addGestureRecognizer(tapRecogniser)
        imageViewDate.isUserInteractionEnabled = true
        dateTextField.leftView = imageViewDate
        
        
        let imageViewSearch = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        image = UIImage(named : "search")
        imageViewSearch.image = image
        prodSearchTextField.leftView = imageViewSearch

        prodSearchTextField.theme.font = UIFont.systemFont(ofSize: 16)
        prodSearchTextField.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 1)
        prodSearchTextField.theme.borderColor = UIColor (red: 0, green: 0, blue: 0, alpha: 1)
        prodSearchTextField.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        prodSearchTextField.theme.cellHeight = 50
        prodSearchTextField.filterStrings(["Red", "Blue", "Yellow"])
        
        buttonSearch.layer.cornerRadius = 5
        buttonSearch.layer.borderWidth = 1
        buttonSearch.layer.borderColor = UIColor.black.cgColor
        
        //testing
        Alamofire.request(URL(string: "http://e82462ca.ngrok.io/api/products/prodNames")!,
                          method: .get)
             .validate(contentType: ["application/json"])
            .responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let dataResponse = response.result.value {
               let json = JSON(dataResponse)
            //   print("JSON: \(json)")
//               print("name : \(json["productsData"].arrayValue.map({$0["product_manufacturer_name"].stringValue}))")
               
                for item in json["productsData"].arrayValue {
                    print(item["product_manufacturer_name"].stringValue)
                    let manufacturerName = item["product_manufacturer_name"].stringValue
                    self.prodNames.append(manufacturerName)
                    for subitem in item["products"].arrayValue {
                        print(subitem["product_title"].stringValue)
                        self.prodNames.append(manufacturerName + " " + subitem["product_title"].stringValue)
                    }
                    
                }
                self.prodSearchTextField.filterStrings(self.prodNames)
            }
        }
        
        //
        
        
        Alamofire.request(URL(string: "http://e82462ca.ngrok.io/api/products")!,
                          method: .get)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let dataResponse = response.result.value {
                    
               //     self.productDetails = dataResponse as! ProductDetails
                    let json = JSON(dataResponse)
                    print("JSON All Products: \(json)")
                    
                    
                    self.productDetails = ProductDetails(dictionary: json.object as! NSDictionary)
                    
                    if (self.productDetails != nil ) {
                        
                    self.popularProducts =  self.productDetails.popularProducts!
                    
                    self.recentProducts =  self.productDetails.productDetails!
                    
                    self.tableRecentItems.reloadData()
                    
                    self.tablePopularItems.reloadData()
                        
                    }
//                    else {
//                        self.tablePopularItems.isHidden = true
//                        self.tableRecentItems.isHidden = true
//                        
//                    }
                }
        }

        
           }
    
    
    override func viewDidLayoutSubviews() {
        scrollView.isScrollEnabled = true
        scrollView.contentSize=CGSize(width : 400,height : 2300);

//        tableRecentItems.frame = CGRect(x: tableRecentItems.frame.origin.x, y: tableRecentItems.frame.origin.y, width: tableRecentItems.frame.size.width, height: tableRecentItems.contentSize.height)
//        
//        tableRecentItems.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
     //   let bounds = tableRecentItems.bounds
        
//        tableRecentItems.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
        
//        tableRecentItems.frame = CGRect(x: tableRecentItems.frame.origin.x, y: tableRecentItems.frame.origin.y, width: tableRecentItems.frame.size.width, height: tableRecentItems.contentSize.height)


    }
    func showCalendar () {
        print("refresh")
        performSegue(withIdentifier: "datepicker", sender: nil)
        
        
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
    
    
    
    @IBAction func clickArrowProtection(_ sender: AnyObject) {
        
        if arrowProtection.backgroundImage(for: .normal) == UIImage(named: "collapse_arrow") {
            arrowProtection.setBackgroundImage(UIImage(named : "expand_arrow"), for: .normal)
            textProtection.isHidden = true

                   }
        else{
            arrowProtection.setBackgroundImage(UIImage(named : "collapse_arrow"), for: .normal)
            textProtection.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }


    }
    
    @IBAction func clickArrowPickDrop(_ sender: AnyObject) {
        
        if arrowPickDrop.backgroundImage(for: .normal) == UIImage(named: "collapse_arrow") {
            arrowPickDrop.setBackgroundImage(UIImage(named : "expand_arrow"), for: .normal)
            textPickDrop.isHidden = true
            
        }
        else{
            arrowPickDrop.setBackgroundImage(UIImage(named : "collapse_arrow"), for: .normal)
            textPickDrop.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
        

    }
    
    @IBAction func clickArrowPayment(_ sender: AnyObject) {
        
        if arrowPayment.backgroundImage(for: .normal) == UIImage(named: "collapse_arrow") {
            arrowPayment.setBackgroundImage(UIImage(named : "expand_arrow"), for: .normal)
            textPayment.isHidden = true
            
        }
        else{
            arrowPayment.setBackgroundImage(UIImage(named : "collapse_arrow"), for: .normal)
            textPayment.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProductCell
        
        let index = indexPath.row
        
        if self.productDetails != nil {
            
        print(self.productDetails.popularProducts?[index].product_info?.product_title)
        
        cell.textProductName.text = self.productDetails.popularProducts?[index].product_info?.product_title
            
        }
        
        if tableView == self.tableRecentItems {
            
            if (self.recentProducts.count > 0) {
                
                cell.textProductName.text = self.recentProducts[index].product_info?.product_title
                cell.textOwnerName.text = (self.recentProducts[index].user_info?.first_name)! + " " + (self.recentProducts[index].user_info?.last_name)!
                cell.viewRating.text =  String(describing: self.recentProducts[index].user_product_info?.product_avg_rating!)
                cell.imageProduct.setImageFromURl(stringImageUrl: (self.recentProducts[index].product_info?.product_image_url)!)
            }
       
        }

        if tableView == self.tablePopularItems {
            
            if (self.popularProducts.count > 0) {
                
                cell.textProductName.text = self.popularProducts[index].product_info?.product_title
                cell.textOwnerName.text = (self.popularProducts[index].user_info?.first_name)! + " " + (self.recentProducts[index].user_info?.last_name)!
                cell.viewRating.text =  String(describing: self.popularProducts[index].user_product_info?.product_avg_rating!)
                cell.imageProduct.setImageFromURl(stringImageUrl: (self.popularProducts[index].product_info?.product_image_url)!)
            }
            
        }

        return cell
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableRecentItems {

            return self.recentProducts.count
        } else {
            return self.popularProducts.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    }
