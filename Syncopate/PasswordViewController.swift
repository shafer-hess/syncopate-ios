//
//  PasswordViewController.swift
//  Syncopate
//
//  Created by Emily Ou on 4/14/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import Alamofire
import AlamofireImage
import UIKit

class PasswordViewController: UIViewController {
    // Outlets
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        // Create alert controllers for wrong password, mismatched new password, and empty fields, confirmation
        let emptyFields = UIAlertController(title: "Empty Fields", message: "Please make sure all fields are filled in.", preferredStyle: .alert)
        let wrongPassword = UIAlertController(title: "Wrong Password", message: "Your current password did not match with our records", preferredStyle: .alert)
        let notMatch = UIAlertController(title: "Passwords Do Not Match", message: "Please make sure your new password fields match", preferredStyle: .alert)
        let confirm = UIAlertController(title: "Confirm", message: "Are you sure you want to change your password?", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default) { (action) in }
        emptyFields.addAction(okButton)
        wrongPassword.addAction(okButton)
        notMatch.addAction(okButton)
 
        
        // If fields are empty
        if (oldPasswordField.text!.isEmpty || newPasswordField.text!.isEmpty || confirmField.text!.isEmpty) {
            present(emptyFields, animated: true)
        }
        
        // If new password fields do not match
        if (newPasswordField.text! != confirmField.text!) {
            present(notMatch, animated: true)
        }
        
        // Change Password Endpoint
        let url = "http://18.219.112.140:8000/api/v1/change-password/"
        
        // Change password POST parameters
        let change: [String : Any] = [
            "old_password": oldPasswordField.text!,
            "new_password": newPasswordField.text!,
            "new_password2": confirmField.text!
        ]
        
        AF.request(url, method: .post, parameters: change, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        if (data["status"] as! String == "success") {
                            self.oldPasswordField.text = nil
                            self.newPasswordField.text = nil
                            self.confirmField.text = nil
                            
                            // Alert controller to confirm change
                            let yesButton = UIAlertAction(title: "Yes", style: .default) { (action) in
                                self.dismiss(animated: true, completion: nil)
                            }
                            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { (action) in }
                            
                            confirm.addAction(cancelButton)
                            confirm.addAction(yesButton)
                            self.present(confirm, animated: true)
                        }
                        else {
                            self.present(wrongPassword, animated: true)
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
