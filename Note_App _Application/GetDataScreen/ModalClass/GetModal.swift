//
//  GetModal.swift
//  Note_App _Application
//
//  Created by vijay on 11/3/19.
//  Copyright © 2019 vijay. All rights reserved.
//

import Foundation



class data : Codable
{
    let _id : String
    let user_id : String
    let title :  String
    let description : String
    let createdAt : String
    let updatedAt : String
    let __v : Int
    
    init(_id:String,user_id:String,title:String,
         description:String,createdAt:String,updatedAt:String,__V:Int)
    {
        self._id = _id
        self.user_id = user_id
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.__v = __V
       
    }
}


class GetModal : Codable {
    let success : Bool
    let message : String
    let data : [data]
    init(data:[data],success:Bool,message:String) {
        self.success = success
        self.message = message
        self.data = data
    }
}
