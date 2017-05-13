//
//  FeedVC.swift
//  Social
//
//  Created by KO TING on 13/5/2017.
//  Copyright © 2017年 EdUHK. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Filter: ID removed from keyChain - \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }

}
