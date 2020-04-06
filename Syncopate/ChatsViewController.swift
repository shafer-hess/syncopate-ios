//
//  ChatsViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/5/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import Alamofire
import UIKit

class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var chatsTableView: UITableView!
    
    var Groups: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.chatsTableView.delegate = self
        self.chatsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserGroups()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: "ChatsCell") as! ChatsCell
        
        return cell
    }
    
    // Get UserGroups Request
    func getUserGroups() {
        // UserGroups Endpoint
        let url = "http://18.219.112.140:8000/api/v1/get-user-group/"
        
        // HTTP Request
        AF.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
        
            switch response.result {
                case .success(let value):
                    if let data = value as? NSArray {
                        
                        // Getting Info From Response
                        let dict = data[0] as! NSDictionary
                        let user_entry = dict["users"] as! NSArray
                        for user in user_entry {
                            let user_info = user as! NSDictionary
                            print(user_info["user__first_name"] as! String)
                        }
                        
                        
                        // self.groups = data
                        // print(self.groups)
                    }
                
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    // Logout HTTP Request
    @IBAction func onLogout(_ sender: Any) {
        // Login Endpoint
        let url = "http://18.219.112.140:8000/api/v1/logout/"
        
        // Login HTTP Request
        AF.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        if(data["status"] as! String == "success") {
                            UserDefaults.standard.set(false, forKey: "loggedIn")
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            print("Error Logging Out")
                        }
                    }
                
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
