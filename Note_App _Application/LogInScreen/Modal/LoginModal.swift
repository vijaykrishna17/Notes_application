//
//  LoginModal.swift
//  Note_App _Application
//
//  Created by vijay on 11/3/19.
//  Copyright © 2019 vijay. All rights reserved.
//

import Foundation

class LoginModal : Codable {
    
    let success: Bool
    let message: String
    let data: Data?
    
    init(success:Bool,message:String,data:Data)
    {
        self.success = success
        self.message = message
        self.data = data
    }
    
    
}
class Data : Codable {
    
    let _id : String
    let email: String
    let createdAt : String
    let updatedAt : String
    let __v : Int
    init(_id:String,email:String,createdAt:String,updatedAt:String,__V:Int){
        self._id = _id
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.__v = __V
        
    }
}
