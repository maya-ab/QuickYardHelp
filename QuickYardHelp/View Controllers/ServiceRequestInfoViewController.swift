//
//  ServiceRequestInfoViewController.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-07-07.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ServiceRequestInfoViewController: UIViewController {
    
    var customerID = ""
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    override func viewDidLoad() {
        acceptButton.layer.cornerRadius = acceptButton.frame.size.height / 4
        
        declineButton.layer.cornerRadius = declineButton.frame.size.height / 5
        
        super.viewDidLoad()
        checkWhoSentRequest()
        
        
    }
    
    let db = Firestore.firestore()
    let ref = Auth.auth().currentUser?.uid ?? "nil"
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        
        //Create document that will contain any messages the two users exchange
        let messageDocument = db.collection("messages").addDocument(data: [ : ])
        let messageDocumentID = messageDocument.documentID
        messageDocument.collection("messageDocs").addDocument(data: [ : ])
        print(messageDocumentID)
        
        let path = "/messages/\(messageDocumentID)/messageDocs"
        print("Stored path")
        print(path)
        
       // Add docID to own data -> other user obtains
        db.collection("users").document(ref).setData(["waitingForResponse" : false, "didAccept": true, "isHere" : false, "path": path], merge: true)
        
        //Take them to progress page
        let workProgressVC = self.storyboard?.instantiateViewController(identifier: "workProgressVC") as? WorkProgressViewController
        workProgressVC?.customerID = customerID //Provide customer ID
        self.view.window?.rootViewController = workProgressVC
        self.view.window?.makeKeyAndVisible()
    }
    
    //Take user back home, dismiss request, tell requestee their request was declined
    @IBAction func declineButtonTapped(_ sender: Any) {
        db.collection("users").document(ref).setData(["waitingForResponse" : false, "didAccept": false], merge: true)
        returnHome()
    }
    
    func returnHome() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
    //Only if waitngForResponse is false // Listener or just when button pressed?
    func checkIfCancelled() {
        db.collection("users").document(ref).getDocument { (document, err) in
            
        }
    }
    
    //Checks who sent request and sets users data
    func checkWhoSentRequest() {
        //Check users data (self) who sent request
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? "nil"
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { (document, err) in
            if let document = document, document.exists {
                self.customerID = document.get("customerID") as! String
                self.nameLabel.text = document.get("firstname") as? String
                self.addressLabel.text = document.get("address") as? String
                self.phoneLabel.text = document.get("phonenumber") as? String
                
            } else {
                print("Doc does not exist")
            }

        }
    }
    
    
}
