//
//  LoginVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 19/08/22.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var otp1: UITextField!
    @IBOutlet weak var otp2: UITextField!
    @IBOutlet weak var otp3: UITextField!
    @IBOutlet weak var otp4: UITextField!
    
    @IBOutlet weak var verifyBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        otpView.isHidden = true
        phoneNumber.delegate = self
        phoneNumber.becomeFirstResponder()
        phoneNumber.layer.cornerRadius = 15
        loginBtn.layer.cornerRadius = 15
        verifyBtn.layer.cornerRadius = 15
        dismissBtn.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
        setupOTPBorder()
        
    }

    @IBAction func registerBtnTap(_ sender: Any) {
        let regView = RegisterVC()
        
        self.present(regView, animated: true)
    }
    
    func setupOTPBorder() {
        
        otp1.layer.borderWidth = 1.0
        otp2.layer.borderWidth = 1.0
        otp3.layer.borderWidth = 1.0
        otp4.layer.borderWidth = 1.0
        otp1.layer.borderColor = UIColor.lightGray.cgColor
        otp2.layer.borderColor = UIColor.lightGray.cgColor
        otp3.layer.borderColor = UIColor.lightGray.cgColor
        otp4.layer.borderColor = UIColor.lightGray.cgColor
        
        otp1.layer.cornerRadius = 15
        otp2.layer.cornerRadius = 15
        otp3.layer.cornerRadius = 15
        otp4.layer.cornerRadius = 15
        
    }

    @IBOutlet weak var viewTapDismiss: UIView!
    
    @IBAction func dismissThisView(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func loginBtnTap(_ sender: Any) {
        otpView.isHidden = false
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
