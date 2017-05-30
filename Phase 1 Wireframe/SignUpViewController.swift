//
//  SignUpViewController.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/24/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

/** This `GeneralUIViewController` controls the sign up view. It allows the user to create an account through Facebook, Google, E-mail, or Phone.
 
 TODO: configure firebase backend system. Create an api-manager to control https requests. input validation for email/phone number.
 
 */
class SignUpViewController: GeneralUIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    
    /// This table view sets up simple scrolling and reusable cells to simplify view layouts. This solution is more elegant than implementing a scroll view.
    @IBOutlet weak var signUpTableView: GeneralUITableView!
    
    // MARK: - UIViewController
    
    /// Setup the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UITableViewDataSource
    
    /// Returns the number of sections in this tableView.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Returns the height of a given cell based on indexPath.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return 42
        default:
            return 66
        }
    }
    
    /// Returns the number of rows in this tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    /// Returns the cell using a reusable identifier based on the indexPath.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SignUpTableViewCell
        switch indexPath.row {
        case 0:
            cell                          = signUpTableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! SignUpTableViewCell
            cell.button?.backgroundColor  = UIColor.FB_BLUE
            cell.button?.setTitle("SIGN UP WITH FACEBOOK", for: .normal)
            
        case 1:
            cell                          = signUpTableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! SignUpTableViewCell
            cell.button?.backgroundColor  = UIColor.GOOGLE_RED
            cell.button?.setTitle("SIGN UP WITH GOOGLE", for: .normal)
            
        case 2:
            cell             = signUpTableView.dequeueReusableCell(withIdentifier: "LabelCell") as! SignUpTableViewCell
            cell.label?.text = "or with e-mail / phone number"
            
        case 3:
            cell                        = signUpTableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! SignUpTableViewCell
            cell.textField?.leftImage   = UIImage(named: "ic_email_phone_white")
            cell.textField?.imageWidth  = 44
            cell.textField?.leftPadding = 10
            cell.textField?.placeholder = "E-mail Address or Phone Number"
            cell.textField?.text        = ""

            
        case 4:
            cell                        = signUpTableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! SignUpTableViewCell
            cell.textField?.leftImage   = UIImage(named: "ic_lock_white")
            cell.textField?.imageWidth  = 44
            cell.textField?.leftPadding = 10
            cell.textField?.placeholder = "Password"
            cell.textField?.text        = ""
            
            
        case 5:
            cell                          = signUpTableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! SignUpTableViewCell
            cell.button?.setTitle("SIGN UP", for: .normal)
        case 6:
            cell             = signUpTableView.dequeueReusableCell(withIdentifier: "LabelCell") as! SignUpTableViewCell
            cell.label?.text = "By signing up, you agree to JubiAudio's Terms and conditions of Use and Privacy Policy"
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    /// Unselects a row after it is selected by the user. This tableview does not need selection.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
