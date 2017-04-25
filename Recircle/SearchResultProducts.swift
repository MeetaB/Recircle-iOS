//
//  SearchResultProducts.swift
//  Recircle
//
//  Created by synerzip on 25/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class SearchResultProducts {
    public var products : Array<Product>?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let searchResultProducts = SearchResultProducts.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of SearchResultProducts Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [SearchResultProducts]
    {
        var models:[SearchResultProducts] = []
        for item in array
        {
            models.append(SearchResultProducts(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let searchResultProducts = SearchResultProducts(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: SearchResultProducts Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["products"] != nil) { products = Product.modelsFromDictionaryArray(array: dictionary["products"] as! NSArray) }
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
