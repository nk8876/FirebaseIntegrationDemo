//
//  SignUpViewController.swift
//  FirebaseIntegrationDemo
//
//  Created by Dheeraj Arora on 19/11/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    //MARK:Vars
    var ref = DatabaseReference.init()
    
    //MARK:IBOutlets
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblError: UILabel!
    
    //MARK:View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsElements()
        self.ref = Database.database().reference()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK:Hadlers
    func setupViewsElements()  {
        //Hide error label
        lblError.alpha = 0
        
        //Style elements
        Utilities.styleTextField(txtFirstName)
        Utilities.styleTextField(txtLastName)
        Utilities.styleTextField(txtEmail)
        Utilities.styleTextField(txtPhone)
        Utilities.styleTextField(txtPassword)
        Utilities.styleTextField(txtConfirmPass)
        Utilities.styleFilledButton(btnSignUp)
        self.hideKeyboardWhenTappedAround()

    }
    @IBAction func btnSignUpAction(_ sender: UIButton) {
        //Validate the field
        let error  = validation()
        if error != nil{
            //showing error message
            showError(error!    )
        }else{
            
            let fname = txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let lname = txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = txtPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let confirmPass = txtConfirmPass.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //creating the user
            Auth.auth().createUser(withEmail: email!, password: password!) { (result, error) in
                if error != nil{
                    self.showError("there was a error in creating user")
                }else{
                   //User was created successfully, now store the data
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["first_name": fname!,"last_name": lname!,"phone":phone!,"confirmpass": confirmPass!,"uid": result?.user.uid ?? ""]) { (error) in
                        if error != nil{
                            self.showError("Error in saving user data")
                        }
                    }
                    //Transition to Home
                    self.transitionToHome()
                }
            }
        }
    }
    //Check the fields and validate that the data is correct. if everything is correct, this method return nil, Otherwise it retrun the error message
    func showError(_ message: String)  {
        lblError.text = message
        lblError.alpha = 1
    }
    func validation() -> String? {
        
        //checking all the fields
          if txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || txtConfirmPass.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill allthe fields"
        }
        
        //Check if the password is secure
        let cleanPass = txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanConPass = txtConfirmPass.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanPass!) == false || Utilities.isPasswordValid(cleanConPass!) == false {
            return "Please make sure your password is at least 8 characters, contain a special character and a number"
        }
        if cleanPass != cleanConPass{
            return "Password and Confirm Password does not matched"
        }
        
        return nil
    }
    
    func transitionToHome()  {
        let homeVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeVC) as? ViewController
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
        
    }
}
