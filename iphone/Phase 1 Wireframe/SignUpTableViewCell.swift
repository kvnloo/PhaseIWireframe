//
//  SignUpTableViewCell.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/24/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

class SignUpTableViewCell: GeneralUITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var button: UIButton?
    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var textField: CustomUITextField?
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
