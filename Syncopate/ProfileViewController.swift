//
//  ProfileViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/7/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserInfo()
    }
    
    @IBAction func onEditPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // Alert controller to choose photo library or camera
        let options = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        options.addAction(camera)
        options.addAction(library)
        options.addAction(cancel)
        present(options, animated: true)
        
    }
    
    @IBAction func onToggle(_ sender: Any) {
        var available: Bool = false
        if statusSwitch.isOn {
            available = true
        } else {
            available = false
        }
        
        // Set status enpoint
        let url = "http://18.219.112.140:8000/api/v1/set-availability/"
        
        // POST parameter
        let status: [String : Any] = [
            "available": available
        ]
        
        // HTTP Request
        AF.request(url, method: .post, parameters: status, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        if(data["status"] as! String == "success") {
                            break
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func getUserInfo() {
        // user info endpoint
        let url = "http://18.219.112.140:8000/api/v1/identify/"

        // HTTP Request
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        // Get name
                        let first_name = data["first_name"] as? String
                        let last_name = data["last_name"] as? String
                        let full_name = first_name! + " " + last_name!
                        self.nameLabel.text = full_name
                        
                        // Get email and profile pic
                        self.emailLabel.text = data["email"] as? String
                        let picURL = (data["profile_pic_url"] as? String)!
                        let imageURL = URL(string: picURL)!
                        self.profileImage.af.setImage(withURL: imageURL)
                        
                        // Get status state and set switch
                        if (data["available"] as? Bool == true) {
                            self.statusSwitch.setOn(true, animated: true)
                        } else {
                            self.statusSwitch.setOn(false, animated: true)
                        }
                        
                        // Make the profile pic circular
                        self.profileImage.layer.masksToBounds = false
                        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
                        self.profileImage.clipsToBounds = true
                    }
                
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage

        // Resize
        let size = CGSize(width: 100, height: 100)
        let scaledImage = image.af.imageAspectScaled(toFit: size)
        
        // upload to backend
        uploadProfilePicture(picture: scaledImage)
        dismiss(animated: true, completion: nil)
    }
    
    func uploadProfilePicture(picture: UIImage) {
        // Upload profile picture endpoint
        let url = "http://18.219.112.140:8000/api/v1/upload-avatar/"
        let imageData = picture.jpegData(compressionQuality: 1.0)

        // HTTP Request
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "avatar", fileName: "temp", mimeType: "image/jpeg")}, to: url, method: .post).responseJSON { (response) in
                 switch response.result {
                        case .success(let value):
                            if let data = value as? [String : Any] {
                                if (data["status"] as! String == "success") {
                                    self.profileImage.image = picture
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
