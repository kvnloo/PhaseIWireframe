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
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        logInButton.backgroundColor = UIColor.WHITE
        logInButton.setTitleColor(UIColor.BLACK, for: .normal)
        demoToolsButton.backgroundColor = UIColor.WHITE
        demoToolsButton.setTitleColor(UIColor.BLACK, for: .normal)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
