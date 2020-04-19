//
//  ChatDetailsViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/6/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import Alamofire
import UIKit

class ChatDetailsViewController: UIViewController {
    // Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var groupNameButton: UIButton!
    @IBOutlet weak var groupDescButton: UIButton!
    @IBOutlet weak var leaveGroupButton: UIButton!
    @IBOutlet weak var pinSwitch: UISwitch!
    
    // Variables
    var groupId: Int = -1
    var group: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Change title of view controller
        self.title = group["group__name"] as? String
        
        // Populate description label
        if(group["group__description"] as? String == "") {
            descriptionLabel.isHidden = true
        } else {
            descriptionLabel.text = group["group__description"] as? String
        }
        
        // Asign pinned switch state
        if(group["pinned"] as! Bool) {
            pinSwitch.setOn(true, animated: true)
        } else {
            pinSwitch.setOn(false, animated: true)
        }
        
    }

    @IBAction func editGroupName(_ sender: Any) {
        // Change Name Modal
        let changeNameAlert = UIAlertController(title: "Change Group Name", message: "Enter new group name:", preferredStyle: .alert)
        changeNameAlert.addTextField { (textField) in
            textField.text = self.group["group__name"] as? String
        }
        
        // Change Name Buttons
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { (action) in }
        let changeButton = UIAlertAction(title: "Change Name", style: .default) { (action) in
            
            // HTTP Request
            let url = "http://18.219.112.140:8000/api/v1/edit-group-name/"
            
            let newName: String = changeNameAlert.textFields![0].text!
            
            let params: [String : Any] = [
                "group_id": self.groupId,
                "name": newName
            ]
            
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in

                switch response.result {
                    case .success(let value):
                        if let data = value as? [String : Any] {
                            if(data["status"] as! String == "success") {
                                self.title = newName
                            }
                        }

                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
        
        // Add buttons and present modal
        changeNameAlert.addAction(cancelButton)
        changeNameAlert.addAction(changeButton)
        self.present(changeNameAlert, animated: true, completion: nil)
    }
    
    @IBAction func editGroupDesc(_ sender: Any) {
        // Change Name Modal
        let changeDescAlert = UIAlertController(title: "Change Group Description", message: "Enter new group description:", preferredStyle: .alert)
        changeDescAlert.addTextField { (textField) in
            textField.text = self.group["group__description"] as? String
        }
        
        // Change Name Buttons
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { (action) in }
        let changeButton = UIAlertAction(title: "Change Description", style: .default) { (action) in
            
            // HTTP Request
            let url = "http://18.219.112.140:8000/api/v1/edit-group-description/"
            
            let newDesc: String = changeDescAlert.textFields![0].text!
            
            let params: [String : Any] = [
                "group_id": self.groupId,
                "description": newDesc
            ]
            
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in

                switch response.result {
                    case .success(let value):
                        if let data = value as? [String : Any] {
                            if(data["status"] as! String == "success") {
                                self.descriptionLabel.text = newDesc
                            }
                        }

                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
        
        // Add buttons and present modal
        changeDescAlert.addAction(cancelButton)
        changeDescAlert.addAction(changeButton)
        self.present(changeDescAlert, animated: true, completion: nil)
    }
    
    @IBAction func pinGroup(_ sender: Any) {
        let pin = sender as! UISwitch
        
        var shouldPinGroup: Bool = false
        if(pin.isOn) {
            shouldPinGroup = true
        } else {
            shouldPinGroup = false
        }
        
        // HTTP Request
        let url = "http://18.219.112.140:8000/api/v1/pin-chat/"
        
        let params: [String : Any] = [
            "group_id": groupId,
            "pinned": shouldPinGroup
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        if(data["status"] as! String == "success") {
                        }
                    }

                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func leaveGroup(_ sender: Any) {
        // Leave Group Alert
        let leaveGroupAlert = UIAlertController(title: "Leave Group", message: "Are you sure you want to leave this group?", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title:"Cancel", style: .destructive) { (action) in }
        let confirmButton = UIAlertAction(title: "Confirm", style: .default) { (action) in
            // HTTP Request
            let url = "http://18.219.112.140:8000/api/v1/leave/"
            
            let params: [String : Any] = [
                "group_id": self.groupId
            ]
            
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        if let data = value as? [String : Any] {
                            if(data["status"] as! String == "success") {
                                self.performSegue(withIdentifier: "rewindToChats", sender: self)
                            }
                        }

                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
        
        leaveGroupAlert.addAction(cancelButton)
        leaveGroupAlert.addAction(confirmButton)
        
        self.present(leaveGroupAlert, animated: true, completion: nil)
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
