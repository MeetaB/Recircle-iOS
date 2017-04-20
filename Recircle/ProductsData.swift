//
//  ProductsData.swift
//  Recircle
//
//  Created by synerzip on 19/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class ProductsData {
    public var products : Array<Products>?
    public var product_manufacturer_id : String?
    public var product_manufacturer_name : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let productsData_list = ProductsData.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of ProductsData Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ProductsData]
    {
        var models:[ProductsData] = []
        for item in array
        {
            models.append(ProductsData(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let productsData = ProductsData(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: ProductsData Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["products"] != nil) { products = Products.modelsFromDictionaryArray(array: dictionary["products"] as! NSArray) }
        product_manufacturer_id = dictionary["product_manufacturer_id"] as? String
        product_manufacturer_name = dictionary["product_manufacturer_name"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.product_manufacturer_id, forKey: "product_manufacturer_id")
        dictionary.setValue(self.product_manufacturer_name, forKey: "product_manufacturer_name")
        
        return dictionary
    }
    
}
