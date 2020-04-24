//
//  UsersCell.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/19/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var removeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
