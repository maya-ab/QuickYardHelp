//
//  SignUpViewController.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-06-04.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    //Sign up text fields
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //User info obtained elsewhere
    //Get type of user
    var typeOfUserSelected = "unfilled"
    var doesOwnSnowShovel = false
    var doesOwnLawnMower = false
    var doesOwnLeafRaker = false
    
    var uidSignUp = ""
    
    
    @IBOutlet weak var errorTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements() {
        // Hide error label
        errorTextField.alpha = 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func validateFields() -> String? {
        
        //Check that all fields are not empty
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill out all the fields"
        }
        
        //check password is valid, give error if invalid
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Make sure your password is 8 characters long, contains a number, and has aspecial character"
        }
        
        
        return nil
    }

    
    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateFields()  //Shows User if there is any errors in creating their account
        
        if error != nil {
            errorTextField.text = error!
            errorTextField.alpha = 1
            
        } else { //successful field entery case
            
            //Clean up enteries
            let firstName = self.firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = self.lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let phoneNum = self.phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let address = self.addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            

            
            
            //Using Firebase, create account
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //If there is an error
                if err != nil {
                    print(err as Any)
                    self.errorTextField.text = "Error creating user"
                    self.errorTextField.alpha = 1
                    
                } else { // Succesful creating user, store user data
                
                    // Access database
                    let db = Firestore.firestore()
                    self.uidSignUp = result!.user.uid
                                        
                    //Add user to database
                   // db.collection("users").document(self.uidSignUp).setData
                    
                    db.collection("users").document(self.uidSignUp).setData(["firstname":firstName, "lastname":lastName, "uid":self.uidSignUp, "phonenumber":phoneNum, "address":address, "typeofuser":self.typeOfUserSelected, "doesOwnSnowShovel":self.doesOwnSnowShovel, "doesOwnLawnMower":self.doesOwnLawnMower, "doesOwnLeafRaker": self.doesOwnLeafRaker, "waitingForResponse":false, "didAccept":false]) { (error) in
                        
                        self.transitionToHome()
                        
                        if error != nil { //There is an error adding user to database
                            self.errorTextField.text = "Error saving user data"
                            self.errorTextField.alpha = 1
                        }
                    }
                    
           
                    
                    
                    
                }
            }
        }
        
        
    }
    
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
       // homeViewController?.uid = self.userRef
        homeViewController?.uid = self.uidSignUp
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        self.errorTextField.text = "Signed Up"

    }
}
