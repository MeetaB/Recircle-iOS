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

class SearchViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var prodSearchTextField: SearchTextField!
    
    @IBOutlet weak var buttonSearch: UIButton!
    
    @IBOutlet weak var textPayment: UILabel!
    
    @IBOutlet weak var textPickDrop: UILabel!
    
    @IBOutlet weak var textProtection: UILabel!
    
    @IBOutlet weak var arrowProtection: UIButton!
    @IBOutlet weak var arrowPickDrop: UIButton!
    @IBOutlet weak var arrowPayment: UIButton!
    
    @IBOutlet weak var tablePopularItems: UITableView!
    
    @IBOutlet weak var tableRecentItems: UITableView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var productDetails : ProductDetails!
    
    var popularProducts : [Product] = []
    
    var recentProducts : [Product] = []
    
    @IBOutlet weak var labelRecentProds: UILabel!
    
    @IBOutlet weak var labelPopularProds: UILabel!
    
    let screenHeight = UIScreen.main.bounds.height
    
    var prodNames : [String] = []
    
    var autoCompleteProducts : [Products] = []

    var prodDetails : [Product] = []

    var dateText : String!
    
    var productId : String = ""
    
    var manufactureId : String = ""
    
    var searchFromDate : String = ""
    
    var searchToDate : String = ""
    
    var searchProducts : [Product]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x2C3140)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        
        tableRecentItems.dataSource = self
        tableRecentItems.delegate = self
        
        tableRecentItems.allowsSelection = true
        
        tablePopularItems.dataSource = self
        tablePopularItems.delegate = self
        
        scrollView.delegate = self
    
        
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
        
        tapRecogniser.cancelsTouchesInView = false
        
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
        
        // Set the max number of results. By default it's not limited
        prodSearchTextField.maxNumberOfResults = 5
        
        // You can also limit the max height of the results list
        prodSearchTextField.maxResultsListHeight = 200
        
        prodSearchTextField.itemSelectionHandler = { item , itemPosition in
            
            self.prodSearchTextField.text = item.title
            print(itemPosition)
        }
        
        
        buttonSearch.layer.cornerRadius = 5
        buttonSearch.layer.borderWidth = 1
        buttonSearch.layer.borderColor = UIColor.black.cgColor
        
        //testing
        Alamofire.request(URL(string: RecircleWebConstants.ProdNamesApi)!,
                          method: .get)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let dataResponse = response.result.value {
                    let json = JSON(dataResponse)
                      print("JSON searchText: \(json)")
                    //               print("name : \(json["productsData"].arrayValue.map({$0["product_manufacturer_name"].stringValue}))")
                    
                    let prodName = ProdNames(dictionary: json.object as! NSDictionary)
                    
                    for item in (prodName?.productsData)! {
                        
                        self.prodNames.append(item.product_manufacturer_name!)
                        print(item.product_manufacturer_name)
                        
                        for itemProd in item.products! {
                         //   let product : Products!
//                            product.manufacturer_id = item.product_manufacturer_id
//                            product.manufacturer_name = item.product_manufacturer_name
//                            product.product_id = itemProd.product_id
//                            product.product_title = itemProd.product_title
//                            self.autoCompleteProducts.append(product)
                            print(itemProd.product_title)
                            self.prodNames.append(itemProd.product_title!)
                        }
                    }
                   // self.prodSearchTextField.filterStrings(self.prodNames)

//                    for item in json["productsData"].arrayValue {
//                        print(item["product_manufacturer_name"].stringValue)
//                        let manufacturerName = item["product_manufacturer_name"].stringValue
//                      //  self.prodNames.append(manufacturerName)
//                        for subitem in item["products"].arrayValue {
//                          //  print(subitem["product_title"].stringValue)
//                         //   self.prodNames.append(manufacturerName + " " + subitem["product_title"].stringValue)
//                        }
//                        
//                    }
                    self.prodSearchTextField.filterStrings(self.prodNames)
                }
        }
        
        //
        
        
        Alamofire.request(URL(string: RecircleWebConstants.ProductsApi)!,
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
                }
                    
                else {
                    self.labelRecentProds.isHidden = true
                    self.tablePopularItems.isHidden = true
                    self.labelPopularProds.isHidden = true
                    self.tableRecentItems.isHidden = true
                    
                }
        }
        
        
        
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        let yOffset = scrollView.contentOffset.y
//        
//        let scrollViewContentHeight : CGFloat = 2300
//        
//        print("scroll y offset "+String(describing: yOffset))
//        
//        print("tableRecent offset "+String(describing: tableRecentItems.frame.minY))
//        
//        
//        print("tableRecent content height "+String(describing: tableRecentItems.contentSize.height))
//
//        let tableYOffset = tableRecentItems.frame.minY
//        
//     //   if scrollView == self.scrollView {
//            
//            if (yOffset >= tableYOffset && yOffset <= tableYOffset + 540 ){
//                scrollView.isScrollEnabled = false
//                scrollView.resignFirstResponder()
//                tableRecentItems.isScrollEnabled = true
//                tableRecentItems.isUserInteractionEnabled = true
//            }
//            
//            else {
//                scrollView.isScrollEnabled = true
//                tableRecentItems.isScrollEnabled = false
//            }
//       // }
//        
////        if scrollView == self.tableRecentItems {
////            if yOffset <= 0 {
////                scrollView.isScrollEnabled = true
////                tableRecentItems.isScrollEnabled = false
////            }
////        }
//        
//        if scrollView == tableRecentItems {
//            print("recent Items")
//        }
//    }
    
    
    override func viewDidLayoutSubviews() {
        
        dateTextField.text = dateText

        scrollView.isScrollEnabled = true
        scrollView.contentSize=CGSize(width : self.view.frame.width,height : 2300);
        
    }
    
    
    func showCalendar () {
        print("refresh")
        performSegue(withIdentifier: "datepicker", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "searchResult" {
            
            let vc = segue.destination as! SearchResultViewController
            vc.products = searchProducts
            searchProducts.removeAll()
        }
            
        
     }
 
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "searchResult" {
            
            if searchProducts != nil && searchProducts.count > 0 {
                return true;
            } else {
                return false;
            }
        }
        return true;
    }
    
    
    
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
    
    @IBAction func searchProduct(_ sender: AnyObject) {
        
        var searchText : String!
        
        if searchProducts != nil && searchProducts.count > 0 {
            searchProducts.removeAll()
        }
        
        if productId == nil || productId.isEmpty || manufactureId == nil || manufactureId.isEmpty {
            searchText = prodSearchTextField.text
        }
//
        
        let parameters : [String : AnyObject] = ["manufacturerId" : manufactureId as AnyObject ,
                                                 "productId" : productId as AnyObject ,
                                                 "searchText" : searchText as AnyObject,
                                                 "searchFromDate" : searchFromDate as AnyObject,
                                                 "searchToDate" : searchToDate as AnyObject
                                                 ]
        
        Alamofire.request(URL(string: RecircleWebConstants.SearchApi)!,
                          method: .get, parameters: parameters)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let dataResponse = response.result.value {
                    let json = JSON(dataResponse)
                    print("JSON SearchApi: \(json)")
                    
                    let searchResult = SearchResultProducts(dictionary: json.object as! NSDictionary)

//                    let arr : NSArray = searchResult?.products as NSArray
//                    
                    
                 //   print(arr.count)
                    
                   
                    if let prods = searchResult?.products {
                        self.searchProducts = prods
                        print(prods.count)
                    }
                    
                    self.performSegue(withIdentifier: "searchResult", sender: nil)
                    
                }
                    
                else {
                    
                }
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
                cell.viewRating.text =  String(describing: self.recentProducts[index].user_product_info?.product_avg_rating)
                cell.imageProduct.setImageFromURl(stringImageUrl: (self.recentProducts[index].product_info?.product_image_url)!)
            }
            
        }
        
        if tableView == self.tablePopularItems {
            
            if (self.popularProducts.count > 0) {
                
                cell.textProductName.text = self.popularProducts[index].product_info?.product_title
                cell.textOwnerName.text = (self.popularProducts[index].user_info?.first_name)! + " " + (self.recentProducts[index].user_info?.last_name)!
                cell.viewRating.text =  String(describing: self.popularProducts[index].user_product_info?.product_avg_rating)
                cell.imageProduct.setImageFromURl(stringImageUrl: (self.popularProducts[index].product_info?.product_image_url)!)
            }
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            print("table row selected ")
            performSegue(withIdentifier: "searchResult", sender: nil)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableRecentItems {
          //  TODO : changes to be done
//            let oldFrame = tableView.frame
//            let newHeight = self.recentProducts.count * 90
//        
//            tableView.frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.size.width, height: CGFloat(newHeight))
            return self.recentProducts.count
        } else {
            return self.popularProducts.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}
