//
//  CreateGroupViewController.swift
//  Syncopate
//
//  Created by Emily Ou on 4/19/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CreateGroupViewController: UIViewController, UITextViewDelegate {
    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dmButton: UIButton!
    var checked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Border around text view
        descriptionTextView.layer.borderWidth = 1
        if self.traitCollection.userInterfaceStyle == .dark {
            descriptionTextView.layer.borderColor = UIColor.white.cgColor
        } else {
            descriptionTextView.layer.borderColor = UIColor.black.cgColor
        }
        // Rounded corners
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 10.0
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        createGroup()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.descriptionTextView.endEditing(true)
        self.nameField.endEditing(true)
    }
 
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDMButton(_ sender: Any) {
        let toBeChecked = !checked
        
        if toBeChecked {
            self.setChecked(true)
        }
        else {
            self.setChecked(false)
        }
    }
    
    // set dm check
    func setChecked(_ isChecked: Bool) {
        checked = isChecked
        if checked {
            dmButton.setImage(UIImage(systemName: "checkmark.square"), for: UIControl.State.normal)
        } else {
            dmButton.setImage(UIImage(systemName: "square"), for: UIControl.State.normal)
        }
    }
    
    func createGroup() {
        // Create group endpoint
        let url = "http://18.219.112.140:8000/api/v1/create-group/"
        
        // Create group POST parameters
        let params: [String : Any] = [
            "name": nameField.text!,
            "description": descriptionTextView.text!,
            "dm": checked
        ]
        
        // HTTP Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        if (data["status"] as! String == "success") {
                            self.dismiss(animated: true, completion: nil)
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
