//
//  SearchProdViewController.swift
//  Recircle
//
//  Created by synerzip on 24/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class SearchProdViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: "SearchProductCell", bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        let nib1 = UINib(nibName: "SearchProdStaticCell", bundle: nil)
        
        collectionView.register(nib1, forCellWithReuseIdentifier: "cell1")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        
        //
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeight.constant = height
        print(height)
        self.view.layoutIfNeeded()

        //
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
       
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchProductCell
            
            cell.txtProdLocation.text = "cell"
            
            return cell
        
//            cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 723)
        } else {
            
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! SearchProdStaticCell
        
//        cell.frame = CGRect(x: 0, y: 334, width: self.view.frame.width, height: 381)
            
            return cell1
        
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}
       

