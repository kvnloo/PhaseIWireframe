//
//  User.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/30/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import GoogleSignIn

/** This is a custom model that allows to store both a URL and a title for an audio clip.
 // TODO: create a mechanism to display and edit the name of the file.
 */
class APIManager: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
    var user: User?
    /// Notification to go back to `InitialViewController`.
    let initialNotification = Notification.Name("PresentInitialViewController")
    /// Notification to go to `DemoViewController`.
    let demoNotification    = Notification.Name("PresentDemoViewController")
    var vc: UIViewController!
    var ref: DatabaseReference = Database.database().reference()
    
    
    static let sharedInstance = APIManager()
    
    func createUser() {
        if let user = user, let uid = user.uid, let pw = user.pw {
            Auth.auth().createUser(withEmail: uid, password: pw) { (user, error) in
                if let error = error {
                    self.presentNotification(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
                    self.user = nil
                    return
                }
                self.presentNotification(title: "Account created successfully", message: "Now sign-in to use your account!", actionTitle: "Ok")
                self.user = nil
                NotificationCenter.default.post(name:self.initialNotification, object: nil)
            }
        }
        
    }
    
    func signIn() {
        if let user = user, let uid = user.uid, let pw = user.pw {
            Auth.auth().signIn(withEmail: uid, password: pw) { (user, error) in
                if let error = error {
                    self.presentNotification(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
                    self.user = nil
                    return
                }
                self.loadData()
                self.presentNotification(title: "Sign-in successful", message: "You may now continue using the application and your data will be saved online!", actionTitle: "Ok")
                NotificationCenter.default.post(name:self.demoNotification, object: nil)
            }
        }
    }
    
    func fbSignIn() {
        let loginManager = LoginManager()
        loginManager.logIn([.email], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                self.presentNotification(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
            case .cancelled:
                self.presentNotification(title: "User cancelled login.", message: "", actionTitle: "Ok")
            case .success( _, _, _):
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential) { (user, error) in
                    self.user = User(token: FBSDKAccessToken.current().tokenString)
                    self.presentNotification(title: "Sign-in successful", message: "You may now continue using the application and your data will be saved online!", actionTitle: "Ok")
                    NotificationCenter.default.post(name:self.demoNotification, object: nil)
                    self.loadData()
                }
                
            }
        }
    }
    
    func googleSignIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            APIManager.sharedInstance.presentNotification(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                APIManager.sharedInstance.presentNotification(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
                return
            }
            APIManager.sharedInstance.user = User(token: authentication.accessToken)
            APIManager.sharedInstance.presentNotification(title: "Sign-in successful", message: "You may now continue using the application and your data will be saved online!", actionTitle: "Ok")
            NotificationCenter.default.post(name:APIManager.sharedInstance.demoNotification, object: nil)
            self.loadData()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        vc.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        vc.dismiss(animated: true, completion: nil)
    }
    
    func saveData() {
        if let user = user, let data = user.data as NSArray? {
            let hash = String(describing: user.uid?.hashValue)
            self.ref.setValue(hash)
            self.ref.child(hash).setValue(data)
        }
    }
    
    func loadData() {
        if let user = user {
            let hash = String(describing: user.uid?.hashValue)
            self.ref.child(hash).observeSingleEvent(of: .value, with: { (snapshot) in
                user.data = snapshot.value as? NSArray as? [Float]
                return
            })
        }
    }
    
    public func logout() {
        user = nil
    }
    
    func presentNotification(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil))
        self.vc.present(alert, animated: true, completion: nil)
    }
}
