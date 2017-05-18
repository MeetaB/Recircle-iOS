//
//  RentItem.swift
//  Recircle
//
//  Created by synerzip on 16/05/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class RentItem {
    
    public var date_on_order : String?
    public var order_from_date : String?
    public var order_to_date : String?
    public var user_msg : String?
    public var user_product_id : String?
    public var final_payment : Int?
    public var payment_discount : Int?
    public var payment_total : Int?
    public var protection_plan : Int?
    public var protection_plan_fee : Int?
    public var service_fee : Int?
    
    //Adding additional parameters for internal logic
    public var days_selected : Int?
    public var price_per_day : Int?
    public var user_product_discounts : Array<String>?
    public var duration : Int?
    public var product_title : String?
    public var prod_image_url : String?
    public var user_name : String?
    public var user_image_url : String?
    
    
    public init() {
        
    }
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = RentItem.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of RentItem Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [RentItem]
    {
        var models:[RentItem] = []
        for item in array
        {
            models.append(RentItem(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = RentItem(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: RentItem Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        date_on_order = dictionary["date_on_order"] as? String
        order_from_date = dictionary["order_from_date"] as? String
        order_to_date = dictionary["order_to_date"] as? String
        user_msg = dictionary["user_msg"] as? String
        user_product_id = dictionary["user_product_id"] as? String
        final_payment = dictionary["final_payment"] as? Int
        payment_discount = dictionary["payment_discount"] as? Int
        payment_total = dictionary["payment_total"] as? Int
        protection_plan = dictionary["protection_plan"] as? Int
        protection_plan_fee = dictionary["protection_plan_fee"] as? Int
        service_fee = dictionary["service_fee"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.date_on_order, forKey: "date_on_order")
        dictionary.setValue(self.order_from_date, forKey: "order_from_date")
        dictionary.setValue(self.order_to_date, forKey: "order_to_date")
        dictionary.setValue(self.user_msg, forKey: "user_msg")
        dictionary.setValue(self.user_product_id, forKey: "user_product_id")
        dictionary.setValue(self.final_payment, forKey: "final_payment")
        dictionary.setValue(self.payment_discount, forKey: "payment_discount")
        dictionary.setValue(self.payment_total, forKey: "payment_total")
        dictionary.setValue(self.protection_plan, forKey: "protection_plan")
        dictionary.setValue(self.protection_plan_fee, forKey: "protection_plan_fee")
        dictionary.setValue(self.service_fee, forKey: "service_fee")
        
        return dictionary
    }

}
