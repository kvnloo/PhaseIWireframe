//
//  RoundedButton.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/24/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

class GeneralUITextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Do any additional setup after awakening
        self.backgroundColor       = UIColor.CHARCOAL
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: UIColor.CREME])
        self.textColor             = UIColor.WHITE
        self.font                  = UIFont.TEXTFIELD
        
    }

}
