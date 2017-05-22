//
//  ProdImageViewController.swift
//  Recircle
//
//  Created by synerzip on 09/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import ImageScrollView

class ProdImageViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var imageScrollView: ImageScrollView!

    
    @IBOutlet weak var collectionProdImages: UICollectionView!
    
    public var imageUrl : String!
    
    public var prodImagesUrls : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionProdImages.dataSource = self
        collectionProdImages.delegate = self
        
        
        let nib = UINib(nibName: "ProductImageCell", bundle: nil)
    
        collectionProdImages.register(nib, forCellWithReuseIdentifier: "cell")
    

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let url = NSURL(string: imageUrl) {
            if let data = NSData(contentsOf: url as URL) {
                imageScrollView.display(image: UIImage(data: data as Data)!)
            }
            
        }
        
       

    }
    
    override func viewDidLayoutSubviews() {
        
        if let flowLayout = collectionProdImages.collectionViewLayout as? UICollectionViewFlowLayout { flowLayout.scrollDirection = .horizontal
            flowLayout.invalidateLayout()
        }
        
    }
    
    
    
    @IBAction func crossTapped(_ sender: AnyObject) {
        
        self.dismiss(animated: true) { 
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prodImagesUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProdImageCellView
        
        cell.productImage.setImageFromURl(stringImageUrl: prodImagesUrls[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let url = NSURL(string: prodImagesUrls[indexPath.item]) {
            if let data = NSData(contentsOf: url as URL) {
                self.imageScrollView.display(image: UIImage(data: data as Data)!)
            }
            
        }
        
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
