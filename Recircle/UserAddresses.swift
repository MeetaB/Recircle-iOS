//
//  UserAddresses.swift
//  Recircle
//
//  Created by synerzip on 17/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class UserAddresses {
    public var street2 : String?
    public var state : String?
    public var country : String?
    public var street1 : String?
    public var city : String?
    public var zip : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let user_addresses_list = User_addresses.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of User_addresses Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserAddresses]
    {
        var models:[UserAddresses] = []
        for item in array
        {
            models.append(UserAddresses(dictionary: item as! NSDictionary)!)
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
        
        street2 = dictionary["street2"] as? String
        state = dictionary["state"] as? String
        country = dictionary["country"] as? String
        street1 = dictionary["street1"] as? String
        city = dictionary["city"] as? String
        zip = dictionary["zip"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.street2, forKey: "street2")
        dictionary.setValue(self.state, forKey: "state")
        dictionary.setValue(self.country, forKey: "country")
        dictionary.setValue(self.street1, forKey: "street1")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.zip, forKey: "zip")
        
        return dictionary
    }
    
}
