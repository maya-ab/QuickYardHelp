//
//  WorkProgressViewController.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-07-20.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class WorkProgressViewController: UIViewController {
    
    var customerID = ""
    @IBOutlet weak var progressInfoImage: UIImageView!
    @IBOutlet weak var hereButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Tell customer they're here and change image
    @IBAction func hereButtonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? "nil"
        //let userRef = db.collection("users").document(userID)
        
        //Seting our own data that we're here
        db.collection("users").document(userID).setData(["isHere" : true])
        
        progressInfoImage.image = UIImage(named: "letCusomerKnowYoureDone")
        hereButton.setTitle("done", for: UIControl.State.normal)
        
        if hereButton.title(for: UIControl.State.normal) == "done" {
            db.collection("users").document(userID).setData(["isDone" : true], merge: true)
            
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
            
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
            
            
        }
    }
    
    @IBAction func chatButtonTapped(_ sender: Any) {

        let chatVC = self.storyboard?.instantiateViewController(identifier: "chatVC") as? chatViewController
        
        let currentUserRef = Auth.auth().currentUser?.uid ?? "nil"
        let db = Firestore.firestore()
        
        db.collection("users").document(currentUserRef).getDocument { (document, err) in
                     if let document = document, document.exists {
                    
                        let chatVC = self.storyboard?.instantiateViewController(identifier: "chatVC") as? chatViewController
                       let obtainedPath = document.get("path") as! String
                                                 
                        chatVC?.path = obtainedPath
                      //  self.present(chatVC!, animated: true, completion: nil)
                        self.view.window?.rootViewController = chatVC
                        self.view.window?.makeKeyAndVisible()
                       
                       
                     }
                     
                 }
            
    }
    

    

    
    
    
}
