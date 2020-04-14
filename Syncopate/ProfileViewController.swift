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

class ProfileViewController: UIViewController {
    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
    }
    
    @IBAction func onEditPicture(_ sender: Any) {
    
    }
    
    @IBAction func onChangePassword(_ sender: Any) {
        
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
