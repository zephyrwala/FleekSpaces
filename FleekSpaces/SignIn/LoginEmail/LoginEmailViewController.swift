//
//  LoginEmailViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 27/06/22.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginEmailViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailAddress.becomeFirstResponder()
        emailAddress.delegate = self
        passwordField.delegate = self
        loginBtn.layer.cornerRadius = 10
        createAccountBtn.setTitle("", for: .normal)
        createAccountBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    @IBAction func loginBtnTap(_ sender: Any) {
        
        spinner.show(in: view)
        validateFields()
        spinner.dismiss(animated: true)
        
        
        
    }
    
    func validateFields() {
        
        
       
        let emailID = emailAddress.text ?? ""
        let passwords = passwordField.text ?? ""

        
        if emailID.isEmpty {
            emailAddressLabel.text = "Bro? Enter your email ID!"
            emailAddressLabel.textColor = .red
        }
        
        
        if passwords.isEmpty {
            passwordLabel.text = "Bro? Enter your password!"
            passwordLabel.textColor = .red
        }
        
        
        FirebaseAuth.Auth.auth().signIn(withEmail: emailID, password: passwords) { [weak self] authResult, errors in
            
            guard let strongSelf = self else {
                return
            }
            
            //failed to login
            
            guard let result = authResult, errors == nil else {
                self?.displayUIAlert(yourMessage: "failed to login \(emailID)")
                return
            }
            
            //login happens here
//
            if let user = result.user.email {
                
                UserDefaults.standard.set(emailID, forKey: "email")
                
                self?.loginSuccess(user: "\(user)")
            }
           
            
        }
        
        
       
       
        
    }
    
    func loginSuccess(user: String) {
        
        let actionSheet = UIAlertController(title: "Authentication Status", message: "Welcome back \(user) Bro! We missed you.", preferredStyle: .alert)
        
        //3 buttons - cancel , take ,choose
        
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {  [weak self] _ in
//
//            self?.dismiss(animated: true)
//
//
//
//        }))
        
        actionSheet.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            
//            DatabaseManager.shared.test()
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "xferImage") as! ProfileViewController
//
//            self?.present(controller, animated: true, completion: nil)
           
//            let controller = ProfileViewController()
//
//                self?.present(controller, animated: true)
            
            self?.dismiss(animated: true)
            
        }))
        
    
        
        present(actionSheet, animated: true)
        
        
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func createAccountBtnTap(_ sender: Any) {
        print("Button tapped")
        let controller = EmailSignInViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginEmailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailAddress {
            passwordField.becomeFirstResponder()
        }
        
        
        return true
    }
    
}
