//
//  LoginViewController.swift
//  parseChat
//
//  Created by Claudia Nelson on 10/1/18.
//  Copyright © 2018 Claudia Nelson. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        // set user properties
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        //Check to see if user inputed data correctly
        if (username.isEmpty && password.isEmpty ){
            alertUser(errorMessage:"Username and password are required.")
        } else if (username.isEmpty){
            alertUser(errorMessage:"Username is required")
        }else if (password.isEmpty){
            alertUser(errorMessage:"Password is required")
        }else{
            // initialize a user object
            let newUser = PFUser()
            newUser.username = username
            newUser.password = password
            
            // call sign up function on the object
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    
                    self.alertUser(errorMessage: "User log in failed: \(error.localizedDescription)")
                } else {
                    self.performSegue(withIdentifier: "signInSegue", sender: nil)
                    print("User Registered successfully")
                    // manually segue to logged in view
                }
            }
        }
    }
    
    
    @IBAction func logIn(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
       //Check to see if user inputed data correctly
        if (username.isEmpty && password.isEmpty ){
            alertUser(errorMessage:"Username and password are required.")
        } else if (username.isEmpty){
            alertUser(errorMessage:"Username is required")
        }else if (password.isEmpty){
            alertUser(errorMessage:"Password is required")
        }else{
            PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
                if let error = error {
                    self.alertUser(errorMessage: "User log in failed: \(error.localizedDescription)")
                    print("User log in failed: \(error.localizedDescription)")
                } else {
                    print("User logged in successfully")
                    self.performSegue(withIdentifier: "signInSegue", sender: nil)
                    // display view controller that needs to shown after successful login
                }
            }
        }
    }
    
    func alertUser(errorMessage: String) -> Void {
        let alertController = UIAlertController(title: "Uh oh!!", message: errorMessage, preferredStyle: .alert)
            // create a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)

        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
        
    }
    
    //This dismisses the keyboard when hitting the 'done' button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    //This dismisses the keyboard when touching out of textField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
