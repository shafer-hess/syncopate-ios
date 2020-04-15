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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
    }
    
    @IBAction func onEditPicture(_ sender: Any) {
        // Open photo library or camera
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
        
        // If chosen photo
            // Load photo to new view controller - give option to submit or cancel
            // If cancel - go back to camera or photo library
            // If accept - dismiss view controller, send photo to backend
    }
    
    @IBAction func onChangePassword(_ sender: Any) {
        //self.performSegue(withIdentifier: "passwordSegue", sender: self)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
