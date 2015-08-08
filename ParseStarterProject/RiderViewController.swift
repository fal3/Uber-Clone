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
import MapKit


class RiderViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var manager:CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLocation()
        manager.delegate = self
    }



    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logoutRider" {
            PFUser.logOut()
        }
    }

    //MARK: Helper Method
    func getUserLocation() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()

    }


    //MARK: Cllocation delegate methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location:CLLocationCoordinate2D = (manager.location?.coordinate)!

        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        self.mapView.setRegion(region, animated: true)
        addPin(location)
    }


    //MARK: pin Helpers 

    func addPin(location: CLLocationCoordinate2D) {
        self.mapView.removeAnnotations(mapView.annotations)
        var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.latitude,location.longitude)
        var objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "Your location"
        self.mapView.addAnnotation(objectAnnotation)
    }

    //MARK: Actions
    @IBAction func onCallUberTapped(sender: UIButton) {
    }
}
