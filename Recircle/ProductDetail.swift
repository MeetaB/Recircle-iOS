//
//  ProductDetail.swift
//  Recircle
//
//  Created by synerzip on 19/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class ProductDetail {
    public var product_price : Int?
    public var product_image_url : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let product_detail_list = Product_detail.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Product_detail Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ProductDetail]
    {
        var models:[ProductDetail] = []
        for item in array
        {
            models.append(ProductDetail(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let product_detail = Product_detail(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Product_detail Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        product_price = dictionary["product_price"] as? Int
        product_image_url = dictionary["product_image_url"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.product_price, forKey: "product_price")
        dictionary.setValue(self.product_image_url, forKey: "product_image_url")
        
        return dictionary
    }
    
}
