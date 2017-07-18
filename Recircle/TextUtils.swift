//
//  TextUtils.swift
//  Recircle
//
//  Created by synerzip on 18/07/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

class TextUtils {
    
    public static func converToBase64(_ text : String) -> String{
        
        let longstring = text + "YXVzdGlucmV6aXBwdW5l"
        let data = (longstring).data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        print(base64)// dGVzdDEyMw==\n
        
        return base64
    }

}
