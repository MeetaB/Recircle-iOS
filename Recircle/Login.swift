//
//  Login.swift
//  Recircle
//
//  Created by synerzip on 05/06/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class Login {
    
    
    public var last_name : String?
    public var email : String?
    public var token : String?
    public var first_name : String?
    public var user_type : String?
    public var user_image_url : String?
    public var message : String?
    public var user_id : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Login.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Login]
    {
        var models:[Login] = []
        for item in array
        {
            models.append(Login(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = Login(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Login Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        last_name = dictionary["last_name"] as? String
        email = dictionary["email"] as? String
        token = dictionary["token"] as? String
        first_name = dictionary["first_name"] as? String
        user_type = dictionary["user_type"] as? String
        user_image_url = dictionary["user_image_url"] as? String
        message = dictionary["message"] as? String
        user_id = dictionary["user_id"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.token, forKey: "token")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.user_type, forKey: "user_type")
        dictionary.setValue(self.user_image_url, forKey: "user_image_url")
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.user_id, forKey: "user_id")
        
        return dictionary
    }
    
}
