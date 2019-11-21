//
//  DeleteModalClass.swift
//  Note_App _Application
//
//  Created by vijay on 11/11/19.
//  Copyright © 2019 vijay. All rights reserved.
//

import Foundation




class Modal : Codable {
       let success : Bool
       let message : String
    
    
    init(success:Bool,message:String){
              self.success = success
              self.message = message
             
    }
}
