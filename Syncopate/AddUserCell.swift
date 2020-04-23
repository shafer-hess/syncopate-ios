//
//  AddUserCell.swift
//  Syncopate
//
//  Created by Emily Ou on 4/23/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit

class AddUserCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    var checked: Bool = false
    var checkButtonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.checkButton.addTarget(self, action: #selector(onCheckButton(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onCheckButton(_ sender: Any) {
        checkButtonAction?()
    }
    
    // set dm check
    func setChecked(_ isChecked: Bool) {
        checked = isChecked
        if checked {
            print("Here")
            checkButton.setImage(UIImage(systemName: "checkmark.square"), for: UIControl.State.normal)
        } else {
            checkButton.setImage(UIImage(systemName: "square"), for: UIControl.State.normal)
        }
    }
}
