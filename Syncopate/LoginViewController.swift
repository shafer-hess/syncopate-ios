//
//  LoginViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/2/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import Alamofire
import UIKit

class LoginViewController: UIViewController {
    // Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func onRegisterLabel(_ sender: Any) {
        self.performSegue(withIdentifier: "registerSegue", sender: self)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        // Create Empty Fields, Incorrect Password Alert Controller
        let emptyFields = UIAlertController(title: "Empty Fields", message: "Please enter both an email and a password.", preferredStyle: .alert)
        let incorrectPassword = UIAlertController(title: "Error", message: "Incorrect Password", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { (action) in }

        emptyFields.addAction(okButton)
        incorrectPassword.addAction(okButton)
        
        // Check if fields are empty
        if(emailField.text!.isEmpty || passwordField.text!.isEmpty) {
            present(emptyFields, animated: true)
        }
        
        // Create Login POST Parameters
        let login: [String : Any] = [
            "email": emailField.text!,
            "password": passwordField.text!,
            "persistent": true
        ]
        
        // Login Endpoint
        let url = "http://18.219.112.140:8000/api/v1/login/"
        
        // Login HTTP Request
        AF.request(url, method: .post, parameters: login, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        if(data["status"] as! String == "success") {
                            UserDefaults.standard.set(true, forKey: "loggedIn")
                            // TODO Perform Segue to Chats Page
                            
                        } else {
                            self.present(incorrectPassword, animated: true)
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
