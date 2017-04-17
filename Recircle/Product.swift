//
//  PopularProducts.swift
//  Recircle
//
//  Created by synerzip on 17/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation


public class Product {
    public var user_product_info : UserProductInfo?
    public var user_info : UserInfo?
    public var product_info : ProductInfo?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let popularProducts_list = PopularProducts.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of PopularProducts Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Product]
    {
        var models:[Product] = []
        for item in array
        {
            models.append(Product(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let popularProducts = PopularProducts(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: PopularProducts Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["user_product_info"] != nil) { user_product_info = UserProductInfo(dictionary: dictionary["user_product_info"] as! NSDictionary) }
        if (dictionary["user_info"] != nil) { user_info = UserInfo(dictionary: dictionary["user_info"] as! NSDictionary) }
        if (dictionary["product_info"] != nil) { product_info = ProductInfo(dictionary: dictionary["product_info"] as! NSDictionary) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.user_product_info?.dictionaryRepresentation(), forKey: "user_product_info")
        dictionary.setValue(self.user_info?.dictionaryRepresentation(), forKey: "user_info")
        dictionary.setValue(self.product_info?.dictionaryRepresentation(), forKey: "product_info")
        
        return dictionary
    }
    
}
