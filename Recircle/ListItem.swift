//
//  ListItem.swift
//  Recircle
//
//  Created by synerzip on 22/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class ListItem {
    public var product_id : String?
    public var product_title : String?
    public var user_prod_desc : String?
    public var user_prod_discounts : Array<UserProdDiscounts>?
    public var user_prod_images : Array<UserProdImages>?
    public var user_prod_unavailability : Array<UserProdUnavailability>?
    public var fromAustin : Int?
    public var user_product_zipcode : Int?
    public var min_rental_day : Int?
    public var price_per_day : Int?
    
    
    public init() {
        
    }
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let ListItem_list = ListItem.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of ListItem Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [ListItem]
    {
        var models:[ListItem] = []
        for item in array
        {
            models.append(ListItem(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let ListItem = ListItem(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: ListItem Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        product_id = dictionary["product_id"] as? String
        product_title = dictionary["product_title"] as? String
        user_prod_desc = dictionary["user_prod_desc"] as? String
        if (dictionary["user_prod_discounts"] != nil) { user_prod_discounts = UserProdDiscounts.modelsFromDictionaryArray(array: dictionary["user_prod_discounts"] as! NSArray) }
        if (dictionary["user_prod_images"] != nil) { user_prod_images = UserProdImages.modelsFromDictionaryArray(array: dictionary["user_prod_images"] as! NSArray) }
        if (dictionary["user_prod_unavailability"] != nil) { user_prod_unavailability = UserProdUnavailability.modelsFromDictionaryArray(array: dictionary["user_prod_unavailability"] as! NSArray) }
        fromAustin = dictionary["fromAustin"] as? Int
        user_product_zipcode = dictionary["user_product_zipcode"] as? Int
        min_rental_day = dictionary["min_rental_day"] as? Int
        price_per_day = dictionary["price_per_day"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.product_id, forKey: "product_id")
        dictionary.setValue(self.product_title, forKey: "product_title")
        dictionary.setValue(self.user_prod_desc, forKey: "user_prod_desc")
        dictionary.setValue(self.fromAustin, forKey: "fromAustin")
        dictionary.setValue(self.user_product_zipcode, forKey: "user_product_zipcode")
        dictionary.setValue(self.min_rental_day, forKey: "min_rental_day")
        dictionary.setValue(self.price_per_day, forKey: "price_per_day")
        
        return dictionary
    }
    
}
