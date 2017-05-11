//
//  UserProductInfo.swift
//  Recircle
//
//  Created by synerzip on 17/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class UserProductInfo {
    public var product_id : String?
    public var avai_from_date : String?
    public var user_prod_desc : String?
    public var created_at : String?
    public var user_product_id : String?
    public var avai_to_date : String?
    public var product_avg_rating : Int!
    public var user_prod_images : Array<UserProdImages>?
    public var price_per_day : Int
    
    public var user_prod_reviews : Array<UserProdReviews>?
    public var user_prod_unavailability : Array<UserProdUnavailability>?
    public var user_product_discounts : Array<String>?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let user_product_info_list = User_product_info.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of User_product_info Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserProductInfo]
    {
        var models:[UserProductInfo] = []
        for item in array
        {
            models.append(UserProductInfo(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let user_product_info = User_product_info(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: User_product_info Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        product_id = dictionary["product_id"] as? String
        avai_from_date = dictionary["avai_from_date"] as? String
        user_prod_desc = dictionary["user_prod_desc"] as? String
        created_at = dictionary["created_at"] as? String
        user_product_id = dictionary["user_product_id"] as? String
        avai_to_date = dictionary["avai_to_date"] as? String
        product_avg_rating = dictionary["product_avg_rating"] as? Int
        if (dictionary["user_prod_images"] != nil) { user_prod_images = UserProdImages.modelsFromDictionaryArray(array: dictionary["user_prod_images"] as! NSArray) }
        price_per_day = (dictionary["price_per_day"] as? Int)!
        
        if (dictionary["user_prod_reviews"] != nil) { user_prod_reviews = UserProdReviews
            .modelsFromDictionaryArray(array: dictionary["user_prod_reviews"] as! NSArray)
        }
        
        if (dictionary["user_prod_unavailability"] != nil) { user_prod_unavailability = UserProdUnavailability
            .modelsFromDictionaryArray(array: dictionary["user_prod_unavailability"] as! NSArray)
        }
        
        
        
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.product_id, forKey: "product_id")
        dictionary.setValue(self.avai_from_date, forKey: "avai_from_date")
        dictionary.setValue(self.user_prod_desc, forKey: "user_prod_desc")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.user_product_id, forKey: "user_product_id")
        dictionary.setValue(self.avai_to_date, forKey: "avai_to_date")
        dictionary.setValue(self.product_avg_rating, forKey: "product_avg_rating")
        dictionary.setValue(self.price_per_day, forKey: "price_per_day")
        dictionary.setValue(self.user_prod_reviews, forKey: "user_prod_reviews")
        dictionary.setValue(self.user_prod_unavailability, forKey: "user_prod_unavailability")
        dictionary.setValue(self.user_product_discounts, forKey: "user_product_discounts")
        
        
        return dictionary
    }
    
}
