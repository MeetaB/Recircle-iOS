//
//  UserProdImages.swift
//  Recircle
//
//  Created by synerzip on 17/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class UserProdImages {
    public var created_at : String?
    public var user_prod_image_url : String?
    
    
    public init() {
        
    }
    
    public init(createdAt : String , imageUrl : String) {
        self.created_at = createdAt
        self.user_prod_image_url = imageUrl
    }
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let user_prod_images_list = User_prod_images.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of User_prod_images Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserProdImages]
    {
        var models:[UserProdImages] = []
        for item in array
        {
            models.append(UserProdImages(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let user_prod_images = User_prod_images(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: User_prod_images Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        created_at = dictionary["created_at"] as? String
        user_prod_image_url = dictionary["user_prod_image_url"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.user_prod_image_url, forKey: "user_prod_image_url")
        
        return dictionary
    }
    
}
