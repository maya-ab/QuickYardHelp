//
//  messageTableViewCell.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-07-29.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit

class messageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let height = messageBubble.frame.size.height
        
        messageBubble.layer.cornerRadius = height / 6
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
