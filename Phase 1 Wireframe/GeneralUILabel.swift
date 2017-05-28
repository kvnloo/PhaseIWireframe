//
//  GeneralUILabel.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/25/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

class GeneralUILabel: UILabel {

    // MARK: - UILabel
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Do any additional setup after awakening
        self.textColor = UIColor.WHITE
        self.font      = UIFont.LABEL
    }

}
