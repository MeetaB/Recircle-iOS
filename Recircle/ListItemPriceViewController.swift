//
//  ListItemPriceViewController.swift
//  Recircle
//
//  Created by synerzip on 16/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import Alamofire
import SearchTextField
import SwiftyJSON
import SkyFloatingLabelTextField

class ListItemPriceViewController: UIViewController {

    @IBOutlet weak var prodSearchTextField: SearchTextField!
    
    var prodNames : [String] = []
    
    var autoCompleteProducts : [Products] = []
    
    var searchItems : [SearchTextFieldItem] =  []
    
    @IBOutlet weak var txtPricePerDay: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtMinimumDays: SkyFloatingLabelTextField!
    
    var productId : String!
    
    @IBOutlet weak var minimumRentDays: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x2C3140)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        // Do any additional setup after loading the view.
        
        setUpAutoCompleteProducts()
        
        txtPricePerDay.selectedTitleColor = UIColor.black
        txtMinimumDays.selectedTitleColor = UIColor.black
        
        prodSearchTextField.theme.font = UIFont.systemFont(ofSize: 16)
        prodSearchTextField.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 1)
        prodSearchTextField.theme.borderColor = UIColor (red: 0, green: 0, blue: 0, alpha: 1)
        prodSearchTextField.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        prodSearchTextField.theme.cellHeight = 50
        
        // Set the max number of results. By default it's not limited
        prodSearchTextField.maxNumberOfResults = 5
        
        // You can also limit the max height of the results list
        prodSearchTextField.maxResultsListHeight = 200
        
        prodSearchTextField.itemSelectionHandler = { item , itemPosition in
            
            self.prodSearchTextField.text = item.title
            
            self.prodSearchTextField.resignFirstResponder()
            
            let index = self.prodNames.index(of: item.title)
            
            if let productId = self.autoCompleteProducts[index!].product_id {
                
                self.productId = productId
            }
            
        }
        
        addDoneButtonOnKeyboard()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width : 320, height : 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ListItemPriceViewController.doneButtonAction))
        
        var items : [UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.minimumRentDays.inputAccessoryView = doneToolbar
       // self.textField.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.minimumRentDays.resignFirstResponder()
       // self.textViewDescription.resignFirstResponder()
    }
    

    func setUpAutoCompleteProducts() {
        
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
                        
                        let product = Products()
                        product.manufacturer_id = item.product_manufacturer_id
                        product.manufacturer_name = item.product_manufacturer_name
                        //self.autoCompleteProducts.append(product)
                        
//                        self.searchItems.append(SearchTextFieldItem(title: item.product_manufacturer_name!, subtitle: "", image: UIImage(named:"camera")))
                        
                       // self.prodNames.append(item.product_manufacturer_name!)
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
                    
                    self.prodSearchTextField.filterItems(self.searchItems)
                }
        }
    }
    
    
    @IBAction func next(_ sender: AnyObject) {
        
//        performSegue(withIdentifier: "photos", sender: self)
//        
        let popoverContent = (self.storyboard?.instantiateViewController(withIdentifier: "ListItemPhotosViewController"))! as UIViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width :500,height : 600)
       // popover?.delegate = self
        popover?.sourceView = self.view
        popover?.accessibilityNavigationStyle = .separate
        popover?.sourceRect = CGRect(x: 0, y : 0, width : 100,height : 100)
        
        self.present(nav, animated: true, completion: nil)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
