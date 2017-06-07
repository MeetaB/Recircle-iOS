//
//  ProductInfo.swift
//  Recircle
//
//  Created by synerzip on 17/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class ProductInfo {
    public var product_category_id : String?
    public var product_model_id : String?
    public var product_manufacturer_name : String?
    public var product_category_description : String?
    public var product_category_name : String?
    public var product_image_url : UserProdImages?
    public var product_manufacturer_id : String?
    public var product_description : String?
    public var product_title : String?
    public var product_price : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let product_info_list = Product_info.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Product_info Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ProductInfo]
    {
        var models:[ProductInfo] = []
        for item in array
        {
            models.append(ProductInfo(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let product_info = Product_info(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Product_info Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        product_category_id = dictionary["product_category_id"] as? String
        product_model_id = dictionary["product_model_id"] as? String
        product_manufacturer_name = dictionary["product_manufacturer_name"] as? String
        product_category_description = dictionary["product_category_description"] as? String
        product_category_name = dictionary["product_category_name"] as? String
        product_image_url = dictionary["product_image_url"] as? UserProdImages
        product_manufacturer_id = dictionary["product_manufacturer_id"] as? String
        product_description = dictionary["product_description"] as? String
        product_title = dictionary["product_title"] as? String
        product_price = dictionary["product_price"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.product_category_id, forKey: "product_category_id")
        dictionary.setValue(self.product_model_id, forKey: "product_model_id")
        dictionary.setValue(self.product_manufacturer_name, forKey: "product_manufacturer_name")
        dictionary.setValue(self.product_category_description, forKey: "product_category_description")
        dictionary.setValue(self.product_category_name, forKey: "product_category_name")
        dictionary.setValue(self.product_image_url, forKey: "product_image_url")
        dictionary.setValue(self.product_manufacturer_id, forKey: "product_manufacturer_id")
        dictionary.setValue(self.product_description, forKey: "product_description")
        dictionary.setValue(self.product_title, forKey: "product_title")
        dictionary.setValue(self.product_price, forKey: "product_price")
        
        return dictionary
    }
    
}
