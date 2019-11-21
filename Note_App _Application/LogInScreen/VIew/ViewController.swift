//
//  ViewController.swift
//  Note_App _Application
//
//  Created by vijay on 11/3/19.
//  Copyright © 2019 vijay. All rights reserved.
//

import UIKit




class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var imagelogo: UIImageView!
    
    var reachability : Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTF.delegate = self
      
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    @IBAction func logInBtn(_ sender: UIButton) {
        
        
        if userNameTF.text != nil && passwordTF.text == "12345"
           {
           
                  loginAPI()
           
            
        }else {
        let alert = UIAlertController(title: "Alert", message: "Please enter email or password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
        
      
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == userNameTF  {
            
            let   email =  helper.isValidEmail(email: userNameTF.text!)
            if userNameTF.text! == ""{
                helper.showAlert(withTitle: "Alert", message: "Enter email Id", controller: self)
            } else  if email == false {
                helper.showAlert(withTitle: "Alert", message: "Enter valid email I'd", controller: self)
                
            }
            
        }
    }
    
    func loginAPI(){
        
        do{
            self.reachability = try Reachability.init()
        }
        catch {
            print("Unreachabile Net Connection")
        }
        if((reachability!.connection) != .unavailable){
            
          MBProgressHUD.showAdded(to: self.view, animated: true)

        let parameters : [String: Any] = [
            
            "action":"ValidateEmail","email": userNameTF.text as Any
        ]
        
        guard  let myurl = URL(string: logInUrl) else {return}
        var request = URLRequest(url: myurl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        guard let httpbody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = httpbody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let data = data, response != nil, error == nil {
                do {
                    let responseObject = try JSONDecoder().decode(LoginModal.self, from: data)
                    
                  
                    UserDefaults.standard.set(responseObject.data?._id, forKey: "_id")
                    if responseObject.success == true {
                        
                       
                        DispatchQueue.main.async {
                           MBProgressHUD.hide(for: self.view, animated: true)
                                if let Vc  =  self.storyboard?.instantiateViewController(withIdentifier: "GetAllDataTableViewController") as?  GetAllDataTableViewController{
                                    self.navigationController?.pushViewController(Vc, animated: true)
                               
                            }
                        }
                    } else if responseObject.success == false {
                        
                        helper.showAlert(withTitle: "Alert", message: "  login not Success", controller: self)
                    }
                } catch {
                    
                    
                    helper.showAlert(withTitle: "Alert", message: "not respoding", controller: self)
                }
            }
            }.resume()
        }else{
             helper.showAlert(withTitle: "Alert", message: "Cheek internet connection ", controller: self)
        }
    
   }
    
}

