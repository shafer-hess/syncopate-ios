//
//  RegisterViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/2/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    // Outlets
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    // Register button is pressed
    @IBAction func onRegister(_ sender: Any) {
        // Create alert controllers for empty fields, already taken email, insufficient password or email
        let emptyFields = UIAlertController(title: "Empty Fields", message: "Please make sure all fields are filled in.", preferredStyle: .alert)
        let takenEmail = UIAlertController(title: "Email Already Exists", message: "This email is already taken.", preferredStyle: .alert)
        let insufficientPassword = UIAlertController(title: "Insufficient Password", message: "Please make sure your password is at least 8 characters in length", preferredStyle: .alert)
        let insufficientEmail = UIAlertController(title: "Insufficient Email", message: "Please use your Purdue email.", preferredStyle: .alert)
        let notMatch = UIAlertController(title: "Passwords Do Not Match", message: "Please make sure your passwords match.", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default) { (action) in }
        emptyFields.addAction(okButton)
        takenEmail.addAction(okButton)
        insufficientEmail.addAction(okButton)
        insufficientPassword.addAction(okButton)
        notMatch.addAction(okButton)
        
        // If fields are empty
        if (firstNameField.text!.isEmpty || lastNameField.text!.isEmpty || emailField.text!.isEmpty || passwordField.text!.isEmpty || confirmPasswordField.text!.isEmpty) {
            present(emptyFields, animated: true)
        }
        
        // If password is not 8 characters longs
        if (passwordField.text!.count < 8) {
            present(insufficientPassword, animated: true)
        }
        
        // If passwords do not match
        if (passwordField.text != confirmPasswordField.text) {
            present(notMatch, animated: true)
        }
        
        // If email does not end in @purdue.edu
        if (!emailField.text!.hasSuffix("@purdue.edu")) {
            present(insufficientEmail, animated: true)
        }
        
        // TODO: email already taken
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
