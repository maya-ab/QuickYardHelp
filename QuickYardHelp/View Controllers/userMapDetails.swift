//
//  userMapDetails.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-06-28.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit

import Firebase
import FirebaseFirestore
import FirebaseAuth


class userMapDetails: UIViewController {
    //Displays information of service provider
    //User can request their service
    
    //ID of person recieving request (Service Provider)
    var userID = ""
    
    //ID of person who sent request (Self)
    var requesteeUserID = ""
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var doesHaveLawnMowerLabel: UILabel!
    @IBOutlet weak var doesHaveSnowShovel: UILabel!
    @IBOutlet weak var doesHaveLeafRake: UILabel!
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var acceptancePending: UILabel!
    

    override func viewDidLoad() {
        
        requestButton.layer.cornerRadius = requestButton.frame.size.height / 4

        super.viewDidLoad()
        doesHaveLawnMowerLabel.alpha  = 0
        doesHaveSnowShovel.alpha = 0
        doesHaveLeafRake.alpha = 0
        
        getUserInfo()
    }
    
    func getUserInfo() {
        //GET USER ID OF TAPPED MAP PIN
        //let ref = Auth.auth().
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userID).documentID

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
                    self.doesHaveLawnMowerLabel.alpha = 1
                }
                
                if (doesHaveSnowShovel) {
                    self.doesHaveSnowShovel.alpha = 1
                }
                
                if (doesHaveLeafRake) {
                    self.doesHaveLeafRake.alpha = 1
                }
                
            } else {
                print("Doc does not exist")
            }
        }
        
        print("Get user info worked")
    }
    
    @IBAction func requestButtonTapped(_ sender: Any) {
        requestButton.alpha = 0
       // acceptancePending.alpha = 1
     
        let db = Firestore.firestore()
        print(userID)
        let ref = db.collection("users").document(userID).documentID
        let userRef = db.collection("users").document(ref)
        
        let selfID = Auth.auth().currentUser?.uid ?? "nil"
        
        print(ref)
        print(userRef)
        
        userRef.setData(["waitingForResponse" : true], merge: true)
        userRef.setData(["customerID" : selfID], merge: true)

        //Show waiting page
        let waitingPage = storyboard?.instantiateViewController(identifier: "waitingVC") as? RequestLoadingViewController
        waitingPage?.serviceProviderID = self.userID
        view.window?.rootViewController = waitingPage
        view.window?.makeKeyAndVisible()
    }
    
    

    

}

