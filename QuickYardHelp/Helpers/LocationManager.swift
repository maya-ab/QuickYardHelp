//
//  LocationManager.swift
//  QuickYardHelp
//
//  Created by Maya Alejandra AB on 2021-06-10.
//  Copyright © 2021 QuickYardHelpOrg. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        
        //Takes a bit of time, sets desired accuracy for showing user location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //can change how big distance shown is
        locationManager.distanceFilter = kCLDistanceFilterNone
        //Or request when app is in use
        locationManager.requestAlwaysAuthorization()
        
        //Gives updated location
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.location = location
            
        }
    }
}
