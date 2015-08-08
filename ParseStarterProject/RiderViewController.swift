//
//  RiderViewController.swift
//  ParseStarterProject
//
//  Created by alex fallah on 8/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class RiderViewController: UIViewController, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }

    var manager:CLLocationManager!

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logoutRider" {
            PFUser.logOut()
        }
    }

    //MARK: Helper Method

    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }


    //MARK: Actions
    @IBAction func onCallUberTapped(sender: UIButton) {
    }
}
