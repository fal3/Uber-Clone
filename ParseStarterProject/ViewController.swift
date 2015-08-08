//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//



import UIKit
import Parse

class ViewController: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var riderLabel: UILabel!
    @IBOutlet weak var driverLabel: UILabel!


    var signUpState = true

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func onSignUpTapped(sender: UIButton) {

        if usernameTextField.text == "" || passwordTextField.text == "" {
            displayAlert("Missing fields", message: "username and password are required")
        } else {
            makeUser()
        }
    }


    func makeUser() {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        if signUpState == true {
            user["isDriver"] = `switch`.on
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    if let errorString = error.userInfo["error"] as? String {
                        self.displayAlert("Error!", message: errorString)
                    }
                } else {
                    print("success")
                    self.performSegueWithIdentifier("loginRider", sender: self)
                }
            }
        } else {
            PFUser.logInWithUsernameInBackground(usernameTextField.text!, password:passwordTextField.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    print("logged in")
                    self.performSegueWithIdentifier("loginRider", sender: self)
                    // Do stuff after successful login.
                } else {
                    if let errorString = error!.userInfo["error"] as? String {
                        self.displayAlert("Error", message: errorString)
                    }
                }
            }

        }
    }


    @IBOutlet weak var signUpToggleButton: UIButton!

    @IBOutlet weak var toggleSignUpButton: UIButton!

    @IBAction func toggeleSignUpTapped(sender: UIButton) {
        if signUpState == true {
            signUpToggleButton.setTitle("Log in", forState: UIControlState.Normal)
            toggleSignUpButton.setTitle("Switch to Sign up", forState: UIControlState.Normal)

            riderLabel.alpha = 0
            driverLabel.alpha = 0
            `switch`.alpha = 0
        } else {
            signUpToggleButton.setTitle("Sign up", forState: UIControlState.Normal)
            toggleSignUpButton.setTitle("Switch to Log in", forState: UIControlState.Normal)

            riderLabel.alpha = 1
            driverLabel.alpha = 1
            `switch`.alpha = 1
        }
        signUpState = !signUpState
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        //dissmiss keyboard on tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dissmissKeyboard")
        view.addGestureRecognizer(tap)

    }

    func dissmissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(textfield: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser()?.username != nil {

            self.performSegueWithIdentifier("loginRider", sender: self)
        }
    }
    
}

