//
//  SignUpViewController.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/24/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

class SignUpViewController: GeneralUIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet weak var signUpTableView: GeneralUITableView!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return 42
        default:
            return 66
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
