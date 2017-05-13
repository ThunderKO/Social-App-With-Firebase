//
//  SignInVC.swift
//  Social
//
//  Created by KO TING on 13/5/2017.
//  Copyright © 2017年 EdUHK. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: ColorTextField!
    @IBOutlet weak var pwdField: ColorTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("Filter: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func facebookBtnTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Filter: Unable to authenticate with Facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("Filter: User cancelled Facebook Authentication")
            } else {
                print("Filter: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Filter: Unable to authenticate with Facebook - \(String(describing: error))")
            } else {
                print("Filter: Successfully authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: "email", password: "pwd", completion: { (user, error) in
                if error == nil {
                    print("Filter: Email User is authenticated with Firebase")
                    if let user = user {
                        self.completeSignIn(id: (user.uid))
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Filter: Unable to authenicate with Firebase with email")
                        } else {
                            print("Filter: Successfully authenticated with Firebase")
                            if let user = user {
                                self.completeSignIn(id: (user.uid))
                            }
                        }
                    })
                }
            })
        }
        
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Filter: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

