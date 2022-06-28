//
//  LoginEmailViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 27/06/22.
//

import UIKit

class LoginEmailViewController: UIViewController {
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailAddress.delegate = self
        passwordField.delegate = self
        loginBtn.layer.cornerRadius = 10
        createAccountBtn.setTitle("", for: .normal)
        createAccountBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
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
