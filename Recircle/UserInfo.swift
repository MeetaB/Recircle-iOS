//
//  UserInfo.swift
//  Recircle
//
//  Created by synerzip on 17/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class UserInfo {
    public var email : String?
    public var user_addresses : Array<UserAddresses>?
    public var last_name : String?
    public var user_image_url : String?
    public var first_name : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let user_info_list = User_info.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of User_info Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserInfo]
    {
        var models:[UserInfo] = []
        for item in array
        {
            models.append(UserInfo(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let user_info = User_info(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: User_info Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        email = dictionary["email"] as? String
        if (dictionary["user_addresses"] != nil) { user_addresses = UserAddresses.modelsFromDictionaryArray(array: dictionary["user_addresses"] as! NSArray) }
        last_name = dictionary["last_name"] as? String
        user_image_url = dictionary["user_image_url"] as? String
        first_name = dictionary["first_name"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.user_image_url, forKey: "user_image_url")
        dictionary.setValue(self.first_name, forKey: "first_name")
        
        return dictionary
    }
    
}
