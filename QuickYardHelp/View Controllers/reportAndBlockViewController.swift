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
    let ref = Auth.auth().currentUser?.uid ?? "nil"
    let db = Firestore.firestore()
    
    var createNewBlockByList: [String] = []
    var createNewBlockList: [String] = []
    
    
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
    
    //Check if when there's no existing list, if we should add object as list or just a string
    
    @IBAction func blockButtonPressed(_ sender: Any) {
        let userToBlock = [selectedUser]
        //var doesHaveBlockedList = false
        print("selected user")
        print(selectedUser)
        
        //Add to selectedUsers "Blocked by list" which we create if doesnt exist
        db.collection("users").document(selectedUser).getDocument { (document, err) in
            
            if let document = document, document.exists {
                
                if let blockedByList = document.get("blockedby") as? Array<Any> {
                    print("Has a blocked by list")
                    var newBlockedByList = blockedByList
                    newBlockedByList.append(self.ref)
                    
                    self.db.collection("users").document(self.selectedUser).setData(["blockedBy" : newBlockedByList], merge: true)
                } else {
                    
                    self.createNewBlockByList.append(self.selectedUser)
                    print("making a blocked by list")
                    self.db.collection("users").document(self.selectedUser).setData(["blockedby" : self.createNewBlockByList], merge: true)
                }
                
            }
        }
        
        
        // Check if user has a list of blocked users
        db.collection("users").document(ref).getDocument { (document, err) in
            
            if let document = document, document.exists {
                
                //User has other people blocked, add selectedUser to list and add to database
                if let blockedList = document.get("block") as? Array<Any> {
                    print("blocked list exists")
                    var newBlockList = blockedList
                    newBlockList.append(self.selectedUser)
                    
                    self.db.collection("users").document(self.ref).setData(["block" : newBlockList], merge: true)
                    
                } else {
                //Create blocked list
                    self.createNewBlockList.append(self.ref)
                    print("blocked list doesn't exist")
                    self.db.collection("users").document(self.ref).setData(["block" : self.createNewBlockList], merge: true)
                }
                
            
            }
        }
        
        takeUserHome()

    }
    
    func takeUserHome() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
          self.view.window?.rootViewController = homeViewController
          self.view.window?.makeKeyAndVisible()
    }
    

}
