//
//  InitialViewController.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/25/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

class InitialViewController: GeneralUIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var createAccountButton: GeneralUIButton!
    @IBOutlet weak var logInButton: GeneralUIButton!
    @IBOutlet weak var demoToolsButton: GeneralUIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoLabel: GeneralUILabel!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        logInButton.setTitleColor(UIColor.BLACK, for: .normal)
        demoToolsButton.setTitleColor(UIColor.BLACK, for: .normal)
        logInButton.backgroundColor     = UIColor.WHITE
        demoToolsButton.backgroundColor = UIColor.WHITE
        logoImageView.tintColor         = UIColor.CREME
        logoLabel.font                  = UIFont.LOGO
        logoLabel.textColor             = UIColor.CREME
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
}
