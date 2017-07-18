//
//  RecircleWebConstants.swift
//  Recircle
//
//  Created by synerzip on 18/04/17.
//  Copyright © 2017 synerzip. All rights reserved.
//

import Foundation

public class RecircleWebConstants {
    
    public static var RecircleURL : String = "http://d0767985.ngrok.io/api"
    
    public static var ProdNamesApi : String = RecircleURL + "/products/prodNames"
    
    public static var ProductsApi : String = RecircleURL + "/products"
    
    public static var SearchApi : String = RecircleURL + "/products/searchProd"
    
    public static var RentItemApi : String = RecircleURL + "/products/rentItem"
    
    public static var LoginApi : String = RecircleURL + "/users/signin"
    
    public static var OTPAPI : String = RecircleURL + "/users/otp"
    
    public static var USERSAPI : String = RecircleURL + "/users"
    
    public static var FORGOTPASSWORDAPI : String = RecircleURL + "/users/forgotPwd"
    
    public static var MESSAGESAPI : String = RecircleURL + "/user_message"
    
    
    public static var AUTHENTICATION_FAILED : Int = 401
    
    public static var UNAUTHORISED : Int = 403
    
    public static var NOT_FOUND : Int = 404


    
    
    
}
