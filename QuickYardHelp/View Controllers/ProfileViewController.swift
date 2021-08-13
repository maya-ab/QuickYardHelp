//
//  ProfileViewController.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-07-07.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var snowShovelSwitch: UISwitch!
    @IBOutlet weak var lawnMowerSwitch: UISwitch!
    @IBOutlet weak var leafRakerSwitch: UISwitch!
    
    let db = Firestore.firestore()
    let ref = Auth.auth().currentUser?.uid ?? "nil"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()

        // Do any additional setup after loading the view.
    }
    
    func getUserInfo() {
        
        
        db.collection("users").document(ref).addSnapshotListener { (document, err) in
            if let document = document, document.exists {
                self.userNameLabel.text = document.get("firstname") as? String
                
                let doesHaveShovel = document.get("doesOwnSnowShovel") as! Bool
                print(doesHaveShovel)
                print(self.snowShovelSwitch.isOn)
                self.snowShovelSwitch.isOn = doesHaveShovel
                print(self.snowShovelSwitch.isOn)
                
                let doesHaveLawnMower = (document.get("doesOwnLawnMower") as? Bool)!
                self.lawnMowerSwitch.isOn = doesHaveLawnMower
                print(doesHaveLawnMower)
                
                let doesHaveLeafRaker = (document.get("doesOwnLeafRaker") as? Bool)!
                self.leafRakerSwitch.isOn = doesHaveLeafRaker
                print(doesHaveLeafRaker)
                
            } else {
                print("Doc does not exist")
            }
            
        }
    }
    
    @IBAction func snowShovelValueChanged(_ sender: Any) {
        db.collection("users").document(ref).setData(["doesOwnSnowShovel" : snowShovelSwitch.isOn], merge: true)
    }
    
    @IBAction func lawnMowerValueChanged(_ sender: Any) {
        db.collection("users").document(ref).setData(["doesOwnLawnMower" : lawnMowerSwitch.isOn], merge: true)
    }
    
    @IBAction func leafRakerValueChanged(_ sender: Any) {
        db.collection("users").document(ref).setData(["doesOwnLeafRaker" : leafRakerSwitch.isOn], merge: true)
    }
    
    @IBAction func loutOutButtonTapped(_ sender: Any) {
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            let loginVc = storyboard?.instantiateViewController(withIdentifier: "introVC") as? IntroViewController
            
            view.window?.rootViewController = loginVc
            view.window?.makeKeyAndVisible()
            //Take to log in page?
            //Add delete account option
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
