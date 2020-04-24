//
//  AddFriendViewController.swift
//  Syncopate
//
//  Created by Emily Ou on 4/8/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import Alamofire
import AlamofireImage
import UIKit

class AddFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    // Outlets
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var addFriendTableView: UITableView!
    var friends: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFriendTableView.dataSource = self
        addFriendTableView.delegate = self
        userSearchBar.delegate = self
                
        addFriendTableView.rowHeight = UITableView.automaticDimension
        addFriendTableView.estimatedRowHeight = 110
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getQueryResult()
        addFriendTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addFriendTableView.dequeueReusableCell(withIdentifier: "AddFriendCell") as! AddFriendCell
        
        // Retrieve friends info
        let friend = friends[indexPath.row] as! NSDictionary
        
        // Populate cells
        let baseURL = "http://18.219.112.140/images/avatars/"
        let picURL = (friend["profile_pic_url"] as? String)!
        let imageURL = URL(string: (baseURL + picURL))!
        let first_name = friend["first_name"] as? String
        let last_name = friend["last_name"] as? String
        let fullname = (first_name)! + " " + (last_name)!
        let email = friend["email"] as! String
        let username = (email.replacingOccurrences(of: "@purdue.edu", with: ""))
        
        cell.nameLabel.text = (fullname)
        cell.profileImage.af.setImage(withURL: imageURL)
        cell.usernameLabel.text = username
        
        // Make the profile pic circular
        cell.profileImage.layer.masksToBounds = false
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
        cell.profileImage.clipsToBounds = true
        
        // add friend button is clicked 
        cell.addButtonAction = { [unowned self] in
            // Alert controller
            let options = UIAlertController(title: "Add Friend", message: "Are you sure you want to add \(fullname) as a friend?", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.sendFriendRequest(email: email)
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { (action) in }
            
            options.addAction(cancelButton)
            options.addAction(yesButton)
            
            self.present(options, animated: true)
        }
        
        return cell
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.userSearchBar.endEditing(true)
    }
    
    // Update list as search bar text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getQueryResult()
        addFriendTableView.reloadData()
    }
    
    func getQueryResult() {
        // Create search user POST parameters
        let query: [String : Any] = [
            "query": userSearchBar.text!
        ]
        
        // Search query endpoint
        let url = "http://18.219.112.140:8000/api/v1/search-users/"
        
        // HTTP request
        AF.request(url, method: .post, parameters: query, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        //self.searchBar = nil
                        
                        self.friends = data["users"] as! NSArray
                        self.addFriendTableView.reloadData()
                    }
                
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    func sendFriendRequest(email: String) {
        // TODO
        // Get incoming message request
        // Get outgoing message request
        // Update message request
        
        // Create send message request POST parameters
        let param: [String : Any] = [
            "email": email
        ]
        
        // Send message request endpoint
        let url = "http://18.219.112.140:8000/api/v1/send-request/"
        
        // HTTP request
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        if(data["status"] as! String == "success") {
                            self.addFriendTableView.reloadData()
                        }
                        else {
                            // Alert controller
                            let alreadyFriend = UIAlertController(title: "Already Friends", message: "You two are already friends!", preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "Ok", style: .default) { (action) in
                               
                            }
                            alreadyFriend.addAction(okButton)
                            self.present(alreadyFriend, animated: true)
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
