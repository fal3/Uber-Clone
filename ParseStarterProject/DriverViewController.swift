//
//  DriverViewController.swift
//  ParseStarterProject
//
//  Created by alex fallah on 8/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit

class DriverViewController: UITableViewController,CLLocationManagerDelegate {


    var usernames = [String]()
    var locations = [CLLocationCoordinate2D]()
    var distances = [CLLocationDistance]()

    var manager: CLLocationManager!

    var lon: CLLocationDegrees = 0
    var lat: CLLocationDegrees = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        populateTableView()



    }



    //MARK: Cllocation delegate methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location:CLLocationCoordinate2D = (manager.location?.coordinate)!


        lat = location.latitude
        lon = location.longitude
        getUserLocation()

    }

    //MARK: - TableView methods

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)


        cell.textLabel?.text = usernames[indexPath.row]

        cell.detailTextLabel?.text = "Distance in KM \(Double(distances[indexPath.row]))"

        return cell
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

    func populateTableView() {
        let query = PFQuery(className: "riderRequest")
        let point = PFGeoPoint(latitude: self.lat, longitude: self.lon)
        query.whereKey("location", nearGeoPoint: point)
        query.limit = 10
        query.findObjectsInBackgroundWithBlock
            {(objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil{
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        self.usernames.removeAll()
                        self.locations.removeAll()
                        for object in objects{
                            if let username = object["username"] as? String {
                                self.usernames.append(username)
                            }

                            if let location = object["location"] as? PFGeoPoint {

                                let requestLocation = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                                self.locations.append(requestLocation)

                                //cllocation coordinate 2d conversion


                                let requestCL = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
                                let driverLocation = CLLocation(latitude: self.lat, longitude: self.lon)

                                var distance = driverLocation.distanceFromLocation(requestCL)

                                distance = distance / 1000
                                self.distances.append(distance)
                            }



                        }
                        self.tableView.reloadData()
                        print(self.usernames)
                        print(self.locations)
                    }
                } else {
                    // Log details of the failure
                }
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logoutDriver"{
            //hide the nav bar
            navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: false)
            PFUser.logOut()
            
        }
        
    }
}