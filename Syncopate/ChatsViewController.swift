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
        
        // TODO - Update to refer to group data - not currently in response
        // Group Image URL
        let imageUrl = URL(string: "http://18.219.112.140/images/avatars/default.png")!
        
        cell.nameLabel.text = group["group__name"] as? String
        cell.descriptionLabel.text = group["group__description"] as? String
        cell.profileView.af.setImage(withURL: imageUrl)
        
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
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller
        
        let cell = sender as! UITableViewCell
        let indexPath = chatsTableView.indexPath(for: cell)!
        let group = groups[indexPath.row] as! NSDictionary
        let chatDetails = segue.destination as! ChatDetailsViewController
        chatDetails.group = group
        
        chatsTableView.deselectRow(at: indexPath, animated: true)
    }
}
