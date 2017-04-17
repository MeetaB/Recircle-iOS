//
//  ProductDetails.swift
//  Recircle
//
//  Created by synerzip on 17/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ProductDetails {
    

public var popularProducts : Array<Product>?
public var productDetails : Array<Product>?

/**
 Returns an array of models based on given dictionary.
 
 Sample usage:
 let product_details = ProductDetails.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
 
 - parameter array:  NSArray from JSON dictionary.
 
 - returns: Array of ProductDetails Instances.
 */
public class func modelsFromDictionaryArray(array:NSArray) -> [ProductDetails]
{
    var models:[ProductDetails] = []
    for item in array
    {
        models.append(ProductDetails(dictionary: item as! NSDictionary)!)
    }
    return models
}

/**
 Constructs the object based on the given dictionary.
 
 Sample usage:
 let product_details = ProductDetails(someDictionaryFromJSON)
 
 - parameter dictionary:  NSDictionary from JSON.
 
 - returns: ProductDetails Instance.
 */
required public init?(dictionary: NSDictionary) {
    
    if (dictionary["popularProducts"] != nil) { popularProducts = Product.modelsFromDictionaryArray(array: dictionary["popularProducts"] as! NSArray) }
    if (dictionary["productDetails"] != nil) { productDetails = Product.modelsFromDictionaryArray(array: dictionary["productDetails"] as! NSArray) }
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
