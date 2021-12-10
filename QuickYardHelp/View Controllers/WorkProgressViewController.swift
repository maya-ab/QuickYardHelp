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

import MapKit
import CoreLocation

class WorkProgressViewController: UIViewController, MKMapViewDelegate {
    
    var customerID = ""
    var obtainedPath = ""
    
    @IBOutlet weak var backgroundColour: UIView!
    
    @IBOutlet weak var hereButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    

    override func viewDidLoad() {
        mapView.delegate = self
        super.viewDidLoad()
        addOtherUser()

        // Do any additional setup after loading the view.
    }
    
    //Get home location-> stationary 
    func addOtherUser() {
        let db = Firestore.firestore()
        
        db.collection("users").document(customerID).addSnapshotListener { (document, err) in
            if err != nil {
                print("Error getting documents")
            } else {
                if let coord = document?.get("coord") {
                    let point = coord as! GeoPoint
                    let lat = point.latitude
                    let lon = point.longitude
                    
                    let userAnnotation = MKPointAnnotation()
                    userAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    //Get path for messaging ?
                    //self.obtainedPath = document?.get("path") as! String
                    print("going to add other user")
                    
                    
                    self.mapView.addAnnotation(userAnnotation)
                
                    
                }
            }
        }
        
    }
    
    //Set up custom design for map pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
        annotationView.markerTintColor = UIColor.clear
        annotationView.glyphTintColor = UIColor.clear
        
        annotationView.canShowCallout = false
        annotationView.subtitleVisibility = MKFeatureVisibility.hidden
        annotationView.titleVisibility = MKFeatureVisibility.hidden
        annotationView.image = UIImage(named: "serviceProviderIcon")

        return annotationView
    }
    
    //Tell customer they're here and change image
    @IBAction func hereButtonPressed(_ sender: Any) {
        
        print("clicked here")
        
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? "nil"
        //let userRef = db.collection("users").document(userID)
        
        //User arrived, let customer know and wait to see if they are done
    
        if hereButton.currentTitle == "Here"{
             print("setting here settings")
            db.collection("users").document(userID).setData(["isHere" : true, "isDone" : false], merge: true)
            backgroundColour.backgroundColor = UIColor(named: "brandGreen")
            hereButton.setTitle("Done", for: UIControl.State.normal)
            
            instructionsLabel.text = "Let the customer know when you are done by clicking the button below. You can also chat with the customer"
            
        } else {
            print("setting done settings")
            db.collection("users").document(userID).setData(["isDone" : true], merge: true)
            
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
        // Reset settings for next job
        db.collection("users").document(userID).setData(["isHere" : false], merge: true)
            
        }
        
    }
    
    @IBAction func chatButtonTapped(_ sender: Any) {

       // let chatVC = self.storyboard?.instantiateViewController(identifier: "chatVC") as? chatViewController
        
        let currentUserRef = Auth.auth().currentUser?.uid ?? "nil"
        let db = Firestore.firestore()
        
        db.collection("users").document(currentUserRef).getDocument { (document, err) in
                     if let document = document, document.exists {
                    
                      //  let chatVC = self.storyboard?.instantiateViewController(identifier: "chatVC") as? chatViewController
                       //let obtainedPath = document.get("path") as! String
                                                 
                        //chatVC?.path = obtainedPath
                      //  self.present(chatVC!, animated: true, completion: nil)
                     //   self.view.window?.rootViewController = chatVC
                      //  self.view.window?.makeKeyAndVisible()
                       
                       
                     }
                     
                 }
            
    }
    

    

    
    
    
}
