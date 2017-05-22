//
//  UserProdDiscounts.swift
//  Recircle
//
//  Created by synerzip on 22/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class UserProdDiscounts {
    
    public var discount_for_days : Int?
    public var isActive : Int?
    public var percentage : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let user_prod_discounts_list = UserProdDiscounts.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of User_prod_discounts Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserProdDiscounts]
    {
        var models:[UserProdDiscounts] = []
        for item in array
        {
            models.append(UserProdDiscounts(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let user_prod_discounts = UserProdDiscounts(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: User_prod_discounts Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        discount_for_days = dictionary["discount_for_days"] as? Int
        isActive = dictionary["isActive"] as? Int
        percentage = dictionary["percentage"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.discount_for_days, forKey: "discount_for_days")
        dictionary.setValue(self.isActive, forKey: "isActive")
        dictionary.setValue(self.percentage, forKey: "percentage")
        
        return dictionary
    }
    
}
