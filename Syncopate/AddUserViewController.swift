//
//  AddUserViewController.swift
//  Syncopate
//
//  Created by Emily Ou on 4/22/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import Alamofire
import AlamofireImage
import UIKit

class AddUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets
    @IBOutlet weak var addUserTableView: UITableView!
    var friends: NSArray = []
    var addList: [Int] = []
    var id: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUserTableView.delegate = self
        addUserTableView.dataSource = self
        
        addUserTableView.rowHeight = UITableView.automaticDimension
        addUserTableView.estimatedRowHeight = 100
        
        addUserTableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFriendsList()
        addUserTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addUserTableView.dequeueReusableCell(withIdentifier: "AddUserCell") as! AddUserCell
        let list = friends[indexPath.row] as! NSDictionary
        
        // Populate Cells
        let baseURL = "http://18.219.112.140/images/avatars/"
        let picURL = (list["profile_pic_url"] as? String)!
        let imageURL = URL(string: (baseURL + picURL))!
        let first_name = list["first_name"] as? String
        let last_name = list["last_name"] as? String
        let fullname = (first_name)! + " " + (last_name)!
        let email = list["email"] as! String
        let username = (email.replacingOccurrences(of: "@purdue.edu", with: ""))
        
        cell.nameLabel.text = (fullname)
        cell.profileImage.af.setImage(withURL: imageURL)
        cell.usernameLabel.text = username
        
        // Make the profile pic circular
        cell.profileImage.layer.masksToBounds = false
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
        cell.profileImage.clipsToBounds = true
        
        // Check if cell's id exists in array
        let id_friend = list["id"] as? Int
        if self.addList.contains(id_friend!) {
            cell.checkButton.setImage(UIImage(systemName: "checkmark.square"), for: UIControl.State.normal)
        } else {
            cell.checkButton.setImage(UIImage(systemName: "square"), for: UIControl.State.normal)
        }
        
        cell.checkButton.tag = indexPath.row
        cell.checkButton.addTarget(self, action: #selector(checkBox(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func checkBox(sender: UIButton) {
        let info = friends[sender.tag] as! NSDictionary
        let friend_id = info["id"] as! Int

        if (sender.imageView?.image == UIImage(systemName: "checkmark.square")) {
            sender.setImage(UIImage(systemName: "square"), for: UIControl.State.normal)
            self.addList.removeAll(where: {$0 == friend_id})
        } else {
            sender.setImage(UIImage(systemName: "checkmark.square"), for: UIControl.State.normal)
            self.addList.append(friend_id)
        }
    }
    
    @IBAction func onDoneButton(_ sender: Any) {
        // Alert controllers
        let alreadyInGroup = UIAlertController(title: "Error", message: "Someone you added is already in the group.", preferredStyle: .alert)
        let confirm = UIAlertController(title: "Confirm", message: "Are you sure you want to the user(s) to the group?", preferredStyle: .alert)
        
        // Dismiss screen if no friends are added
        if (self.addList.isEmpty) {
            self.dismiss(animated: true, completion: nil)
        }
        
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in }
        let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
            // Add users to group endpoint
            let url = "http://18.219.112.140:8000/api/v1/add-to-group/"
            // POST parameters
            let params: [String : Any] = [
                "group_id": self.id,
                "added_people": self.addList
            ]
            
            // HTTP request
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        if let data = value as? [String : Any] {
                            if (data["status"] as! String == "success") {
                                self.dismiss(animated: true, completion: nil)
                            }
                            else {
                                self.present(alreadyInGroup, animated: true)
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
        alreadyInGroup.addAction(ok)
        confirm.addAction(cancel)
        confirm.addAction(yes)
        
        self.present(confirm, animated: true)
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
                       self.addUserTableView.reloadData()
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
