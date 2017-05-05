//
//  UserProdUnavailability.swift
//  Recircle
//
//  Created by synerzip on 05/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class UserProdUnavailability {
    public var unavai_to_date : String?
    public var unavai_from_date : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let user_prod_unavailability_list = UserProdUnavailability.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of User_prod_unavailability Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserProdUnavailability]
    {
        var models:[UserProdUnavailability] = []
        for item in array
        {
            models.append(UserProdUnavailability(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let user_prod_unavailability = User_prod_unavailability(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: UserProdUnavailability Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        unavai_to_date = dictionary["unavai_to_date"] as? String
        unavai_from_date = dictionary["unavai_from_date"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.unavai_to_date, forKey: "unavai_to_date")
        dictionary.setValue(self.unavai_from_date, forKey: "unavai_from_date")
        
        return dictionary
    }
    
}
