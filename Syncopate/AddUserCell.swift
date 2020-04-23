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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
