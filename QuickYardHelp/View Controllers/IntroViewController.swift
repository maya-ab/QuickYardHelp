//
//  IntroViewController.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-06-04.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class IntroViewController: UIViewController {

    
    @IBOutlet weak var errorSigningIn: UILabel!
    
    @IBOutlet weak var logInEmailTextField: UITextField!
    
    @IBOutlet weak var logInPassword: UITextField!
    
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var signUpOneButton: UIButton!
    
    @IBOutlet weak var tryAgainLabel: UILabel!
    
    override func viewDidLoad() {
        
        
         logInButton.layer.cornerRadius = logInButton.frame.size.height / 5
        
         signUpOneButton.layer.cornerRadius = signUpOneButton.frame.size.height / 5
        
        
        super.viewDidLoad()

        setUpElements()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CheckLoggedIn()
    }
    
    
    
    func CheckLoggedIn() {
        if Auth.auth().currentUser != nil {
            print("yes ")
            self.openHome()
        } else {
            
            print("not ")
          // No user is signed in.
          // ...
        }
        
    }

    
    func setUpElements() {
        tryAgainLabel.alpha = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logInButtonTapped(_ sender: Any) {
        
        //Validate Text Fields
        
        
        
        //Clean them up
        let email = logInEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let password = logInPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                //could not sign in
                self.errorSigningIn.alpha = 1
                
                //let alert = UIAlertController(title: "Service Request!", message: "D", preferredStyle: <#T##UIAlertController.Style#>)
                //alert.title = "Alert"
                //alert.message = "Here's a message"
                //self.present(alert, animated: true, completion: nil)
                
            } else {
                self.openHome()
                
                
            }
        }
      
        
    }
    
    func openHome() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    
    
   
    
    @IBAction func signUpOneTapped(_ sender: Any) {
    }
    
}
