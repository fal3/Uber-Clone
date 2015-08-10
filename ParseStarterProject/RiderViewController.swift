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

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.latitude,location.longitude)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "Your location"
        self.mapView.addAnnotation(objectAnnotation)
    }
    var riderRequestActive = false
    @IBOutlet weak var callUberButton: UIButton!
    //MARK: Actions
    @IBAction func onCallUberTapped(sender: UIButton)
    {
        if riderRequestActive == false
        {
            let request = PFObject(className:"riderRequest")
            request["username"] = PFUser.currentUser()?.username
            let requestLocation: CLLocationCoordinate2D = (manager.location?.coordinate)!
            let point = PFGeoPoint(latitude:requestLocation.latitude, longitude:requestLocation.longitude)
            request["location"] = point
            request.saveInBackgroundWithBlock
                {
                (success: Bool, error: NSError?) -> Void in
                if (success)
                {
                    print("Check parse")
                    self.callUberButton.setTitle("cancel uber", forState: UIControlState.Normal)
                } else
                {
                    let errorMessage = error?.description
                    self.displayAlert("Oh no!", message: errorMessage!)
                }
            }
            riderRequestActive = true
        } else {
            self.callUberButton.setTitle("Request uber", forState: UIControlState.Normal)
            let query = PFQuery(className: "riderRequest")
            riderRequestActive = false
            query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
            query.findObjectsInBackgroundWithBlock
                {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    if error == nil
                    {
                        // Do something with the found objects
                        if let objects = objects as? [PFObject] {
                            for object in objects
                            {
                                object.deleteInBackground()
                            }
                        }
                    } else {
                        // Log details of the failure
                    }
            }
        }
    }


}
