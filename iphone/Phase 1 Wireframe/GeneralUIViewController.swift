//
//  GeneralViewController.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/25/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

class GeneralUIViewController: UIViewController {

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.BACKGROUND
        self.navigationController?.navigationBar.setBottomBorderColor(color: UIColor.CREME, height: 0.25)
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
