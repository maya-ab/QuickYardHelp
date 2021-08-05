//
//  ServiceProviderInfoViewController.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-06-04.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit

class ServiceProviderInfoViewController: UIViewController {

    
    @IBOutlet weak var nextButtonServiceInfo: UIButton!
    
    @IBOutlet weak var snowShovelSwitchInfo: UISwitch!
    @IBOutlet weak var lawnMowerSwitchInfo: UISwitch!
    @IBOutlet weak var leafRakerSwitchInfo: UISwitch!
    
    
    @IBOutlet weak var serviceUserError: UILabel!
    
    func isOneSwitchOn() -> Bool {
        if snowShovelSwitchInfo.isOn || lawnMowerSwitchInfo.isOn || leafRakerSwitchInfo.isOn  {
            return true
        }
        return false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButtonServiceInfo.isEnabled = true

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func nextButtonServiceInfoTapped(_ sender: Any) {
        
        //customer
        //take straight to sign up page
        let signUpPage = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.signUpViewController) as? SignUpViewController
        
        view.window?.rootViewController = signUpPage
        view.window?.makeKeyAndVisible()
        
        
        //Set type of user based on switches
        signUpPage?.typeOfUserSelected = "serviceProvider"
        signUpPage?.doesOwnSnowShovel = snowShovelSwitchInfo.isOn
        signUpPage?.doesOwnLawnMower = lawnMowerSwitchInfo.isOn
        signUpPage?.doesOwnLeafRaker = leafRakerSwitchInfo.isOn
        
        
        
        
    }
    
    @IBAction func snowShovelSwitch(_ sender: Any) {
        checkIfButtonShouldWork()
    }
    
    @IBAction func lawnMowerSwitch(_ sender: Any) {
       checkIfButtonShouldWork()
    }
    
    @IBAction func leafRakerSwitch(_ sender: Any) {
      checkIfButtonShouldWork()
    }
    
    func checkIfButtonShouldWork() {
        if isOneSwitchOn() {
            nextButtonServiceInfo.isEnabled = true
            serviceUserError.alpha = 0
        } else {
            nextButtonServiceInfo.isEnabled = false
            serviceUserError.alpha = 1
            
        }
    }
    
    
    
    

    
}
