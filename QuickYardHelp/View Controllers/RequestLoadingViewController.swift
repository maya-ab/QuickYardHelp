//
//  RequestLoadingViewController.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-07-07.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class RequestLoadingViewController: UIViewController {
    
    //Other - not self
    var serviceProviderID = ""
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stopButtonLabel: UIButton!
    
    @IBOutlet weak var usersChoice: UILabel!
    @IBOutlet weak var confirmRequestButton: UIButton!
    
    
    
    override func viewDidLoad() {
        roundCorners()
        confirmRequestButton.alpha = 0
        confirmRequestButton.isEnabled = false
        super.viewDidLoad()
        checkIfUserResponded()
        
    }
    
    func roundCorners() {
        stopButtonLabel.layer.cornerRadius = stopButtonLabel.frame.size.height / 4
        
        confirmRequestButton.layer.cornerRadius = confirmRequestButton.frame.size.height / 4
        
    }
    func gotResponse() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.stopAnimating()
        
    }
    
    func checkIfUserResponded() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(serviceProviderID)
        let currentUserRef = Auth.auth().currentUser?.uid ?? "nil"
        
        //Check if service provider gave a response
        userRef.addSnapshotListener { [self] (documentSnapshot, error) in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            
            if document.get("didAccept") == nil {
                return
            }
            let didAccept = document.get("didAccept") as! Bool
            let waitingForResponse = document.get("waitingForResponse") as! Bool
            
            if waitingForResponse {
                //Still waiting for user to repond
                return
                
                //User responded
            } else if waitingForResponse == false {
                if didAccept {
                    //Request was accepted -- 
                    self.usersChoice.text = "Request Accepted!"
                    self.confirmRequestButton.alpha = 1
                    self.confirmRequestButton.isEnabled = true
                    
                    self.stopButtonLabel.alpha = 0
                    self.stopButtonLabel.isEnabled = false
                    
                    //Store mesage document ID in other user as well
                    let messageDocId = document.get("path") as! String
                    db.collection("users").document(currentUserRef).setData(["path" : messageDocId], merge: true)
                    
                    
                    self.gotResponse()
                    
                    
    
                } else if didAccept == false {
                    self.usersChoice.alpha = 1
                    self.usersChoice.text = "Request Declined"
                    self.gotResponse()
                    
                    self.stopButtonLabel.setTitle("Go Home", for: UIControl.State.normal)
                }
            }
            
        }
        
    }
    
    //Take them back home/Offer was declined
    // Can stop request until other user accepts 
    @IBAction func stopRequestTapped(_ sender: Any) {
        let buttonTitle = self.stopButtonLabel.title(for: UIControl.State.normal)
        
        if buttonTitle == "Stop Request" {
            let db = Firestore.firestore()
            //Let user know request was stopped
            db.collection("users").document(serviceProviderID).setData(["didStopRequest" : true], merge: true)
            
            takeUserHome()
            
        } else {

            takeUserHome()
            
        }
        
    }
    
    @IBAction func confirmRequestTapped(_ sender: Any) {
        let serviceProviderArrivingViewController = self.storyboard?.instantiateViewController(identifier: "serviceProviderArrivingVC") as? serviceProviderArrivingMap
        serviceProviderArrivingViewController?.serviceProviderID = self.serviceProviderID
        
        self.view.window?.rootViewController = serviceProviderArrivingViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
    func takeUserHome() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
          self.view.window?.rootViewController = homeViewController
          self.view.window?.makeKeyAndVisible()
    }
    
}
