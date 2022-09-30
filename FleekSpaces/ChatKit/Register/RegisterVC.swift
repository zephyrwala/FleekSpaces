//
//  RegisterVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 19/08/22.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var statusMessages: UILabel!
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var alertMessageText: UILabel!
    @IBOutlet weak var selectImageBtn: UIButton!
    @IBOutlet weak var alertMessage: UIView!
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
    var selectedImagePicker: UIImage?
    var userDetails: VerifyOTP?
//    let didCompleteLoginProcess: () -> ()
    var otpString = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        nameTextField.becomeFirstResponder()
        registerBtn.layer.cornerRadius = 12
        setupOTPBorder()
        veriftBtn.layer.cornerRadius = 15
        otpView.isHidden = true
        selectImageBtn.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }

    @IBAction func selectImageBtnTap(_ sender: Any) {
        presentPhotoActionSheet()
    }
    
    
    
    
    
    func setupOTPBorder() {
        profilePic.makeItGolGol()
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

    
    
    
    @IBAction func verifyBtnTapped(_ sender: Any) {
        
        print("Verfiy btn tapped")
        guard let safeNumber = numberTextField.text else {return}
        verifyOTP(phoneNumber: "\(safeNumber)", otp: "\(otpString)")
        
        print("user logged")

        
    }
    
    
    
    //MARK: - Verify OTP
    
    func verifyOTP(phoneNumber: String, otp: String) {
        
        let network = NetworkURL()
        //https://api-space-dev.getfleek.app/users/register?phone=7397338809&name=Niharika&email=abc@gmail.com
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/verify_otp?phone=\(phoneNumber)&otp=\(otp)") else {return}
        
        network.loginCalls(VerifyOTP.self, url: myUrl) { myResult, yourMessage in
            
            switch myResult {
                
            case .success(let otpMessage):
                print("Phone is \(phoneNumber) otp is \(otp)")
                print("The user details is \(otpMessage.name) \(otpMessage.phoneNumber) and email is \(otpMessage.email)")
                if let safeToken = otpMessage.accessToken {
                    
                    // token login

                    guard let safeFBEmail = otpMessage.email else {return}
                    guard let safeFBPassword = otpMessage.firebasePassword else {return}
                    FirebaseManager.shared.auth.signIn(withEmail: "\(safeFBEmail)", password: "\(safeFBPassword)") { result, err in
                        if let err = err {
                            print("TOKEN Failed to login user:", err)
                            print("TOken Failed to login user: \(err)")
                            return
                        }

                        print("Token Successfully logged in as user: \(result?.user.uid ?? "") and \(result?.user.email)")

                       
                        //TODO: - add persist image and store user info here
                        
                        
                        print("user is logged in \(FirebaseManager.shared.auth.currentUser?.uid)")
                      
                        guard let safeuserName = otpMessage.name else {return}
                        DispatchQueue.main.async {
                            
                            //persist image
                            self.persistImageToStorage()
                            //store user information
                            
                            self.loginSucessMessage(userName: "\(safeuserName)")
                           
                        }
                      
                        
                    }
                   
                }
               
                
             
            
            case .failure(let errs):
                print("OTP Failure \(errs) \(yourMessage)")
                DispatchQueue.main.async {
                    self.displayUIAlert(yourMessage: "OTP Failure \(errs)")
                }
                
            }
            
            
        }
        
    }
    
    
    //MARK: - Login Success
    
    func loginSucessMessage(userName: String) {
        
        let alert = UIAlertController(title: "Login Successful 🎉", message: "Welcome to Fleek Spaces \(userName), Bro!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Let's Go!", style: .cancel, handler: { alerts in
            self.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
    
    //MARK: - otp field change
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
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            if textField.state.isEmpty {
                self.alertMessageText.text = "Bro? 🥸 Enter your name!"
                
            }
        }
    }
    
 
    @IBAction func registerBtnTap(_ sender: Any) {
    
        //username check
        
        
        //phone number check
            if let safeNumber = numberTextField.text {
                
            guard let safeEmail = emailID.text else {return}

            guard let safeName = nameTextField.text else {return}

            switch safeNumber.count {
            case 0:
                DispatchQueue.main.async {
                    self.alertMessageText.textColor = UIColor(named: "CoinMessageColor")
                    self.alertMessageText.text = "Hey Bro! 🤔 You didn't enter your phone number?"
                }

            case 10:
//                otpView.isHidden = false
               

               
                
                    print("Phone number text is \(safeNumber)")
              
                




            default:
                DispatchQueue.main.async {
                    self.alertMessageText.textColor = UIColor(named: "CoinMessageColor")
                    self.alertMessageText.text = "Bro? 🧐 Please enter a valid 10 digit phone number!"
                }
            }
                
                if selectedImagePicker == nil {
                    
                    self.alertMessageText.text = "Bro? 🧐 Enter a profile picture!"
                    
                } else if selectedImagePicker != nil{
                    
                    if let safeName = nameTextField.text {
                        
                       
                        
                        if !safeName.isEmpty && !safeNumber.isEmpty {
                            
                            registerFlow(userName: "\(safeName)", phoneNumber: "\(safeNumber)", email: "\(safeEmail)")
                        }
                        
                        
                    }
                }

               

        }
        
        
      
        //profile pic check
        
        
       
       
    }
    
        //MARK: - REgister Flow check Number / EMail
    
    func registerFlow(userName: String, phoneNumber: String, email:String ) {
        
        print("The username is \(userName) and phone is \(phoneNumber) and email is \(email)")
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/register?phone=\(phoneNumber)&name=\(userName)&email=\(email)") else {return}
        
        let network = NetworkURL()
        
        network.registerCalls(RegisterMessage.self, url: myUrl) { myResult, yourMessage in
            
            switch myResult {
                
                
            case .success(let message):
                if message.error == nil {
                    
                    print(message.message)
                    
                    DispatchQueue.main.async {
                        self.statusMessages.text = message.message
                        self.otpView.isHidden = false
                    }
                    
                   
                    
                } else {
                    
                    DispatchQueue.main.async {
                        self.alertMessageText.text = message.error
                        self.otpView.isHidden = true
                    }
                    
                   
                }
              
                
                
            case .failure(let err):
                print("Error")
                
                
            }
            
            
        }
        
        
        
    }
  

}



extension RegisterVC: UIImagePickerControllerDelegate {
    
    func presentPhotoActionSheet() {
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo", style: .default, handler: { _ in
            self.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
  
    
    //MARK: - Save Image to storage
    func persistImageToStorage() {
        
        let filename = "user_profile_pics/\(UUID().uuidString)"
        
        //TODO: - Fudge up happening over here
        //this should come after the user is successfully created
        //code is bouncing off from here as no user created yet
        
        
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = selectedImagePicker?.jpegData(compressionQuality: 0.5) else {return}
        ref.putData(imageData, metadata: nil) { meta, err in
            if let err = err {
                print("Failed to push image to storage \(err)")
                
                return
            }
            
            ref.downloadURL { url, err in
                
                if let err = err {
                    print("failed to retrieve downloadURL: \(err)")
                    return
                }
                
               print("Image Stored")
                
                guard let url = url else { return }
                self.storeUserInformation(imageProfileUrl: url)
            }
        }
        
    }
    
    func storeUserInformation(imageProfileUrl: URL) {


        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let safeEmail = emailID.text else {return}
            let userData = ["email": safeEmail, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        
        //TODO: - Add user first name and last name to this later ^
            FirebaseManager.shared.firestore.collection("users")
                .document(uid).setData(userData) { err in
            if let err = err {
                print(err)
                print("There is an error \(err)")
                return
            }

            print("user Info storage Sucess")
        
//                self.didCompleteLoginProcess()
        }

    }
    
    //MARK: - Photo Picker
    func presentPhotoPicker() {
        
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
        
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        
        self.profilePic.image = selectedImage
        self.selectedImagePicker = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //
        picker.dismiss(animated: true, completion: nil)
    }
    
}
