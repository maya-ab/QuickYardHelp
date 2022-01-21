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
    
    var isBlocked = true
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var doesHaveLawnMowerLabel: UILabel!
    @IBOutlet weak var doesHaveSnowShovel: UILabel!
    @IBOutlet weak var doesHaveLeafRake: UILabel!
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var reportButtonUI: UIButton!
    
    @IBOutlet weak var lawnMowerCheckMark: UIImageView!
    @IBOutlet weak var snowRemovalCheckMark: UIImageView!
    @IBOutlet weak var leafRakeCheckMark: UIImageView!
    
    
    @IBOutlet weak var profileBackgroundImage: UIImageView!
    
    @IBOutlet weak var servicesAvailableLabel: UILabel!
    
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        print("checking if blocked")
        showUserDisplay()
        checkIfBlocked()
        super.viewDidLoad()
        
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
                let typeOfUser = document.get("typeofuser") as! String
                
                let doesHaveLawnMower = document.get("doesOwnLawnMower") as! Bool
                let doesHaveSnowShovel = document.get("doesOwnSnowShovel") as! Bool
                let doesHaveLeafRake = document.get("doesOwnLeafRaker") as! Bool
                
                self.userNameLabel.text = fullName
                
                if (doesHaveLawnMower) {
                    self.lawnMowerCheckMark.alpha = 1
                }
                
                if (doesHaveSnowShovel) {
                    self.snowRemovalCheckMark.alpha = 1
                }
                
                if (doesHaveLeafRake) {
                    self.leafRakeCheckMark.alpha = 1
                }
                
                if typeOfUser == "serviceRequired" {
                    self.requiresServiceDisplay()
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
        
        userRef.setData(["customerID" : selfID, "waitingForResponse" : true], merge: true)
       // userRef.setData(["customerID" : selfID], merge: true)

        //Show waiting page
        let waitingPage = storyboard?.instantiateViewController(identifier: "waitingVC") as? RequestLoadingViewController
        waitingPage?.serviceProviderID = self.userID
        
        view.window?.rootViewController = waitingPage
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func reportButton(_ sender: Any) {
        
        let reportPage = storyboard?.instantiateViewController(identifier: "reportBlockVC") as? reportAndBlockViewController
        
        reportPage?.selectedUser = userID
        present(reportPage!, animated: true, completion: nil)
                                
        
    }
    
    //1. Check if we blocked them
    //2. Check if they blocked us!
    func checkIfBlocked() {
        print("checking if blocked")
        let db = Firestore.firestore()
        let ref = requesteeUserID
        
        db.collection("users").document(ref).getDocument { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            
            //Block list doesn't exist
            if documentSnapshot?.get("block") == nil {
                print("blocked list empty")
                DispatchQueue.main.async {
                    self.isBlocked = false
                    //self.showUserDisplay()
                }
                self.checkIfTheyBlockedUs()
                return
        
            } else {
                // Has blocked list
                let listOfBlocked = document.get("block") as! Array<String>
                print("checking if on block list")
                let max = listOfBlocked.count
                var currentItem = -1
                
                
                for String in listOfBlocked {
                    currentItem = currentItem + 1
                    if String == self.userID {
            
                        DispatchQueue.main.async {
                             self.isBlocked = true
                            self.blockUserDisplay()
                        }
                    }
                    
                    if max == currentItem && self.isBlocked == false {
                        self.checkIfTheyBlockedUs()
                        //self.showUserDisplay()
                    }
                }
            }
        }
    }
    
    func checkIfTheyBlockedUs() {
        let db = Firestore.firestore()
        let ref = requesteeUserID
        
        db.collection("users").document(ref).getDocument { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            
            //BlockedBy list doesn't exist
            if documentSnapshot?.get("blockedby") == nil {
                print("blockedby list empty")
                DispatchQueue.main.async {
                    self.isBlocked = false
                    self.showUserDisplay()
                }
                return
                
            } else {
                // Has blockedBy list
                let listOfBlocked = document.get("blockedby") as! Array<String>
                print("checking if on blockby list")
                let max = listOfBlocked.count
                var currentItem = -1
                
                for String in listOfBlocked {
                    currentItem = currentItem + 1
                    if String == self.requesteeUserID {
                        DispatchQueue.main.async {
                             self.isBlocked = true
                            self.blockUserDisplay()
                        }
                    }
                    
                    if max == currentItem && self.isBlocked == false {
                        self.checkIfTheyBlockedUs()
                        self.showUserDisplay()
                    }
                }
            }
        }
        
        
    }
    
    func blockUserDisplay() {
        self.requestButton.alpha = 0
        self.reportButtonUI.alpha = 0
        
        self.leafRakeCheckMark.alpha = 0
        self.lawnMowerCheckMark.alpha = 0
        self.snowRemovalCheckMark.alpha = 0
        
        self.userNameLabel.text = "Blocked"
        self.userNameLabel.textColor = UIColor(named: "redColour")
        self.profileBackgroundImage.alpha = 0
    
    }
    
    func showUserDisplay() {
        
        requestButton.layer.cornerRadius = requestButton.frame.size.height / 4

        
        lawnMowerCheckMark.alpha  = 0
        snowRemovalCheckMark.alpha = 0
        leafRakeCheckMark.alpha = 0
        
        getUserInfo()
    }
    
    func requiresServiceDisplay() {
        profileBackgroundImage.image = UIImage(named: "greenRect")
        
        
        
        
        servicesAvailableLabel.text = "Looking For Yard Help"
        requestButton.alpha = 0
        requestButton.isEnabled = false
        
        lawnMowerCheckMark.alpha  = 0
        snowRemovalCheckMark.alpha = 0
        leafRakeCheckMark.alpha = 0
        
        doesHaveLawnMowerLabel.alpha = 0
        doesHaveSnowShovel.alpha = 0
        doesHaveLeafRake.alpha = 0
        
    
    }

}

