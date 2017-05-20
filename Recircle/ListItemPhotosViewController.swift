//
//  ListItemPhotosViewController.swift
//  Recircle
//
//  Created by synerzip on 16/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit

class ListItemPhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var imagePicker : UIImagePickerController!
    var image : UIImage!

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let nib = UINib(nibName: "ProductImageCell", bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func crossTapped(_ sender: AnyObject) {
        
        self.dismiss(animated: true) { 
        
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //imageView.contentMode = .ScaleAspectFit
            image = pickedImage
            collectionView.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func galleryTapped(_ sender: AnyObject) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func proceed(_ sender: AnyObject) {
        performSegue(withIdentifier: "description", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProdImageCellView
        if image != nil {
            cell.productImage.image = self.image
        }
        return cell
        
    }
}
