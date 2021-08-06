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
    @IBOutlet weak var progressImage: UIImageView!
    
    var obtainedPath = ""
    
    
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
                    
                    self.mapView.addAnnotation(userAnnotation)
                }
            }
        }
        
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
                self.progressImage.image = UIImage(named: "serviceProviderWorking")
            }
            
            if document.get("isDone") == nil {
                return
            }
            
            let isUserDone = document.get("isDone") as! Bool
            
            if isUserDone {
                self.progressImage.image = UIImage(named: "serviceProviderDone")
            }
        
        }
    }


    @IBAction func chatButtonTapped(_ sender: Any) {
        
        let db = Firestore.firestore()
        
        print("service provider id")
        print(serviceProviderID)
    

        
        let chatVC = self.storyboard?.instantiateViewController(identifier: "chatVC") as? chatViewController
        chatVC?.path = self.obtainedPath
        self.view.window?.rootViewController = chatVC
        
        self.view.window?.makeKeyAndVisible()
    }
    
}
