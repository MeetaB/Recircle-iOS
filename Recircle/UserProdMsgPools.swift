/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class UserProdMsgPools {
	public var user_prod_msg_pool_id : String?
	public var user_prod_msg_id : String?
	public var user_id : String?
	public var user_msg : String?
	public var is_read : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let user_prod_msg_pools_list = User_prod_msg_pools.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of User_prod_msg_pools Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserProdMsgPools]
    {
        var models:[UserProdMsgPools] = []
        for item in array
        {
            models.append(UserProdMsgPools(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let user_prod_msg_pools = User_prod_msg_pools(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: User_prod_msg_pools Instance.
*/
	required public init?(dictionary: NSDictionary) {

		user_prod_msg_pool_id = dictionary["user_prod_msg_pool_id"] as? String
		user_prod_msg_id = dictionary["user_prod_msg_id"] as? String
		user_id = dictionary["user_id"] as? String
		user_msg = dictionary["user_msg"] as? String
		is_read = dictionary["is_read"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.user_prod_msg_pool_id, forKey: "user_prod_msg_pool_id")
		dictionary.setValue(self.user_prod_msg_id, forKey: "user_prod_msg_id")
		dictionary.setValue(self.user_id, forKey: "user_id")
		dictionary.setValue(self.user_msg, forKey: "user_msg")
		dictionary.setValue(self.is_read, forKey: "is_read")

		return dictionary
	}

}
