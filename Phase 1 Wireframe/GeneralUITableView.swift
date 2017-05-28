//
//  GeneralUITableView.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/25/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

class GeneralUITableView: UITableView {

    // MARK: - UITableView
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Do any additional setup after awakening
        self.separatorStyle     = .none
        self.estimatedRowHeight = 200
        self.allowsSelection    = false
        self.backgroundColor    = UIColor.BACKGROUND
    }

}
