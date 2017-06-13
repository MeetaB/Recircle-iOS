//
//  UserAddresses.swift
//  Recircle
//
//  Created by synerzip on 17/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class UserAddress {
    public var user_address_id : String?
    public var state : String?
    public var country : String?
    public var street : String?
    public var city : String?
    public var zip : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let user_addresses_list = User_addresses.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of User_addresses Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserAddress]
    {
        var models:[UserAddress] = []
        for item in array
        {
            models.append(UserAddress(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let user_addresses = User_addresses(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: User_addresses Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        user_address_id = dictionary["user_address_id"] as? String
        state = dictionary["state"] as? String
        country = dictionary["country"] as? String
        street = dictionary["street"] as? String
        city = dictionary["city"] as? String
        zip = dictionary["zip"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.user_address_id, forKey: "user_address_id")
        dictionary.setValue(self.state, forKey: "state")
        dictionary.setValue(self.country, forKey: "country")
        dictionary.setValue(self.street, forKey: "street")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.zip, forKey: "zip")
        
        return dictionary
    }
    
}
