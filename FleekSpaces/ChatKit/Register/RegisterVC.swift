//
//  RegisterVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 19/08/22.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var veriftBtn: UIButton!
    @IBOutlet weak var otp4: UITextField!
    @IBOutlet weak var otp3: UITextField!
    @IBOutlet weak var otp2: UITextField!
    @IBOutlet weak var otp1: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        nameTextField.becomeFirstResponder()
        registerBtn.layer.cornerRadius = 12
        setupOTPBorder()
        veriftBtn.layer.cornerRadius = 15
        otpView.isHidden = true
        // Do any additional setup after loading the view.
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

    @IBAction func registerBtnTap(_ sender: Any) {
    
        
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
