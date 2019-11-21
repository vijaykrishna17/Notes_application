//
//  EditModal.swift
//  Note_App _Application
//
//  Created by vijay on 11/18/19.
//  Copyright © 2019 vijay. All rights reserved.
//

import Foundation

class EditModalClass : Codable {
    let success: Bool
    let message : String
    let title : String
    let description: String

    
    init(success:Bool,message:String, title: String, description : String) {
        self.success = success
        self.message = message
        self.title = title
        self.description = description
    }
}

