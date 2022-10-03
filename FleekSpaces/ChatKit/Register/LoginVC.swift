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
    let defaults = UserDefaults.standard
    var otpString = ""
    var register = false
    
    
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
                guard let safeOTP1 = otp1.text else {return}
                guard let safeOTP2 = otp2.text else {return}
                guard let safeOTP3 = otp3.text else {return}
                guard let safeOTP4 = otp4.text else {return}
                
                otpString = "\(safeOTP1)\(safeOTP2)\(safeOTP3)\(safeOTP4)"
                print("Final OTP is \(otpString)")
                
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
    
    func loginFlow(phoneNumber: String) {
        
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/login?phone=\(phoneNumber)") else {return}
        
        print("myURL is \(myUrl)")
                network.loginCalls(LoginMessage.self, url: myUrl) { myResult, yourMessage in
                    
                
                  
                        switch myResult {
                        
                            
                        case .success(let myMessage):
                            
                           
                            
                            if myMessage.message != nil {
                                if let safeMessage = myMessage.message {
                                    print("Message is \(safeMessage)")
                                    DispatchQueue.main.async {
                                        self.alertMessageText.textColor = UIColor(named: "CoinMessageColor")
                                        self.alertMessageText.text = "Hey Bro! 👋🏻 \(safeMessage)"
                                        //change the bottom text code
                                        self.didntReceive.text = "Didn't recieve the code"
                                        self.resendOTPs.text = "Resend OTP"
                                        
                                        self.otpView.isHidden = false
                                        self.otp1.becomeFirstResponder()
                                    }
                                }
                            } else {
                                
                                if let safeMessage = myMessage.error {
                                    print("Message is \(safeMessage)")
                                    DispatchQueue.main.async {
                                        self.alertMessageText.textColor = UIColor(named: "BtnGreenColor")
                                        self.alertMessageText.text = "Oops! 🥸 \(safeMessage)."
                                        
                                        self.otpView.isHidden = true
                                        self.register = true
                                        self.loginBtn.setTitle("REGISTER", for: .normal)
                                        self.didntReceive.text = ""
                                        self.resendOTPs.text = ""
                                    }
                                }
                                
                               
                                
                            }
                            
                           
                            
                            
                        case .failure(let errs):
                         print("Error login is \(errs)")
                            
                        }
                    
                  
                    
                    
                }
        
    }
    
    
    @IBAction func verifyBtnTap(_ sender: Any) {
        
        print("Verfiy btn tapped")
        guard let safeNumber = phoneNumber.text else {return}
        verifyOTP(phoneNumber: "\(safeNumber)", otp: "\(otpString)")
    }
    
    
    //MARK: - Login Btn tap action
    //9820420420
    @IBAction func loginBtnTap(_ sender: Any) {
        
       //empty
        if let safeNumber = phoneNumber.text {
            
            
            switch safeNumber.count {
            case 0:
                DispatchQueue.main.async {
                    self.alertMessageText.textColor = UIColor(named: "CoinMessageColor")
                    self.alertMessageText.text = "Hey Bro! 🤔 You didn't enter your phone number?"
                }
                
            case 10:
//                otpView.isHidden = false
                if self.register == false {
                    
                    loginFlow(phoneNumber: "\(safeNumber)")
                    print("Phone number text is \(safeNumber)")
                    
                } else if self.register == true {
                    
                    weak var pvc = self.presentingViewController

                    self.dismiss(animated: true, completion: {
                        let vc = RegisterVC()
                        pvc?.present(vc, animated: true, completion: nil)
                    })
                }
               
               
           
                
            default:
                DispatchQueue.main.async {
                    self.alertMessageText.textColor = UIColor(named: "CoinMessageColor")
                    self.alertMessageText.text = "Bro? 🧐 Please enter a valid 10 digit phone number!"
                }
            }
            
         
        }
        //more than 10 numbers
        
    }
    
    //MARK: - Login Success
    
    func loginSucessMessage(userName: String) {
        
        let alert = UIAlertController(title: "Login Successful 🎉", message: "Welcome back \(userName), Bro! We misssed you a lot 🥹", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Let's Go!", style: .cancel, handler: { alerts in
            
           
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name("startSwiftUI"), object: nil)
            }
        }))
        present(alert, animated: true)
    }
    
    //MARK: - Verify OTP
    
    func verifyOTP(phoneNumber: String, otp: String) {
        
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/verify_otp?phone=\(phoneNumber)&otp=\(otp)") else {return}
        
        network.loginCalls(VerifyOTP.self, url: myUrl) { myResult, yourMessage in
            
            switch myResult {
                
            case .success(let otpMessage):
                print("The user details is \(otpMessage.name) \(otpMessage.phoneNumber)")
                let token = otpMessage.accessToken
                self.defaults.set(token, forKey: "userToken")
                if let safeToken = otpMessage.accessToken {
                    
                    // Email login
                 
                    guard let safeEmail = otpMessage.email else {return}
                    guard let safePassword = otpMessage.firebasePassword else {return}
                    
                    
                    FirebaseManager.shared.auth.signIn(withEmail: "\(safeEmail)", password: "\(safePassword)") { result, err in
                        if let err = err {
                            print("TOKEN Failed to login user:", err)
                            print("TOken Failed to login user: \(err)")
                            return
                        }

                        print("Token Successfully logged in as user: \(result?.user.uid ?? "") and \(result?.user.email)")

                       
                        
                      
                        
                    }
                    print("user is logged in \(FirebaseManager.shared.auth.currentUser?.uid)")
                }
               
                
                guard let safeuserName = otpMessage.name else {return}
                DispatchQueue.main.async {
                    self.loginSucessMessage(userName: "\(safeuserName)")
                   
                }
            
            case .failure(let errs):
                print("OTP Failure \(errs) \(yourMessage)")
                DispatchQueue.main.async {
                    self.displayUIAlert(yourMessage: "OTP Failure \(errs)")
                }
                
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


