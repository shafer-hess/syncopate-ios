//
//  ChatDetailsViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/6/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit

class ChatDetailsViewController: UIViewController {
    // Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var groupNameButton: UIButton!
    @IBOutlet weak var groupDescButton: UIButton!
    @IBOutlet weak var pinSwitch: UISwitch!
    
    // Variables
    var groupId: Int!
    var group: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = group["group__name"] as! String
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
