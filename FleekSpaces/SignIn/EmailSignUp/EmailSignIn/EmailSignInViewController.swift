//
//  EmailSignInViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 27/06/22.
//

import UIKit


class EmailSignInViewController: UIViewController {

    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameField.delegate = self
        lastNameField.delegate = self
        emailAddressField.delegate = self
        setupSignUp()
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

   func setupSignUp() {
        
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.layer.cornerRadius = 10
        
        
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


extension EmailSignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            emailAddressField.becomeFirstResponder()
        } else if textField == emailAddressField {
            passwordField.becomeFirstResponder()
        }
        
        return true
    }
}
