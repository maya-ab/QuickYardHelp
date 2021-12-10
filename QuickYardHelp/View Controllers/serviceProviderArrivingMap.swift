//
//  serviceProviderArrivingMap.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-07-20.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

import Firebase
import FirebaseFirestore
import FirebaseAuth

//Show user and service provider who is arriving
//Update as other user moves
//Set scale to show them both
class serviceProviderArrivingMap: UIViewController, MKMapViewDelegate {
    
    //Selected service provider
    var serviceProviderID = ""
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var chatButton: UIButton!
    
    
    
    var obtainedPath = ""
    
    @IBOutlet weak var progressLabel: UILabel!
    
    
    //Shows current user
    override func viewDidLoad() {
        mapView.delegate = self
        super.viewDidLoad()
        addOtherUser()
        updateProgressImage()

        // Do any additional setup after loading the view.
    }
    
    func addOtherUser() {
        let db = Firestore.firestore()
        
        db.collection("users").document(serviceProviderID).addSnapshotListener { (document, err) in
            if err != nil {
                print("Error getting documents")
            } else {
                if let coord = document?.get("coord") {
                    let point = coord as! GeoPoint
                    let lat = point.latitude
                    let lon = point.longitude
                    
                    let userAnnotation = MKPointAnnotation()
                    userAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    
                    self.obtainedPath = document?.get("path") as! String
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
    
    //Update location of user until they arive -> determined by updateProgressImage
    func updateOtherUsersLocation() {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(serviceProviderID)
        
        ref.addSnapshotListener { (documentSnapshot, err) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(err!)")
                return
            }
            
            
        }
    
    }
    
    
    //Check progress of user working
    func updateProgressImage() {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(serviceProviderID)
        
        ref.addSnapshotListener { (documentSnapshot, error) in
            
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            if document.get("isHere") == nil {
                return
            }
            
            let isUserHere = document.get("isHere") as! Bool
            
            if isUserHere {
                self.progressLabel.text = "The service provider has arrived"
                
            }
            
            if document.get("isDone") == nil {
                return
            }
            
            let isUserDone = document.get("isDone") as! Bool
            
            if isUserDone && isUserHere {
                self.progressLabel.text = "The service provider is done"
                self.chatButton.setTitle("Go Home", for: UIControl.State.normal)
            }
        
        }
    }
    

    @IBAction func chatButtonTapped(_ sender: Any) {
        
        print("service provider id")
        print(serviceProviderID)
        
        if chatButton.currentTitle == "Go Home" {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                          
                          self.view.window?.rootViewController = homeViewController
                          self.view.window?.makeKeyAndVisible()
            
        }
        
        
    }
    

    
}
