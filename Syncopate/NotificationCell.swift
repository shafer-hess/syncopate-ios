//
//  NotificationCell.swift
//  Syncopate
//
//  Created by Emily Ou on 4/9/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onAcceptButton(_ sender: Any) {
    }
    
    @IBAction func onDenyButton(_ sender: Any) {
    }
}
