//
//  ChatDetailsViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/6/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import Alamofire
import UIKit

class ChatDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var groupNameButton: UIButton!
    @IBOutlet weak var groupDescButton: UIButton!
    @IBOutlet weak var leaveGroupButton: UIButton!
    @IBOutlet weak var pinSwitch: UISwitch!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var usersTableView: UITableView!
    
    // Variables
    var groupId: Int = -1
    var group: NSDictionary = [:]
    var users: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Change title of view controller
        self.title = group["group__name"] as? String
        
        // Set Users Array from Group
        users = group["users"] as! NSArray
        
        // Check if current user is owner
        if (group["user"] as? Int != group["group__owner"] as? Int) {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = self.deleteButton
        }
        
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
        
        // Set Delegates
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        // Other Table Settings
        usersTableView.alwaysBounceVertical = false
        usersTableView.estimatedRowHeight = 44
        usersTableView.rowHeight = 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTableView.dequeueReusableCell(withIdentifier: "UsersCell") as! UsersCell
        
        let user = users[indexPath.row] as! NSDictionary
        let first_name = user["user__first_name"] as! String
        let last_name = user["user__last_name"] as! String
        
        let name = first_name + " " + last_name
        cell.userLabel.text = name
        
        // Setup Remove Button
        cell.removeButton.tag = user["user__id"] as! Int
        cell.removeButton.addTarget(self, action: #selector(removeUser(sender:)), for: .touchUpInside)
        
        return cell
    }

    @IBAction func onDelete(_ sender: Any) {
        let delete = UIAlertController(title: "Delete Group", message: "Are you sure you want to delete this group?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in }
        let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
            // Delete Endpoint
            let url = "http://18.219.112.140:8000/api/v1/delete-group/"
            
            // POST parameters
            let params: [String : Any] = [
                "group_id": self.groupId,
                "deleted": true
            ]
            
            // HTTP Request
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        if let data = value as? [String : Any] {
                            if (data["status"] as! String == "success") {
                                 self.performSegue(withIdentifier: "rewindToChats", sender: self)
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
        delete.addAction(cancel)
        delete.addAction(yes)
        present(delete, animated: true)
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

    @objc func removeUser(sender: UIButton) {
        // Retrieve stored user info
        let userId: Int = sender.tag
        
        // Set up Alert Controller
        let removeUserAlert = UIAlertController(title: "Remove User?", message: "Are you sure that you want to remove this user from the group?", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "No", style: .destructive) { (action) in }
        let confirmButton = UIAlertAction(title: "Yes", style: .default) { (action) in
            // Perform HTTP Request
            let url = "http://18.219.112.140:8000/api/v1/boot/"
            
            // Request Parameters
            let params: [String : Any] = [
                "user_id": userId,
                "group_id": self.groupId
            ]
  
            // HTTP Request
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        if let data = value as? [String : Any] {
                            if(data["status"] as! String == "success") {
                                self.updateUserList()
                            }
                        }

                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
        
        // Present Alert
        removeUserAlert.addAction(cancelButton)
        removeUserAlert.addAction(confirmButton)
        self.present(removeUserAlert, animated: true, completion: nil)
    }
    
    func updateUserList() {
        // UserGroups Endpoint
        let url = "http://18.219.112.140:8000/api/v1/get-user-group/"
        
        // HTTP Request
        AF.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
        
            switch response.result {
                case .success(let value):
                    if let data = value as? NSArray {
                        for entry in data {
                            let group = entry as! NSDictionary
                            if(group["group__id"] as! Int == self.groupId) {
                                let users = group["users"] as! NSArray
                                
                                self.users = users
                                self.usersTableView.reloadData()
                                return
                            }
                        }
                    }
                    
                    // Fallback if request fails
                    self.performSegue(withIdentifier: "rewindToChats", sender: self)
                
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func editGroupImage(_ sender: Any) {
        // Set up image picker
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        // Select photo source
        let optionsAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        // Add actions to alert and present
        optionsAlert.addAction(camera)
        optionsAlert.addAction(library)
        optionsAlert.addAction(cancel)
        self.present(optionsAlert, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get Image
        let image = info[.editedImage] as! UIImage
        
        // Resize Image
        let size = CGSize(width: 100, height: 100)
        let scaledImage = image.af.imageAspectScaled(toFit: size)
        
        //Send Photo to Backend
        uploadGroupProfilePicture(picture: scaledImage)
        dismiss(animated: true, completion: nil)
    }
    
    func uploadGroupProfilePicture(picture: UIImage) {
        // Url of request
        let url = "http://18.219.112.140:8000/api/v1/group-avatar/"
        
        // Image data to send
        let imageData = picture.jpegData(compressionQuality: 1.0)
        
        // Add multipart form data upload
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "avatar", fileName: "temp", mimeType: "image/jpeg")
            multipartFormData.append("\(self.groupId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "group_id")
        }, to: url, method: .post).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        if (data["status"] as! String == "success") {
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "AddUsersSegue" {
            let info = groupId
            
            let addUsersViewController = segue.destination as! AddUserViewController
            addUsersViewController.id = info
        }
    }
}
