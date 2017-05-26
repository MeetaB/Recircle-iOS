//
//  SearchProdViewController.swift
//  Recircle
//
//  Created by synerzip on 24/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SearchTextField
import MBProgressHUD

class SearchProdViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var recentProducts : [Product] = []
    
    var popularProducts : [Product] = []
    
    var productDetails : ProductDetails!
    
    var autoCompleteProducts : [Products] = []
    
    var searchItems : [SearchTextFieldItem] =  []
    
    var prodNames : [String] = []

    var productId : String!
    
    var manufactureId : String!
    
    var progressBar : MBProgressHUD!
    
    var searchProducts : [Product]!
    
    var searchText : String!
    
    var searchFromDateString : String!
    
    var searchToDateString : String!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x2C3140)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        
        self.navigationItem.title = "ReCircle"

        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nibSearch = UINib(nibName: "SearchProductCell", bundle: nil)
        
        collectionView.register(nibSearch, forCellWithReuseIdentifier: "cellSearch")
        
        let nibStaticCell = UINib(nibName: "SearchProdStaticCell", bundle: nil)
        
        collectionView.register(nibStaticCell, forCellWithReuseIdentifier: "cellStatic")
        
        let nibRecentLabel = UINib(nibName: "SearchProdLabelCell", bundle: nil)
        
        collectionView.register(nibRecentLabel, forCellWithReuseIdentifier: "cellRecentLabel")
        
        let nibRecentProds = UINib(nibName: "SearchProdGridCell", bundle: nil)
        
        collectionView.register(nibRecentProds, forCellWithReuseIdentifier: "cellRecentProds")
        

        let nibPopularLabel = UINib(nibName: "SearchProdLabelCell", bundle: nil)
        
        collectionView.register(nibPopularLabel, forCellWithReuseIdentifier: "cellPopularLabel")
        

        
        let nibPopularProds = UINib(nibName: "SearchProdGridCell", bundle: nil)
        
        collectionView.register(nibPopularProds, forCellWithReuseIdentifier: "cellPopularProds")
        

        
        getSearchProductTitles()
        getProducts()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.contentSize = CGSize(width: self.view.frame.width, height: 3000)
        }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchResult" {
            
            let vc = segue.destination as! SearchResultViewController
            vc.products = searchProducts
            searchProducts.removeAll()
            let cell = collectionView.cellForItem(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SearchProductCell
            
            vc.searchProdName = cell.txtProdName.text
            vc.searchLocation = cell.txtProdLocation.text
            vc.searchDate = cell.txtDate.text
            vc.searchString = cell.txtProdName.text! + " " + cell.txtProdLocation.text! + " " + cell.txtDate.text!
        }

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    
        setUpDate()
    }
    
    func getSearchProductTitles() {

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
                    self.collectionView.reloadData()
                }
        }
        
        
    }
    func getProducts(){

        Alamofire.request(URL(string: RecircleWebConstants.ProductsApi)!,
                          method: .get)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let dataResponse = response.result.value {
                    
                    let json = JSON(dataResponse)
                    print("JSON All Products: \(json)")
                    
                    
                    self.productDetails = ProductDetails(dictionary: json.object as! NSDictionary)
                    
                    if (self.productDetails != nil ) {
                        
                        self.popularProducts =  self.productDetails.popularProducts!
                        
                        self.recentProducts =  self.productDetails.productDetails!
                        
                        self.collectionView.reloadData()
                    }
                }
                    
                else {
                  
                }
        }

    }
    
    func showCalendar () {
        
        CalendarState.searchProduct = true
        performSegue(withIdentifier: "datePicker", sender: nil)
        
    }
    
    func setUpDate() {
        
        if CalendarState.startDate != nil && CalendarState.endDate != nil {
            let formatter = DateFormatter()
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
            
            
            let cell = self.collectionView.cellForItem(at: NSIndexPath(item: 0, section: 0) as IndexPath as IndexPath) as! SearchProductCell
            
            if startYear == endYear {
                if startMonth == endMonth {
                    cell.txtDate.text = String(describing: startDay!) + " - " + endDate
                } else {
                    cell.txtDate.text = String(describing: startDay!) + " " + monthSymbol! + " - " + endDate
                }
            } else {
                cell.txtDate.text = fromDate + " - " + endDate
                
            }
            
            collectionView.reloadItems(at: [NSIndexPath(item: 0, section: 0) as IndexPath])
            
        }

            
    }
    
    
    func searchProduct(_ sender : AnyObject) {
        
        progressBar = MBProgressHUD.showAdded(to: self.view, animated: true);
        
        progressBar.mode = MBProgressHUDMode.indeterminate
        
        progressBar.label.text = "Loading";
        
        progressBar.isUserInteractionEnabled = false;
        
        var searchText : String = ""
        
        if searchProducts != nil && searchProducts.count > 0 {
            searchProducts.removeAll()
        }
        
        if productId.isEmpty && manufactureId.isEmpty {
            let cell = self.collectionView.cellForItem(at: NSIndexPath(item: 0, section: 0) as IndexPath) as! SearchProductCell
            searchText = cell.txtProdName.text!
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

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2{
            return 1
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
       
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchProductCell
            
            cell.txtProdName.filterItems(self.searchItems)
            
            
            cell.txtProdLocation.leftViewMode = UITextFieldViewMode.always
            cell.txtDate.leftViewMode = UITextFieldViewMode.always
            cell.txtProdName.leftViewMode = UITextFieldViewMode.always
            
            let imageViewLocation = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            var image = UIImage(named: "location")
            imageViewLocation.image = image
            cell.txtProdLocation.leftView = imageViewLocation
            
            let imageViewDate = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
            image = UIImage(named : "calendar")
            imageViewDate.image = image
            let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.showCalendar))
            tapRecogniser.numberOfTapsRequired = 1;
            tapRecogniser.cancelsTouchesInView = false
            imageViewDate.addGestureRecognizer(tapRecogniser)
            imageViewDate.isUserInteractionEnabled = true
            cell.txtDate.leftView = imageViewDate
            
            let imageViewSearch = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            image = UIImage(named : "search")
            imageViewSearch.image = image
            cell.txtProdName.leftView = imageViewSearch
            
            
            cell.txtProdName.theme.font = UIFont.systemFont(ofSize: 16)
            cell.txtProdName.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 1)
            cell.txtProdName.theme.borderColor = UIColor (red: 0, green: 0, blue: 0, alpha: 1)
            cell.txtProdName.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
            cell.txtProdName.theme.cellHeight = 50
            
            cell.txtProdName.itemSelectionHandler = { item , itemPosition in
                
                cell.txtProdName.text = item.title
                
                cell.txtProdName.resignFirstResponder()
                
                let index = self.prodNames.index(of: item.title)
                
                if let productId = self.autoCompleteProducts[index!].product_id {
                    
                    self.productId = productId
                }
                
                if let manufactureId = self.autoCompleteProducts[index!].manufacturer_id {
                    
                    self.manufactureId = manufactureId
                }
                
            }
            

            cell.btnSearch.layer.cornerRadius = 5
            cell.btnSearch.layer.borderWidth = 1
            cell.btnSearch.layer.borderColor = UIColor.black.cgColor
            
            cell.btnSearch.addTarget(self, action: #selector(SearchProdViewController.searchProduct(_:)), for: .touchUpInside)
            
            return cell
        } else if indexPath.section == 1 {
            
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! SearchProdStaticCell
        
        cell1.btnArrowPickDrop.addTarget(self, action: #selector(SearchProdViewController.tappedArrow(_:)), for: .touchUpInside)
            
        return cell1
        
        } else if indexPath.section == 2 {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! SearchProdLabelCell
            return cell2
        }
        
        else  {
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! SearchProdGridCell
           // cell2.frame.offsetBy(dx: 10.0, dy: 10.0)
            
            let index = indexPath.item
            
            cell3.txtProdName.text = self.recentProducts[index].product_info?.product_title
            cell3.txtOwnerName.text = (self.recentProducts[index].user_info?.first_name)! + " " + (self.recentProducts[index].user_info?.last_name)!
            
            if let price = self.recentProducts[index].user_product_info?.price_per_day {
            cell3.txtPrice.text = "$ " + String(price) + " /day"
            }
            
            return cell3
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
    
    
    func tappedArrow(_ sender : AnyObject){
        print("tapped")
        let indexPath = NSIndexPath(item: 0, section: 1)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath as IndexPath) as! SearchProdStaticCell
        cell.txtPickDropHeight.constant = 0
        
        self.view.layoutIfNeeded()
        
    }
}

// MARK: UICollectionViewDelegateFlowLayout protocol methods
extension SearchProdViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //TODO: to calculate dynamic height
//        https://github.com/andrea-prearo/SwiftExamples/blob/master/SmoothScrolling/Client/CollectionView/CollectionView/MainViewController.swift
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//        let columns: Int = {
//            var count = 2
//            if traitCollection.verticalSizeClass == .regular {
//                count = count + 1
//            }
//            if collectionView.bounds.width > collectionView.bounds.height {
//                count = count + 1
//            }
//            return count
//        }()
//        let totalSpace = flowLayout.sectionInset.top
//            + flowLayout.sectionInset.bottom
//            + (flowLayout.minimumInteritemSpacing * CGFloat(columns - 1))
//        let size = Int((collectionView.bounds.height - totalSpace) / CGFloat(columns))
//        
//        print(size)
        //  return CGSize(width: self.view.frame.width , height: 490)
        
        if indexPath.section == 0 {
            return CGSize(width: Int(self.view.frame.width), height: 329)

        } else if indexPath.section == 1 {
            return CGSize(width: self.view.frame.width , height: 1135)
        } else if indexPath.section == 2 {
            return CGSize(width: self.view.frame.width , height: 80)
        } else {
            return CGSize(width: 150 , height: 180)
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       // if section == 2 {
            let leftRightInset = self.view.frame.size.width / 14.0
            return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
        //}
    }
}
       

