//
//  FriendsViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/7/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets
    @IBOutlet weak var addFriendButton: UIBarButtonItem!
    @IBOutlet weak var friendsTableView: UITableView!
    var friends: NSArray = []
    
    @IBAction func addFriendActionButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()

        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        friendsTableView.rowHeight = UITableView.automaticDimension
        friendsTableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFriendsList()
        friendsTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
        
        // Retrieve friends info
        let friend = friends[indexPath.row] as! NSDictionary
 
        // Populate cells
        let baseURL = "http://18.219.112.140/images/avatars/"
        let picURL = (friend["profile_pic_url"] as? String)!
        let imageURL = URL(string: (baseURL + picURL))!
        let first_name = friend["first_name"] as? String
        let last_name = friend["last_name"] as? String
        let email = friend["email"] as? String
        let username = (email?.replacingOccurrences(of: "@purdue.edu", with: ""))!
        
        cell.nameLabel.text = ((first_name)!) + " " + ((last_name)!)
        cell.profileImage.af.setImage(withURL: imageURL)
        cell.usernameLabel.text = username 
        
        // Make the profile pic circular
        cell.profileImage.layer.masksToBounds = false
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
        cell.profileImage.clipsToBounds = true
        
        return cell
    }
    
    func getFriendsList() {
        // Friends List Endpoint
        let url = "http://18.219.112.140:8000/api/v1/load-friends/"

        // HTTP Request
        AF.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        self.friends = data["friends"] as! NSArray
                        self.friendsTableView.reloadData()
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
