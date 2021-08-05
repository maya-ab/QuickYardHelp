//
//  TypeOfUserViewController.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-06-04.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit

class TypeOfUserViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var typeofUserInfo: UISegmentedControl!
    
    @IBOutlet weak var reqServiceRect: UIImageView!
    @IBOutlet weak var provideServiceRect: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    
    @IBAction func typeOfUserSelector(_ sender: Any) {
        
        if typeofUserInfo.selectedSegmentIndex == 1 {
            //Provide a Service
            provideServiceRect.alpha = 1
            reqServiceRect.alpha = 0
            
        } else {
            //Require a Service
            provideServiceRect.alpha = 0
            reqServiceRect.alpha = 1
        }
        
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if typeofUserInfo.selectedSegmentIndex == 1 {
            
            //provides service
            // take to info page
            let serviceProviderInfo = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.serviceProviderInfoViewController) as? ServiceProviderInfoViewController
            
            view.window?.rootViewController = serviceProviderInfo
            
            view.window?.makeKeyAndVisible()
            
            
        } else {
            
            //customer
            //take straight to sign up page
            let signUpPage = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.signUpViewController) as? SignUpViewController
            
            view.window?.rootViewController = signUpPage
            view.window?.makeKeyAndVisible()
            
            //Set type of user
            signUpPage?.typeOfUserSelected = "serviceRequired"
            
            
        }
    }
    
}
