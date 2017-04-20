//
//  ProdNames.swift
//  Recircle
//
//  Created by synerzip on 19/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class ProdNames {
    public var productsData : Array<ProductsData>?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let prod_names = ProdNames.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of ProdNames Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ProdNames]
    {
        var models:[ProdNames] = []
        for item in array
        {
            models.append(ProdNames(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let prod_names = ProdNames(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: ProdNames Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["productsData"] != nil) { productsData = ProductsData.modelsFromDictionaryArray(array: dictionary["productsData"] as! NSArray) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        
        return dictionary
    }

}
