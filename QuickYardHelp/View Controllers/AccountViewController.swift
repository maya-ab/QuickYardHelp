//
//  AccountViewController.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-06-04.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class AccountViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lawnMowerLabel: UIView!
    @IBOutlet weak var snowShovelLabel: UILabel!
    @IBOutlet weak var leafRakeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lawnMowerLabel.alpha = 0
        snowShovelLabel.alpha = 0
        leafRakeLabel.alpha = 0

        getUserInfo()
    }
    
    func getUserInfo() {
        
        let ref = Auth.auth().currentUser?.uid ?? "nil"
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(ref)
        
        userRef.getDocument { (document, err) in
            if let document = document, document.exists {
                let firstName = document.get("firstname") as! String
                let lastName = document.get("lastname") as! String
                let fullName = firstName + " " + lastName
                
                let doesHaveLawnMower = document.get("doesOwnLawnMower") as! Bool
                let doesHaveSnowShovel = document.get("doesOwnSnowShovel") as! Bool
                let doesHaveLeafRake = document.get("doesOwnLeafRaker") as! Bool
                
                self.userNameLabel.text = fullName
                
                if (doesHaveLawnMower) {
                    self.lawnMowerLabel.alpha = 1
                }
                
                if (doesHaveSnowShovel) {
                    self.snowShovelLabel.alpha = 1
                }
                
                if (doesHaveLeafRake) {
                    self.leafRakeLabel.alpha = 1
                }

             

            } else {
                print("Doc does not exist")
            }
        }
    }
}
