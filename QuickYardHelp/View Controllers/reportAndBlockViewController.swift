//
//  reportAndBlockViewController.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-08-30.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class reportAndBlockViewController: UIViewController {
    
    var selectedUser = ""
    
    
    @IBOutlet weak var reportThisUserLabel: UILabel!
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var reportTextField: UITextField!
    
    @IBOutlet weak var blockButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportButton.layer.cornerRadius = reportButton.frame.size.height / 4
        
        blockButton.layer.cornerRadius = blockButton.frame.size.height / 4
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func reportButtonPressed(_ sender: Any) {

        let reportText = reportTextField.text
        let db = Firestore.firestore()
        let currentUserRef = Auth.auth().currentUser?.email
        
        db.collection("reports").addDocument(data: ["report" : reportText!, "from": currentUserRef!, "aboutUser": selectedUser])
        
        reportTextField.text = ""
        reportTextField.alpha = 0
        reportThisUserLabel.text = "Report Sent!"

        
    }
    
    @IBAction func blockButtonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        let ref = Auth.auth().currentUser?.uid ?? "nil"
        
        let blockedUsers = [selectedUser]
        
        db.collection("users").document(ref).setData(["block" : blockedUsers], merge: true)
        
        takeUserHome()

    }
    
    func takeUserHome() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
          self.view.window?.rootViewController = homeViewController
          self.view.window?.makeKeyAndVisible()
    }
    

}
