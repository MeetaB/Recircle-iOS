//
//  Products.swift
//  Recircle
//
//  Created by synerzip on 19/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class Products {
    public var product_title : String?
    public var product_id : String?
    public var product_detail : ProductDetail?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let products_list = Products.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Products Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Products]
    {
        var models:[Products] = []
        for item in array
        {
            models.append(Products(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let products = Products(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Products Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        product_title = dictionary["product_title"] as? String
        product_id = dictionary["product_id"] as? String
        if (dictionary["product_detail"] != nil) { product_detail = ProductDetail(dictionary: dictionary["product_detail"] as! NSDictionary) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.product_title, forKey: "product_title")
        dictionary.setValue(self.product_id, forKey: "product_id")
        dictionary.setValue(self.product_detail?.dictionaryRepresentation(), forKey: "product_detail")
        
        return dictionary
    }
    
}
