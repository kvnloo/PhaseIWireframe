//
//  RoundedButton.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/24/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

class GeneralUIButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Do any additional setup after awakening
        self.clipsToBounds         = true
        self.layer.cornerRadius    = 20.0
        self.titleLabel?.font      = UIFont.BUTTON
        self.backgroundColor       = UIColor.BLUE
        self.setTitleColor(UIColor.WHITE, for: .normal)
    }

}
