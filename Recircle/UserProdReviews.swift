//
//  UserProdReviews.swift
//  Recircle
//
//  Created by synerzip on 05/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class UserProdReviews {
    public var user : UserInfo?
    public var prod_rating : Int?
    public var reviewer_id : String?
    public var review_date : String?
    public var prod_review : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let user_prod_reviews_list = UserProdReviews.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of User_prod_reviews Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserProdReviews]
    {
        var models:[UserProdReviews] = []
        for item in array
        {
            models.append(UserProdReviews(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let user_prod_reviews = UserProdReviews(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: UserProdReviews Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["user"] != nil) { user = UserInfo(dictionary: dictionary["user"] as! NSDictionary) }
        prod_rating = dictionary["prod_rating"] as? Int
        reviewer_id = dictionary["reviewer_id"] as? String
        review_date = dictionary["review_date"] as? String
        prod_review = dictionary["prod_review"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.user?.dictionaryRepresentation(), forKey: "user")
        dictionary.setValue(self.prod_rating, forKey: "prod_rating")
        dictionary.setValue(self.reviewer_id, forKey: "reviewer_id")
        dictionary.setValue(self.review_date, forKey: "review_date")
        dictionary.setValue(self.prod_review, forKey: "prod_review")
        
        return dictionary
    }
    
}
