//
//  AlamofireAPICall.swift
//  Recircle
//
//  Created by synerzip on 07/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AlamofireAPICall {
    
    open func callAPI (_endpoint: String,type : HTTPMethod )
        
    {
        let url = "http://7c5a25cc.ngrok.io/api/" + "products/prodNames"
        
        Alamofire.request(URL(string: url)!,
                          method: type)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                self.handleResponse(JSON(response.result.value))
        }
        
        
    }
    
    open func handleResponse(_ response : JSON) {
        
    }
    
    open static func handleSession( _ value : Bool) {
        
        if !value {
            _ = KeychainWrapper.standard.removeAllKeys()
            //showLoginDialog()
        } else {
            KeychainWrapper.standard.set(true, forKey: RecircleAppConstants.ISLOGGEDINKEY)
        }
    }
    
    
}
