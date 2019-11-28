//
//  LoginViewController.swift
//  FirebaseIntegrationDemo
//
//  Created by Dheeraj Arora on 19/11/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToList = "LoginToList"
    
    //MARK: IBOutelets
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblError: UILabel!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsElements()
        
//        Auth.auth().addStateDidChangeListener() { auth, user in
//            if user != nil {
//                self.performSegue(withIdentifier: self.loginToList, sender: nil)
//                self.txtEmail.text = nil
//                self.txtPassword.text = nil
//            }
//        }
    }
   
    func setupViewsElements() {
        lblError.alpha = 0
        Utilities.styleTextField(txtEmail)
        Utilities.styleTextField(txtPassword)
        Utilities.styleFilledButton(btnLogin)
        
        self.hideKeyboardWhenTappedAround()
        
        UINavigationBar.appearance().barTintColor = UIColor.darkGray
        UINavigationBar.appearance().tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationItem.title = "Login Account"
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    //MARK: Hadlers
    @IBAction func btnLofinAction(_ sender: UIButton) {
        guard let email = txtEmail.text, let password = txtPassword.text, email.count > 0, password.count > 0 else {
            return
        }
       
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                self.lblError.text = error?.localizedDescription
                self.lblError.alpha = 1
            }else{
//                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeVC) as? GroceryListTableViewController
//                self.view.window?.rootViewController = homeVC
//                self.view.window?.makeKeyAndVisible()
                let next = self.storyboard?.instantiateViewController(withIdentifier: "GroceryListTableViewController") as! GroceryListTableViewController
                self.navigationController?.pushViewController(next, animated: true)
                
            }
        }
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtEmail.becomeFirstResponder()
        }
        if textField == txtPassword {
            textField.resignFirstResponder()
        }
        return true
    }
}
