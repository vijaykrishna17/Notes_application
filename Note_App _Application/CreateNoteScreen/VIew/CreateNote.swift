//
//  CreateNote.swift
//  Note_App _Application
//
//  Created by vijay on 11/3/19.
//  Copyright © 2019 vijay. All rights reserved.
//

import UIKit

class CreateNote: UIViewController, UITextFieldDelegate {

     var reachability : Reachability!
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var textVIew: UITextView!
    
    @IBOutlet weak var editBtn:UIBarButtonItem!
    @IBOutlet weak var createBtn:UIBarButtonItem!
    
    var notetitle : String?
    var desctiption : String?
    var note_ID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTF.delegate = self
        titleTF.text = notetitle
        textVIew.text = desctiption
        
    }

  
     @IBAction func saveData(_ sender: UIBarButtonItem) {
       saveCalling()
   
        if titleTF.text! != "" {

             }else{
            helper.showAlert(withTitle: "Alert", message: "Enter Title Name", controller: self)
            }
        
    }

    //_______________________________CREATENOTE___________________________
    
   
    
    
    func saveCalling(){
        do{
            self.reachability = try Reachability.init()
        }
        catch {
            print("Unreachabile Net Connection")
        }
        if((reachability!.connection) != .unavailable){
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
    guard let token  = UserDefaults.standard.object(forKey: "user_id") as? String else {
                return
            }
               
    let parameters : [  String: Any] = [
        "user_id": token ,
        "title" : titleTF.text as Any,
        "description": textVIew.text as Any ]
        
            guard  let myurl = URL(string: createNotes) else {return}
            var request = URLRequest(url: myurl)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            guard let httpbody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
            request.httpBody = httpbody
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
            if let data = data, response != nil, error == nil {
                do {

                    let responseObject = try JSONDecoder().decode(CreateModalClass.self, from: data)
                    UserDefaults.standard.set(responseObject.data.title, forKey: "title")
                    UserDefaults.standard.set(responseObject.data.description, forKey: "description")
                    if responseObject.success == true {
                        DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if let Vc  = self.storyboard?.instantiateViewController(withIdentifier: "GetAllDataTableViewController") as?  GetAllDataTableViewController{
                        self.navigationController?.pushViewController(Vc, animated: true)
                        
                              }
                           }
                   
                        } else if responseObject.success == false {
                            helper.showAlert(withTitle: "Alert", message: "  not Success", controller: self)
                        }
                    } catch {
                        helper.showAlert(withTitle: "Alert", message: "data not getting", controller: self)
                    }
                 }
                }.resume()
             }else{
            
            helper.showAlert(withTitle: "Alert", message: "Cheek InterNet Connection", controller: self)
          }
        }
   
    // _________________________Edit Api Calling________________________         _______________________________________________________
    
     
    @IBAction func editApi(_ sender: UIBarButtonItem) {
        editNoteApi()
    }
    
    
    
    func editNoteApi() {
        do{
            self.reachability = try Reachability.init()
        }
        catch {
            print("Unreachabile Net Connection")
        }
        if((reachability!.connection) != .unavailable){
        
        
        let title = self.titleTF.text
        let description = self.textVIew.text
        
        let parameters : [String: Any] = ["_id": self.note_ID!,
                                          "title": title as Any,
                                          "description":description as Any]
        
        guard  let myurl = URL(string: "http://13.233.64.181:4000/api/editnote") else {return}
        var request = URLRequest(url: myurl)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        guard let httpbody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = httpbody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data, response != nil, error == nil  {
                
                do {
                    let jsonDecoder =  JSONDecoder()
                    let decoder = try jsonDecoder.decode(EditModalClass.self, from: data)
                  
                    
                    if decoder.success == true {
                        DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                if let Vc  = self.storyboard?.instantiateViewController(withIdentifier: "GetAllDataTableViewController") as?  GetAllDataTableViewController{
                self.navigationController?.pushViewController(Vc, animated: true)
                            }
                        }
                        
                    }else{
                        
                        if decoder.success == false {
                            helper.showAlert(withTitle: "Alert", message: "not Success", controller: self)
                        }
                    }
                } catch {
                    helper.showAlert(withTitle: "Alert", message: "not respoding Data", controller: self)
                }
            }
            }.resume()
        }else {
             helper.showAlert(withTitle: "Alert", message: "Cheek InterNet Connection", controller: self)
        }
     }
   
   
}
