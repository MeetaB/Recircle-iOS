//
//  SearchResultViewController.swift
//  Recircle
//
//  Created by synerzip on 20/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    public var products : [Product]!

    @IBOutlet weak var tableProducts: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchView: UIView!
    
    public var searchString : String!
    
    @IBOutlet weak var searchProdNameField: UITextField!
    
    @IBOutlet weak var searchLocationField: UITextField!
    
    @IBOutlet weak var searchDateField: UITextField!
    
    public var searchProdName : String!
    
    public var searchLocation : String!
    
    public var searchDate : String!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = UIColor.clear
        
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
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showCalendar () {
        performSegue(withIdentifier: "datePicker", sender: nil)

    }
    
    @IBAction func searchProduct(_ sender: AnyObject) {
        searchTextField.isHidden = false
        searchView.isHidden = true
        
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

        cell.prodImage.setImageFromURl(stringImageUrl: (products[indexPath.row].product_info?.product_image_url)!)
        
        
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
        let prodDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailViewController
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
