//
//  SearchResultViewController.swift
//  Recircle
//
//  Created by synerzip on 20/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON
import SearchTextField

class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    public var products : [Product]!

    @IBOutlet weak var tableProducts: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchView: UIView!
    
    public var searchString : String!
    
    @IBOutlet weak var searchProdNameField: SearchTextField!
    
    @IBOutlet weak var searchLocationField: UITextField!
    
    @IBOutlet weak var searchDateField: UITextField!
    
    public var searchProdName : String!
    
    public var searchLocation : String!
    
    public var searchDate : String!

    var progressBar : MBProgressHUD!
    
    var searchItems : [SearchTextFieldItem] =  []
    
    var autoCompleteProducts : [Products] = []
    
    var prodNames : [String] = []
    
    var productId : String = ""
    
    var manufactureId : String = ""
    
    var searchFromDateString : String = ""
    
    var searchToDateString : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        print(products.count)
        
        tableProducts.dataSource = self
        
        tableProducts.delegate = self
        
        let nib = UINib(nibName: "ProductCellView", bundle: nil)
        
        tableProducts.register(nib, forCellReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view.
        
        searchTextField.addTarget(self, action: #selector(self.openSearchView), for: UIControlEvents.touchDown)
        
        searchView.isHidden = true
        
        searchTextField.text = searchString
        
        searchLocationField.leftViewMode = UITextFieldViewMode.always
        searchDateField.leftViewMode = UITextFieldViewMode.always
        searchProdNameField.leftViewMode = UITextFieldViewMode.always
        
        let imageViewLocation = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        var image = UIImage(named: "location")
        imageViewLocation.image = image
        searchLocationField.leftView = imageViewLocation
        
        let imageViewDate = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        image = UIImage(named : "calendar")
        imageViewDate.image = image
        let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.showCalendar))
        tapRecogniser.numberOfTapsRequired = 1;
        imageViewDate.addGestureRecognizer(tapRecogniser)
        imageViewDate.isUserInteractionEnabled = true
        searchDateField.leftView = imageViewDate
        
        tapRecogniser.cancelsTouchesInView = false
        
        let imageViewSearch = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        image = UIImage(named : "search")
        imageViewSearch.image = image
        searchProdNameField.leftView = imageViewSearch
        
        searchProdNameField.theme.font = UIFont.systemFont(ofSize: 16)
        searchProdNameField.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 1)
        searchProdNameField.theme.borderColor = UIColor (red: 0, green: 0, blue: 0, alpha: 1)
        searchProdNameField.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        searchProdNameField.theme.cellHeight = 50

        
        searchProdNameField.itemSelectionHandler = { item , itemPosition in
            
            self.searchProdNameField.text = item.title
            
            self.searchProdNameField.resignFirstResponder()
            
            let index = self.prodNames.index(of: item.title)
            
            if let productId = self.autoCompleteProducts[index!].product_id {
                
                self.productId = productId
            }
            
            if let manufactureId = self.autoCompleteProducts[index!].manufacturer_id {
                
                self.manufactureId = manufactureId
            }
            
        }

        
        getAutoCompleteProdsData()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CalendarState.searchResult {
            
            setUpDate()
            CalendarState.searchResult = false
            
        }
    }
    
    func setUpDate() {
        
        if CalendarState.startDate != nil && CalendarState.endDate != nil {
            
            let formatter  = DateFormatter()
            formatter.dateFormat = "dd MMM,yyyy"
            
            let fromDate = formatter.string(from: CalendarState.startDate)
            let endDate = formatter.string(from: CalendarState.endDate)
            
            formatter.dateFormat = "yyyy-MM-dd'T'00:00:00Z"
            searchFromDateString = formatter.string(from: CalendarState.startDate)
            searchToDateString = formatter.string(from: CalendarState.endDate)
            
            let calendar = NSCalendar.current
            var components = calendar.dateComponents([.day,.month,.year], from: CalendarState.startDate)
            
            let startYear =  components.year
            let startMonth = components.month
            let startDay = components.day
            
            components = calendar.dateComponents([.day,.month,.year], from: CalendarState.endDate)
            let endYear =  components.year
            let endMonth = components.month
            
            let months = formatter.monthSymbols
            let monthSymbol = months?[startMonth!-1]
            
            if startYear == endYear {
                if startMonth == endMonth {
                    searchDateField.text = String(describing: startDay!) + " - " + endDate
                } else {
                    searchDateField.text = String(describing: startDay!) + " " + monthSymbol! + " - " + endDate
                }
            } else {
                searchDateField.text = fromDate + " - " + endDate
                
            }
            
        }
        
    }

    
    func getAutoCompleteProdsData() {
        
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
                        
                        let product = Products()
                        product.manufacturer_id = item.product_manufacturer_id
                        product.manufacturer_name = item.product_manufacturer_name
                        self.autoCompleteProducts.append(product)
                        
                        self.searchItems.append(SearchTextFieldItem(title: item.product_manufacturer_name!, subtitle: "", image: UIImage(named:"camera")))
                        
                        self.prodNames.append(item.product_manufacturer_name!)
                        
                        print(item.product_manufacturer_name)
                        
                        
                        for itemProd in item.products! {
                            let product = Products()
                            product.manufacturer_id = item.product_manufacturer_id
                            product.manufacturer_name = item.product_manufacturer_name
                            product.product_id = itemProd.product_id
                            product.product_title = itemProd.product_title
                            self.autoCompleteProducts.append(product)
                            print(itemProd.product_title)
                            let prodName = item.product_manufacturer_name! + " " + itemProd.product_title!
                           self.prodNames.append(prodName)
                            if let url = NSURL(string: (itemProd.product_detail?.product_image_url)!) {
                                if let data = NSData(contentsOf: url as URL) {
                                    self.searchItems.append(SearchTextFieldItem(title: prodName, subtitle: "", image: UIImage(data: data as Data)))
                                }
                            }
                            
                            
                            
                        }
                    }
                
                self.searchProdNameField.filterItems(self.searchItems)
                    
                }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showCalendar () {
        CalendarState.searchResult = true
        performSegue(withIdentifier: "datePicker", sender: nil)

    }
    
    @IBAction func searchProduct(_ sender: AnyObject) {

        searchTextField.isHidden = false
        searchView.isHidden = true
        
        progressBar = MBProgressHUD.showAdded(to: self.view, animated: true);

        progressBar.mode = MBProgressHUDMode.indeterminate
        
        progressBar.label.text = "Loading";
        
        progressBar.isUserInteractionEnabled = false;
        
        var searchText : String = ""
        
        if products != nil && products.count > 0 {
            products.removeAll()
        }
        
        if productId.isEmpty && manufactureId.isEmpty {
            searchText = searchProdNameField.text!
        }
        
        
        
        let parameters : [String : AnyObject] = ["manufacturerId" : manufactureId as AnyObject ,
                                                 "productId" : productId as AnyObject ,
                                                 "searchText" : searchText as AnyObject,
                                                 "searchFromDate" : searchFromDateString as AnyObject,
                                                 "searchToDate" : searchToDateString as AnyObject
        ]
        
        Alamofire.request(URL(string: RecircleWebConstants.SearchApi)!,
                          method: .get, parameters: parameters)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                
                self.progressBar.hide(animated: true)
                
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let dataResponse = response.result.value {
                    let json = JSON(dataResponse)
                    print("JSON SearchApi: \(json)")
                    
                    let searchResult = SearchResultProducts(dictionary: json.object as! NSDictionary)
                    
                    if let prods = searchResult?.products {
                        self.products = prods
                        print(prods.count)
                        self.tableProducts.reloadData()
                    }
                }
                    
                else {
                    
                }
        }

        
    }
    
    
    func openSearchView () {
        searchTextField.isHidden = true
        
//        let view = Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)?.first as! UIView
//        //  self.view.addSubview(view)
//        
////        view.frame = CGRect(x: 0, y: 100, width: Int(self.view.frame.width), height: Int(view.frame.height))
//        
//       // self.stackView.insertSubview(view, at: 1)
//        
//        self.stackView.addSubview(view)
    

        searchView.isHidden = false
        
        searchProdNameField.text = searchProdName
        
        searchLocationField.text = searchLocation
        
        searchDateField.text = searchDate
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

        if let imageURL = products[indexPath.row].product_info?.product_image_url?.user_prod_image_url {
            cell.prodImage.setImageFromURl(stringImageUrl: imageURL)
        }
        
        
        if let rating = (products[indexPath.row].user_product_info?.product_avg_rating) {
            if rating > 0 {
                cell.prodRating.isHidden = false
                cell.prodRating.rating = Double((products[indexPath.row].user_product_info?.product_avg_rating)!)
                cell.prodRating.text = "(" + String(describing: rating) + ")"
            } else {
                cell.prodRating.isHidden = true
            }
        }
        
    
        cell.prodFavourite.setImage(UIImage(named:"favourite"), for: .normal)
        
        cell.prodFavourite.tag = indexPath.row
        
        cell.prodFavourite.addTarget(self, action: #selector(self.favouriteTapped(withSender:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(products[indexPath.row].product_info?.product_title)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let prodDetailVC = storyboard.instantiateViewController(withIdentifier: "TestVC") as! TestViewController
        prodDetailVC.userProdId = products[indexPath.row].user_product_info?.user_product_id
        self.navigationController?.pushViewController(prodDetailVC, animated: true)
    }
    
    func favouriteTapped (withSender sender: AnyObject) {
        
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        let cell = tableProducts.cellForRow(at: indexPath as IndexPath) as! ProductCell
        
        if cell.prodFavourite.image(for: .normal) == UIImage(named: "favourite") {
            cell.prodFavourite.setImage(UIImage(named:"favourite_filled"), for: .normal)
        } else {
            cell.prodFavourite.setImage(UIImage(named:"favourite"), for: .normal)
        }
        
        
    }

}
