//
//  ListItemSummaryViewController.swift
//  Recircle
//
//  Created by synerzip on 22/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit


struct ListItemObject {
    static var listItem : ListItem!
    static var listItemImages : [UIImage]!
    static var listItemName : String!
}


class ListItemSummaryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var listItem : ListItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var txtProdName: UILabel!
    
    
    @IBOutlet weak var txtRentalPrice: UILabel!
    
    
    @IBOutlet weak var txtRentDays: UILabel!
    
    
    @IBOutlet weak var txtDiscount1: UILabel!
    
    @IBOutlet weak var txtDiscount2: UILabel!
    
    @IBOutlet weak var txtDescription: UILabel!
    
    @IBOutlet weak var txtListingDays: UILabel!
    
    @IBOutlet weak var txtUnavailableDates: UILabel!
    
    var prodImages : [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0x2C3140)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        self.listItem = ListItemObject.listItem
        
        let nib = UINib(nibName: "ProductImageCell", bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        if let price = listItem.price_per_day {
        txtRentalPrice.text = String(describing: price)
        }
        
        if let days = listItem.min_rental_day {
        txtRentDays.text = String(describing: days)
        }
        
        if (listItem.user_prod_discounts?.count)! == 1 {
            self.txtDiscount1.text = "30% discount for 5 days"
        } else if (listItem.user_prod_discounts?.count)! == 2 {
            self.txtDiscount1.text = "30% discount for 5 days"
            self.txtDiscount2.text = "40% discount for 10 days"
        }
        
        txtDescription.text = listItem.user_prod_desc
        
        txtUnavailableDates.text = String(describing: listItem.user_prod_unavailability?.count) + " days"
        
        txtProdName.text = ListItemObject.listItemName
        
        prodImages = ListItemObject.listItemImages
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize=CGSize(width : self.view.frame.width,height : 700);
    }

    @IBAction func editTapped(_ sender: AnyObject) {
    }
    
    @IBAction func showDates(_ sender: AnyObject) {
        
        CalendarState.listItemSummary = true
        self.performSegue(withIdentifier: "datePicker", sender: self)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func listItem(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "success", sender: self)
        
        
    }
    
    
    //Collection View Methods
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prodImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProdImageCellView
        
        cell.productImage.image = prodImages[indexPath.item]
        
        return cell
    }
    
    
    
}


// MARK: UICollectionViewDelegateFlowLayout protocol methods
extension ListItemSummaryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width: 100 , height: 100)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // if section == 2 {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
        //}
    }
}


