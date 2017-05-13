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

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: ColorTextField!
    @IBOutlet weak var pwdField: ColorTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            }
        })
    }
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: "email", password: "pwd", completion: { (user, error) in
                if error == nil {
                    print("Filter: Email User is authenticated with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Filter: Unable to authenicate with Firebase with email")
                        } else {
                            print("Filter: Successfully authenticated with Firebase")
                        }
                    })
                }
            })
        }
        
    }
    
}

