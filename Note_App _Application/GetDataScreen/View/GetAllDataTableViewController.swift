//
//  GetAllDataTableViewController.swift
//  Note_App _Application
//
//  Created by vijay on 11/3/19.
//  Copyright © 2019 vijay. All rights reserved.
//

import UIKit




class GetAllDataTableViewController: UIViewController {
    
    var GetAllDetails = [data]()
   
    
   var reachability : Reachability!
    
    @IBOutlet weak var tableview: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       apiCalling()
    }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
   
    //______________________________GetAllNOtes___________________
   
    
    
    func apiCalling(){
        guard let token  = UserDefaults.standard.object(forKey: "user_id") as? String else {
            return
        }
        let parameters : [String: Any] = ["user_id": token]
        
        guard  let myurl = URL(string: getNotes) else {return}
        var request = URLRequest(url: myurl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        guard let httpbody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = httpbody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data, response != nil, error == nil  {
               
                do {
               
                    let jsonDecoder =  JSONDecoder()
                    let decoder = try jsonDecoder.decode(GetModal.self, from: data)
                  
                    self.GetAllDetails = decoder.data
                    if decoder.success == true {
                        DispatchQueue.main.async {
                         self.tableview.reloadData()
                           
                        }
                   
                    } else if decoder.success == false {
                        helper.showAlert(withTitle: "Alert", message: "  getting data not Success", controller: self)
                    }
                } catch {
                        helper.showAlert(withTitle: "Alert", message: "not respoding Data", controller: self)
                }
            }
            }.resume()
       }
   
    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        let Vc =  self.storyboard?.instantiateViewController(withIdentifier: "CreateNote") as?  CreateNote
        self.navigationController?.pushViewController(Vc!, animated: true)
    
    }

    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: "_id")
        
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navigation = UINavigationController.init(rootViewController: vc)
        let share = UIApplication.shared.delegate as? AppDelegate
        share?.window?.rootViewController = navigation
        share?.window?.makeKeyAndVisible()
        
        
    }
    
}
//    TABLEVIE DELEGATES AND METHODS _________________________________________________

extension GetAllDataTableViewController : UITableViewDelegate,UITableViewDataSource {


    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GetAllDetails.count
    }

   
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GetAllDataTableViewCell
       
        // Configure the cell...
        cell.titleLbl.text = GetAllDetails[indexPath.row].title
        cell.timeLbl.text = GetAllDetails[indexPath.row].updatedAt
        cell.descriptionLbl.text = GetAllDetails[indexPath.row].description

        return cell
    }
    
    //____________________________ EDIT NOTE API Hetting ________________________________________________________
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNote") as! CreateNote
            vc.notetitle = self.GetAllDetails[indexPath.row].title
            vc.desctiption = self.GetAllDetails[indexPath.row].description
             vc.note_ID = self.GetAllDetails[indexPath.row]._id
           self.navigationController?.pushViewController(vc, animated : true)
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
       // -----------------Delete Style----------------- ______________________________________________________
        do{
            self.reachability = try Reachability.init()
        }
        catch {
            print("Unreachabile Net Connection")
        }
        if((reachability!.connection) != .unavailable){
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
        
        if editingStyle == .delete {
            
                  let id = GetAllDetails[indexPath.row]._id
            
            let parameters : [String: Any] = ["_id": id ]
           
            guard  let myurl = URL(string: deleteNote) else {return}
            var request = URLRequest(url: myurl)
            request.httpMethod = "DELETE"
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            guard let httpbody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
            request.httpBody = httpbody
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let data = data, response != nil ,  error == nil  {
                    
                    do {
                       
                        let jsonDecoder =  JSONDecoder()
                        let decoder = try jsonDecoder.decode(Modal.self, from: data)
                        
                        if decoder.success == true {
                            DispatchQueue.main.async {
                                 MBProgressHUD.hide(for: self.view, animated: true)
                                UserDefaults.standard.removeObject(forKey: "_id")
                              
                                self.apiCalling()
                                tableView.reloadData()
                                
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
            tableView.endUpdates()
            
           }
        }else {
             helper.showAlert(withTitle: "Alert", message: "Cheek Internet Connection", controller: self)
        }
    
    }
}


