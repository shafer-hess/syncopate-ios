//
//  AddFriendCell.swift
//  Syncopate
//
//  Created by Emily Ou on 4/8/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit

class AddFriendCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    // add friend button closure property
    var addButtonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addButton.addTarget(self, action: #selector(onAddButton(_:)), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onAddButton(_ sender: UIButton) {
        addButtonAction?()
    }
}
