//
//  NotificationsViewController.swift
//  Syncopate
//
//  Created by Emily Ou on 4/9/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets and variables
    @IBOutlet weak var notificationTableView: UITableView!
    var friends: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        
        notificationTableView.rowHeight = UITableView.automaticDimension
        notificationTableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getIncomingRequest()
        notificationTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationTableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        
        // Retrieve friends info
        let friend = friends[indexPath.row] as! NSDictionary
        
        // Populate cells
        let baseURL = "http://18.219.112.140/images/avatars/"
        let picURL = (friend["sender__profile_pic_url"] as? String)!
        let imageURL = URL(string: (baseURL + picURL))!
        let first_name = friend["sender__first_name"] as? String
        let last_name = friend["sender__last_name"] as? String
        let fullname = (first_name)! + " " + (last_name)!
        let id = friend["id"] as! Int
        
        cell.profileImage.af.setImage(withURL: imageURL)
        cell.nameLabel.text = fullname
        
        // Make the profile pic circular
        cell.profileImage.layer.masksToBounds = false
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
        cell.profileImage.clipsToBounds = true
        
        // action buttons response
        cell.acceptButtonAction = { [unowned self] in
            // Alert controller
            let options = UIAlertController(title: "Accept Request", message: "Are you sure you want to accept \(fullname)'s friend request?", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "Yes", style: .default) { (action) in
                    self.updateRequest(request_id: id, reply: true)
            }
            let noButton = UIAlertAction(title: "No", style: .default) { (action) in }
                
            options.addAction(yesButton)
            options.addAction(noButton)
                
            self.present(options, animated: true)
        }
        
        cell.denyButtonAction = { [unowned self] in
            // Alert controller
            let options = UIAlertController(title: "Accept Request", message: "Are you sure you want to deny \(fullname)'s friend request?", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "Yes", style: .default) { (action) in }
            let noButton = UIAlertAction(title: "No", style: .default) { (action) in }
                
            options.addAction(yesButton)
            options.addAction(noButton)
                
            self.present(options, animated: true)
        }
        
        return cell
    }
    
    func getIncomingRequest() {
        // Incoming request endpoint
        let url = "http://18.219.112.140:8000/api/v1/requests/"
            
        // HTTP request
        AF.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        self.friends = data["requests"] as! NSArray
                        self.notificationTableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

    func updateRequest(request_id: Int, reply: Bool) {
        // Create response POST parameters
        let action: [String : Any] = [
            "request_id": request_id,
            "action": reply
        ]
        
        // Request action endpoint
        let url = "http://18.219.112.140:8000/api/v1/request-action/"
            
        // HTTP request
        AF.request(url, method: .post, parameters: action, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        if(data["status"] as! String == "success") {
                            self.notificationTableView.reloadData()
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
