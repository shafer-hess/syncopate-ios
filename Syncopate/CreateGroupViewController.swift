//
//  CreateGroupViewController.swift
//  Syncopate
//
//  Created by Emily Ou on 4/19/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController, UITextViewDelegate {
    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
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
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
