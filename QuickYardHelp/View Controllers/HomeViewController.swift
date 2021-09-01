//
//  HomeViewController.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-06-04.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

import Firebase
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController, MKMapViewDelegate {
    
    //UID of current user
    var uid = ""
    var listOfBlockedUsers: Array<String> = []

    @IBOutlet weak var mapView: MKMapView!
    
    
    private let locationManager = CLLocationManager()
    let regionInMeters: Double = 800000
    
    
    override func viewDidLoad() {
        mapView.delegate = self
        super.viewDidLoad()
        checkLocationServices()
        showOtherUsers()

        checkIfServiceRequired()
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        
        }
        
        let longitude = locationManager.location?.coordinate.longitude
        let latitude = locationManager.location?.coordinate.latitude
        
        let db = Firestore.firestore()
        
        let ref = Auth.auth().currentUser?.uid ?? "nil"
        
        print(ref) //Creating user with only location??
        
        if longitude != nil {
            db.collection("users").document(ref).setData(["coord" : GeoPoint(latitude: latitude!, longitude: longitude!)], merge: true)
        }
        
       
        
    }
 
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
            
        } else {
            //Alert user to turn on
        }
    }
     
    //Checks that we have permission to access location
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            break
        case .denied:
            //Show alert showing how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //Show an alert
            break
        case .authorizedAlways:
            break
    
        }
    }
    
    //Access users from database
    func showOtherUsers() {
        print("going to show other users")
        let db = Firestore.firestore()
                
        db.collection("users").getDocuments { (querySnapShot, err) in
            if err != nil {
                print("Error getting documents")
            } else {
                //Add users to map
                for document in querySnapShot!.documents {
                    let userType = document.get("typeofuser")
                    let userID = document.documentID
                    
                    //Obtain coord from firebase
                    if let coord = document.get("coord") {
                        
                        let point = coord as! GeoPoint
                        let lat = point.latitude
                        let lon = point.longitude
                        print(lat, lon)
                        
                        //If coord exists add annotation
                        if lat == nil && lon == nil || userType == nil {
                            
                        } else {
                            self.addAnnotations(lat: lat, lon: lon, type: userType as! String, userID: userID)
                            
                            
                        }
                        
                        
                    }
                    
                }
                
                
            }
        }
    }
    
    
    
    
    //Adds annotations to map
    func addAnnotations(lat:Double, lon:Double, type:String, userID: String) {
        
        let userAnnotation = MKPointAnnotation()
        
        userAnnotation.title = type
        userAnnotation.subtitle = userID   //Want to hide this, make more private
        userAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        mapView.addAnnotation(userAnnotation)
        
    }
    
    //Set up custom design for map pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
        annotationView.markerTintColor = UIColor.clear
        annotationView.glyphTintColor = UIColor.clear
        
        annotationView.canShowCallout = false
        
        if annotation.title == "serviceProvider" {
            annotationView.image = UIImage(named: "serviceProviderIcon")
        } else {
            annotationView.image = UIImage(named: "serviceRequiredIcon")
        }
             
        return annotationView
    }
    
    //When annotation is shown after user has clicked on it
    // --> Show info if its a service provider
    // --> What to do if someone requires a service ??
    
    //Do not click on self -> Nil
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let selectedAnnotation = view.annotation
        let userID = selectedAnnotation?.subtitle
        
        
        let userDetailsViewController = storyboard?.instantiateViewController(identifier: "userMapDetialsVC") as! userMapDetails
        
        userDetailsViewController.userID = userID!!
        userDetailsViewController.requesteeUserID = Auth.auth().currentUser?.uid ?? "nil"
        
        present(userDetailsViewController, animated: true, completion: nil)
        
        
    }
    
   func checkIfServiceRequired() {
    print("checking if service is required")
        let db = Firestore.firestore()
        let ref = Auth.auth().currentUser?.uid ?? "nil"
        //print(db.collection("users").document(ref).documentID)
    print(ref)
    
        db.collection("users").document(ref).addSnapshotListener { (documentSnapshot, error) in
        guard let document = documentSnapshot else {
          print("Error fetching document: \(error!)")
          return
        }
        guard let data = document.data() else {
          print("Document data was empty.")
          return
        }
        
        if document.get("waitingForResponse") == nil {
            print("nil")
            return
        }
            
        let isServiceRequired = document.get("waitingForResponse") as! Bool
        
        print("isServiceRequired:")
        print(isServiceRequired)
            
        if isServiceRequired {
            print("service required")
            self.showRequest()
        }
    }
    
 }
    
    
    func showRequest() {
        let serviceRequiredInfoPage = storyboard?.instantiateViewController(identifier: "serviceRequestInfoVC") as? ServiceRequestInfoViewController
        
        view.window?.rootViewController = serviceRequiredInfoPage
        view.window?.makeKeyAndVisible()
    }
    
  
    @IBAction func accountButtonTapped(_ sender: Any) {
        let profilePage = storyboard?.instantiateViewController(identifier: "profileVC") as? ProfileViewController
        present(profilePage!, animated: true, completion: nil)
    }
    
 }

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //TO update user location
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // TODO
    }

}

