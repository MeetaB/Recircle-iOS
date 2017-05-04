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

class ProductDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    public var userProdId : String!
    
    @IBOutlet weak var prodImage: UIImageView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var prodImagescollection: UICollectionView!
    
    @IBOutlet weak var descriptionTextView: ReadMoreTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(userProdId)
        
      
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
                    
                    self.prodImage.setImageFromURl(stringImageUrl: (product?.user_product_info?.user_prod_images?[0].user_prod_image_url)!)
                    
                    self.navigationController?.title = product?.product_info?.product_title
                }
                    
                else {
                    
                }
        }
        
        descriptionTextView.shouldTrim = true
        descriptionTextView.maximumNumberOfLines = 2
        descriptionTextView.attributedReadMoreText = NSAttributedString(string: "... See more")
        descriptionTextView.attributedReadLessText = NSAttributedString(string: " See less")
        

        userImage.image = UIImage(named: "camera")
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.layer.masksToBounds = true
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}
