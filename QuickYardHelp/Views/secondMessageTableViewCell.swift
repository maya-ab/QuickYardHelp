//
//  secondMessageTableViewCell.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-08-12.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit

class secondMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
