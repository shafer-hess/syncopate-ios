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
    
    // closure properties
    var acceptButtonAction: (()->())?
    var denyButtonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.acceptButton.addTarget(self, action: #selector(onAcceptButton(_:)), for: .touchUpInside)
        self.denyButton.addTarget(self, action: #selector(onDenyButton(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onAcceptButton(_ sender: Any) {
        acceptButtonAction?()
    }
    
    @IBAction func onDenyButton(_ sender: Any) {
        denyButtonAction?()
    }
}
