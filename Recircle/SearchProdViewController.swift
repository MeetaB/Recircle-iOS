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
import KYDrawerController

class SearchProdViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var recentProducts : [Product] = []
    
    var popularProducts : [Product] = []
    
    var productDetails : ProductDetails!
    
    var autoCompleteProducts : [Products] = []
    
    var searchItems : [SearchTextFieldItem] =  []
    
    var prodNames : [String] = []

    var productId : String = ""
    
    var manufactureId : String = ""
    
    var progressBar : MBProgressHUD!
    
    var searchProducts : [Product] = []
    
    var searchText : String!
    
    var searchFromDateString : String = ""
    
    var searchToDateString : String = ""
    
    var userProductId : String!
    
    var pickDropText : Bool = false
    
    var dateText : String = ""
    
    var heightTabBar : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x2C3140)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        self.navigationItem.title = "ReCircle"
        
        self.tabBarController?.tabBar.isHidden = false
        
        let rentRequests = UIBarButtonItem(image: UIImage(named : "camera_filled") , style: .plain, target: self, action: nil)

        rentRequests.tintColor = UIColor.white
        
        let messages = UIBarButtonItem(image: UIImage(named : "messages") , style: .plain, target: self, action: #selector(openMessages(_:)))
        messages.tintColor = UIColor.white
        
        navigationItem.rightBarButtonItems = [rentRequests, messages]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "menu"), style: .plain, target: self, action: #selector(didTapOpenButton(_:)))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white

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
    
    func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = tabBarController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }

    func openMessages(_ sender : UIBarButtonItem){
        self.performSegue(withIdentifier: "messages", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
    
        collectionView.contentSize = CGSize(width: self.view.frame.width, height: 3000)
        heightTabBar = self.tabBarController?.tabBar.frame.height
       
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
        else if segue.identifier == "detail" {
            
            let vc = segue.destination as! TestViewController
            vc.userProdId = self.userProductId
        }

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    
        self.tabBarController?.tabBar.isHidden = false
        
        if heightTabBar != nil {
            self.tabBarController?.tabBar.frame.size.height = heightTabBar
        }
        
        if CalendarState.searchProduct {
            setUpDate()
        }
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
                        
                        
                        for itemProd in item.products! {
                            let product = Products()
                            product.manufacturer_id = item.product_manufacturer_id
                            product.manufacturer_name = item.product_manufacturer_name
                            product.product_id = itemProd.product_id
                            product.product_title = itemProd.product_title
                            self.autoCompleteProducts.append(product)
                            let prodName = item.product_manufacturer_name! + " " + itemProd.product_title!
                            self.prodNames.append(prodName)
                            
                            //Commenting for future if product image needs to be shown in search text
//                            if let url = NSURL(string: (itemProd.product_detail?.product_image_url)!) {
//                                if let data = NSData(contentsOf: url as URL) {
//                                    self.searchItems.append(SearchTextFieldItem(title: prodName, subtitle: "", image: UIImage(data: data as Data)))
//                                }
//                            }
                            
                            
                            
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
            CalendarState.searchProduct = false
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
                    dateText = String(describing: startDay!) + " - " + endDate
                } else {
                    cell.txtDate.text = String(describing: startDay!) + " " + monthSymbol! + " - " + endDate
                    dateText = String(describing: startDay!) + " " + monthSymbol! + " - " + endDate
                }
            } else {
                cell.txtDate.text = fromDate + " - " + endDate
                dateText = fromDate + " - " + endDate
            }
            
//            collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
//            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
//
//            collectionView.reloadItems(at: [NSIndexPath(item: 0, section: 0) as IndexPath])
            collectionView.reloadData()
            
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
                    }
                    
                    self.performSegue(withIdentifier: "searchResult", sender: nil)
                }
                    
                else {
                    
                }
        }

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if recentProducts.count > 0 && popularProducts.count > 0 {
            return 6
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2 || section == 4 {
            return 1
        } else if section == 3 {
            return min(recentProducts.count, 6)
        } else {
            return min(popularProducts.count, 6)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
       
        
        if indexPath.section == 0 {
            let cellSearch = collectionView.dequeueReusableCell(withReuseIdentifier: "cellSearch", for: indexPath) as! SearchProductCell
            
            ///cellSearch.txtProdName.filterItems(self.prodNames as! [SearchTextFieldItem])
            
            cellSearch.txtProdName.filterStrings(self.prodNames)
            
            cellSearch.txtProdLocation.leftViewMode = UITextFieldViewMode.always
            cellSearch.txtProdLocation.leftViewRect(forBounds: CGRect(x: 20, y: 0, width: 20, height: 20))
            cellSearch.txtProdLocation.isUserInteractionEnabled = false
            cellSearch.txtDate.leftViewMode = UITextFieldViewMode.always
            cellSearch.txtProdName.leftViewMode = UITextFieldViewMode.always
            
             let imgContainerLocation = UIView(frame: CGRect( x : cellSearch.txtProdLocation.frame.origin.x, y : cellSearch.txtProdLocation.frame.origin.y, width : 30.0, height : 30.0))
            let imageViewLocation = UIImageView(frame: CGRect(x: 5 , y: 5, width: 20, height: 20))
            var image = UIImage(named: "location")
            imageViewLocation.image = image
            imgContainerLocation.addSubview(imageViewLocation)
            cellSearch.txtProdLocation.leftView = imgContainerLocation
            
            let imgContainerDate = UIView(frame: CGRect( x : cellSearch.txtDate.frame.origin.x, y : cellSearch.txtDate.frame.origin.y, width : 30.0, height : 30.0))
            let imageViewDate = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
            image = UIImage(named : "calendar")
            imageViewDate.image = image
            imgContainerDate.addSubview(imageViewDate)
            let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.showCalendar))
            tapRecogniser.numberOfTapsRequired = 1;
            tapRecogniser.cancelsTouchesInView = false
            imageViewDate.addGestureRecognizer(tapRecogniser)
            imageViewDate.isUserInteractionEnabled = true
            cellSearch.txtDate.leftView = imgContainerDate
            cellSearch.txtDate.delegate = self
            
            if !dateText.isEmpty {
                
                cellSearch.txtDate.text = dateText
                dateText = ""
            }
            
           
            
            let imgContainerSearch = UIView(frame: CGRect( x : cellSearch.txtProdName.frame.origin.x, y : cellSearch.txtProdName.frame.origin.y, width : 30.0, height : 30.0))
            let imageViewSearch = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
            image = UIImage(named : "search")
            imageViewSearch.image = image
            imgContainerSearch.addSubview(imageViewSearch)

            cellSearch.txtProdName.leftView = imgContainerSearch
            
            
            cellSearch.txtProdName.theme.font = UIFont.systemFont(ofSize: 16)
            cellSearch.txtProdName.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 1)
            cellSearch.txtProdName.theme.borderColor = UIColor (red: 0, green: 0, blue: 0, alpha: 1)
            cellSearch.txtProdName.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
            cellSearch.txtProdName.theme.cellHeight = 50
            
            cellSearch.txtProdName.itemSelectionHandler = { item , itemPosition in
                
                cellSearch.txtProdName.text = item.title
                
                cellSearch.txtProdName.resignFirstResponder()
                
                let index = self.prodNames.index(of: item.title)
                
                if let productId = self.autoCompleteProducts[index!].product_id {
                    
                    self.productId = productId
                }
                
                if let manufactureId = self.autoCompleteProducts[index!].manufacturer_id {
                    
                    self.manufactureId = manufactureId
                }
                
            }
            

            cellSearch.btnSearch.layer.cornerRadius = 5
            cellSearch.btnSearch.layer.borderWidth = 1
            cellSearch.btnSearch.layer.borderColor = UIColor.black.cgColor
            
            cellSearch.btnSearch.addTarget(self, action: #selector(SearchProdViewController.searchProduct(_:)), for: .touchUpInside)
            
            return cellSearch
        } else if indexPath.section == 1 {
            
        let cellStatic = collectionView.dequeueReusableCell(withReuseIdentifier: "cellStatic", for: indexPath) as! SearchProdStaticCell
        
        cellStatic.btnArrowPickDrop.addTarget(self, action: #selector(SearchProdViewController.tappedArrow(_:)), for: .touchUpInside)
            
        return cellStatic
        
        } else if indexPath.section == 2 {
            let cellRecentLabel = collectionView.dequeueReusableCell(withReuseIdentifier: "cellRecentLabel", for: indexPath) as! SearchProdLabelCell
            
            cellRecentLabel.title.text = "RECENTLY ADDED ITEMS"
            
            return cellRecentLabel
        }
        
        else if indexPath.section == 3 {
            let cellRecentProds = collectionView.dequeueReusableCell(withReuseIdentifier: "cellRecentProds", for: indexPath) as! SearchProdGridCell
           // cell2.frame.offsetBy(dx: 10.0, dy: 10.0)
            
            let index = indexPath.item
            if self.recentProducts.count > 0 {
                cellRecentProds.txtProdName.text = self.recentProducts[index].product_info?.product_title
                
                cellRecentProds.txtOwnerName.text = (self.recentProducts[index].user_info?.first_name)! + " " + (self.recentProducts[index].user_info?.last_name)!
            
                if let price = self.recentProducts[index].user_product_info?.price_per_day {
                    cellRecentProds.txtPrice.text = "$ " + String(price) + " /day"
                }
                
                if let imageUrl = self.recentProducts[index].product_info?.product_image_url?.user_prod_image_url {
                    cellRecentProds.imageProduct.setImageFromURl(stringImageUrl: imageUrl)
                }
                
                if let rating = self.recentProducts[index].user_product_info?.product_avg_rating {
                    if rating > 0 {
                        cellRecentProds.ratingView.isHidden = false
                        cellRecentProds.ratingView.isUserInteractionEnabled = false
                        cellRecentProds.ratingView.rating = Double(rating)
                    } else {
                        cellRecentProds.ratingView.isHidden = true
                    }
                } else {
                    cellRecentProds.ratingView.isHidden = true
                }
                
            }
            
            return cellRecentProds
        }
        
        else if indexPath.section == 4 {
            
            let cellPopularLabel = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPopularLabel", for: indexPath) as! SearchProdLabelCell
            cellPopularLabel.title.text = "POPULAR ITEMS"
            return cellPopularLabel
        }
        else { //indexPath.section == 5
            let cellPopularProds = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPopularProds", for: indexPath) as! SearchProdGridCell
            
            let index = indexPath.item
            
            cellPopularProds.txtProdName.text = self.popularProducts[index].product_info?.product_title
            cellPopularProds.txtOwnerName.text = (self.popularProducts[index].user_info?.first_name)! + " " + (self.popularProducts[index].user_info?.last_name)!
            
            if let price = self.popularProducts[index].user_product_info?.price_per_day {
                cellPopularProds.txtPrice.text = "$ " + String(price) + " /day"
            }
            
            if let imageUrl = self.popularProducts[index].user_product_info?.user_prod_images?[0].user_prod_image_url {
                cellPopularProds.imageProduct.setImageFromURl(stringImageUrl: imageUrl)
            }
            
            if let rating = self.popularProducts[index].user_product_info?.product_avg_rating {
                if rating > 0 {
                cellPopularProds.ratingView.isHidden = false
                cellPopularProds.ratingView.isUserInteractionEnabled = false
                cellPopularProds.ratingView.rating = Double(rating)
                } else {
                    cellPopularProds.ratingView.isHidden = true
                }
            } else {
                cellPopularProds.ratingView.isHidden = true
            }
            
            cellPopularProds.tag = index
            
            return cellPopularProds
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            self.userProductId = self.recentProducts[indexPath.item].user_product_info?.user_product_id
            self.performSegue(withIdentifier: "detail", sender: self)
            
        } else if indexPath.section == 5 {
            self.userProductId = self.popularProducts[indexPath.item].user_product_info?.user_product_id
            self.performSegue(withIdentifier: "detail", sender: self)
        }
    }
    
    
    func tappedArrow(_ sender : AnyObject){
        let indexPath = NSIndexPath(item: 0, section: 1)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellStatic", for: indexPath as IndexPath) as! SearchProdStaticCell
        cell.txtPickDrop.isHidden = true
        cell.txtPickDropHeight.constant = 0
        self.pickDropText = true
        cell.txtPickDrop.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        
        self.view.layoutIfNeeded()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.invalidateIntrinsicContentSize()
        
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
            if self.pickDropText {
                return CGSize(width: self.view.frame.width , height: 1090)
            }else {
            return CGSize(width: self.view.frame.width , height: 1135)
            }
        } else if indexPath.section == 2 || indexPath.section == 4 {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        showCalendar()
    }
}



