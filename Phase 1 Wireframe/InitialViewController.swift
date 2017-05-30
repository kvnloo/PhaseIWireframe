//
//  InitialViewController.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/25/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

/** Controls the initial view with which the user is presented.
    
    TODO: add in appdelegate to check if the user is signed in.
 */
class InitialViewController: GeneralUIViewController {

    // MARK: - IBOutlets
    
    /// A button for the user to create an account.
    @IBOutlet weak var createAccountButton: GeneralUIButton!
    /// A button for the user to login with existing credentails.
    @IBOutlet weak var logInButton: GeneralUIButton!
    /** A button to skip sign in and account creation to test the tools.
     
        - Note: this does not allow the user to save their preferences.
     */
    @IBOutlet weak var demoToolsButton: GeneralUIButton!
    /// An imageView that displays the company's logo.
    @IBOutlet weak var logoImageView: UIImageView!
    /// A label to display the company's name.
    @IBOutlet weak var logoLabel: GeneralUILabel!
    
    // MARK: - UIViewController
    
    /// Configure UIElements of the view. This sets the colors for the different buttons and the tint color for the ImageViews.
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
    
    /// Hides the navigation bar since it would look strange in the initial view with which the user is presented.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /// Reshow the navigation bar since it is an important part of other views.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
}
