//
//  ListItemPhotosViewController.swift
//  Recircle
//
//  Created by synerzip on 16/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import UIKit
import DKImagePickerController

class ListItemPhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var imagePicker : UIImagePickerController!
    var image : UIImage!
    
    var selectedImages : [UIImage] = []
    
    var listItem : ListItem!

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let nib = UINib(nibName: "ListItemImageCell", bundle: nil)
        
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
            self.selectedImages.append(pickedImage)
            self.collectionView.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func cameraTapped(_ sender: AnyObject) {
        
        //checking if camera is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)

        } else {
            print("The device has no camera")
            let alert = UIAlertController(title: "Alert", message: "This device has no camera", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func galleryTapped(_ sender: AnyObject) {
        
        let pickerController = DKImagePickerController()
        
        pickerController.showsCancelButton =  true

        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            
            for asset in assets {
                asset.fetchOriginalImage(true, completeBlock: {
                    (image, info) in
                    self.image = image
                    self.selectedImages.append(image!)
                    self.collectionView.reloadData()
                })
            }
        }
        
        self.present(pickerController, animated: true)
        
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
        
        if self.selectedImages.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Please upload atleast one image", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if ListItemObject.listItem != nil {
                self.listItem = ListItemObject.listItem
            } else {
                self.listItem = ListItem()
            }
            
            var prodImages : [UserProdImages] = []
            
            let prodImage = UserProdImages()
            
            //TODO : hardcoding as not integrated with s3 bucket
            
            prodImage.user_prod_image_url = "https://s3.ap-south-1.amazonaws.com/recircleimages/1398934243000_1047081.jpg"
            
            prodImages.append(prodImage)
            
            self.listItem.user_prod_images = prodImages
            
            ListItemObject.listItem = self.listItem
            
            ListItemObject.listItemImages = self.selectedImages
            
            performSegue(withIdentifier: "description", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ListItemPhotoCell
        let image = selectedImages[indexPath.item]
        cell.productImage.image = image
        cell.crossButton.isHidden = false
        cell.crossButton.tag = indexPath.item
        cell.crossButton.isUserInteractionEnabled = true
        cell.crossButton.addTarget(self, action: #selector(ListItemPhotosViewController.removeImage(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("select")
    }
    
    
    
    func removeImage(_ sender: AnyObject) {
        let index = sender.tag
        selectedImages.remove(at: index!)
        collectionView.reloadData()
    }
}
