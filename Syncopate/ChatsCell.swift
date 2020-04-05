//
//  ChatsCell.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/5/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit

class ChatsCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var profileView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
