//
//  LoginVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 19/08/22.
//

import UIKit


class LoginVC: UIViewController, UITextFieldDelegate {

   
    @IBOutlet weak var resendOTPs: UILabel!
    @IBOutlet weak var didntReceive: UILabel!
    @IBOutlet weak var alertMessageText: UILabel!
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
    
    
    @objc func changeCharacter(myTextField: UITextField){
        
        if myTextField.text?.utf8.count == 1{
            
            switch myTextField {
            case otp1:
                otp2.becomeFirstResponder()
            case otp2:
                otp3.becomeFirstResponder()
            case otp3:
                otp4.becomeFirstResponder()
            case otp4:
                print("OTP IS \(otp1.text)\(otp2.text)\(otp3.text)\(otp4.text)")
                
            default:
                break
            }
        }
        
        
    }

    @IBAction func registerBtnTap(_ sender: Any) {
       
//        let regView = RegisterVC()
//
//        self.present(regView, animated: true) {
//            let loginState = LoginVC()
//            loginState.dismiss(animated: true)
//        }
//
       
        weak var pvc = self.presentingViewController

        self.dismiss(animated: true, completion: {
            let vc = RegisterVC()
            pvc?.present(vc, animated: true, completion: nil)
        })
    }
    
    //MARK: - Login Flow
    
    func loginFlow() {
        
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/login?phone=9820420420") else {return}
        
                network.loginCalls(LoginMessage.self, url: myUrl) { myResult, yourMessage in
                    
                
                  
                        switch myResult {
                        
                            
                        case .success(let myMessage):
                            
                            if myMessage.message != nil {
                                if let safeMessage = myMessage.message {
                                    print("Message is \(safeMessage)")
                                    DispatchQueue.main.async {
                                        self.alertMessageText.text = "\(safeMessage)"
                                        
                                        self.didntReceive.text = "Didn't recieve the code"
                                        self.resendOTPs.text = "Resend OTP"
                                    }
                                }
                            } else {
                                
                                if let safeMessage = myMessage.error {
                                    print("Message is \(safeMessage)")
                                    DispatchQueue.main.async {
                                        self.alertMessageText.text = "\(safeMessage)"
                                    }
                                }
                                
                            }
                            
                           
                            
                            
                        case .failure(let errs):
                         print("Error login is \(errs)")
                            
                        }
                    
                  
                    
                    
                }
        
    }
    
    
    @IBAction func verifyBtnTap(_ sender: Any) {
        
        verifyOTP()
    }
    
    
    //MARK: - Login Btn tap action
    
    @IBAction func loginBtnTap(_ sender: Any) {
        
       //empty
        if let safeNumber = phoneNumber.text {
            
            
            switch safeNumber.count {
            case 0:
                DispatchQueue.main.async {
                    self.alertMessageText.text = "Enter your phone number"
                }
                
            case 10:
                otpView.isHidden = false
                loginFlow()
                
           
                
            default:
                DispatchQueue.main.async {
                    self.alertMessageText.text = "Please enter a valid 10 digit phone number"
                }
            }
            
            //
            if !safeNumber.isEmpty {
                
                if safeNumber.count > 10 {
                    DispatchQueue.main.async {
                        self.alertMessageText.text = "Please enter a valid 10 digit phone number"
                    }
                }
             
                
            } else {
                
                DispatchQueue.main.async {
                    self.alertMessageText.text = "Please enter your phone Number"
                }
                //show empty state
            }
        }
        //more than 10 numbers
        
    }
    
    //MARK: - Verify OTP
    
    func verifyOTP() {
        
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/verify_otp?phone=9820420420&otp=1234") else {return}
        
        network.loginCalls(VerifyOTP.self, url: myUrl) { myResult, yourMessage in
            
            switch myResult {
                
            case .success(let otpMessage):
                print("The user details is \(otpMessage.name) \(otpMessage.phoneNumber)")
            
            case .failure(let errs):
                print("OTP Failure \(errs) \(yourMessage)")
                
            }
            
            
        }
        
    }
    
    //MARK: - OTP layout
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
        
        self.otp1.addTarget(self, action: #selector(self.changeCharacter(myTextField:)), for: .editingChanged)
        self.otp2.addTarget(self, action: #selector(self.changeCharacter(myTextField:)), for: .editingChanged)
        self.otp3.addTarget(self, action: #selector(self.changeCharacter(myTextField:)), for: .editingChanged)
        self.otp4.addTarget(self, action: #selector(self.changeCharacter(myTextField:)), for: .editingChanged)
    }

    @IBOutlet weak var viewTapDismiss: UIView!
    
    @IBAction func dismissThisView(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let safePhoneNumber = phoneNumber.text {
            if safePhoneNumber.count > 10 {
                
            }
        }
      
    }
}


