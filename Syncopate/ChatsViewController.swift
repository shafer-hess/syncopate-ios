//
//  ChatsViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/5/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import Alamofire
import AlamofireImage
import UIKit

class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var chatsTableView: UITableView!
    
    let myRefreshController = UIRefreshControl()
    
    var groups: NSArray = []
    var currUser: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.chatsTableView.delegate = self
        self.chatsTableView.dataSource = self
        
        myRefreshController.addTarget(self, action: #selector(getUserGroups), for: .valueChanged)
        self.chatsTableView.refreshControl = myRefreshController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCurrentUser()
        getUserGroups()
        self.chatsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: "ChatsCell") as! ChatsCell
        
        // Retrieve Group Information
        let group = groups[indexPath.row] as! NSDictionary
        
        // TODO: UPDATE GROUP IMAGE URL
        // Group Image URL
        let imageUrl = URL(string: "http://18.219.112.140/images/avatars/default.png")!
        cell.profileView.af.setImage(withURL: imageUrl)

        cell.nameLabel.text = group["group__name"] as? String
        
        if(group["group__description"] as? String == "") {
            cell.descriptionLabel.isHidden = true
        } else {
            cell.descriptionLabel.isHidden = false
            cell.descriptionLabel.text = group["group__description"] as? String
        }
    
        if(group["pinned"] as? Int == 1) {
            cell.pinButton.imageView?.image = UIImage(named: "pin-group-selected")
        } else {
            cell.pinButton.imageView?.image = UIImage(named: "pin-group-unselected")
        }
        
        cell.pinButton.tag = indexPath.row
        cell.pinButton.addTarget(self, action: #selector(pinGroup(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    // Get UserGroups Request
    @objc func getUserGroups() {
        // UserGroups Endpoint
        let url = "http://18.219.112.140:8000/api/v1/get-user-group/"
        
        // HTTP Request
        AF.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
        
            switch response.result {
                case .success(let value):
                    if let data = value as? NSArray {
                        self.groups = data
                        self.chatsTableView.reloadData()
                        self.myRefreshController.endRefreshing()
                    }
                
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func getCurrentUser() {
        // Identify User
        let url = "http://18.219.112.140:8000/api/v1/identify/"
        
        // Identidy HTTP Request
        AF.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        // Store Current User information
                        self.currUser = data as NSDictionary
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
    
    @objc func pinGroup(sender: UIButton) {
        // Retrieve Group from buttons indexpath tag
        let group = groups[sender.tag] as! NSDictionary
        
        // Retrieve current pin status
        let pinned: Int = group["pinned"] as! Int

        // Set parameters and url for HTTP Request
        let url = "http://18.219.112.140:8000/api/v1/pin-chat/"
        let params: [String: Any] = [
            "group_id": group["group__id"] as! Int,
            "pinned": (pinned == 0) ? true : false
        ]
                
        // HTTP Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        if(data["status"] as! String == "success") {
                            // Update Pin Color
                            if(pinned == 1) {
                                sender.imageView?.image = UIImage(named: "pin-group-unselected")
                            } else {
                                sender.imageView?.image = UIImage(named: "pin-group-selected")
                            }
                        } else {
                            print("Did not pin")
                        }
                    }
            
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller
        
        if segue.identifier == "ChatsDetailsSegue" {
            let cell = sender as! UITableViewCell
        
            let indexPath = chatsTableView.indexPath(for: cell)!
        
            let group = groups[indexPath.row] as! NSDictionary
        
            let chatDetails = segue.destination as! MessageKitViewController
            chatDetails.group = group
            chatDetails.currUser = currUser
        
            chatsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func rewindToChats(unwindSegue: UIStoryboardSegue) {}
}
