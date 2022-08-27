//
//  RegisterVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 19/08/22.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

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

            guard let safeName = nameTextField.text else {return}

            switch safeNumber.count {
            case 0:
                DispatchQueue.main.async {
                    self.alertMessageText.textColor = UIColor(named: "CoinMessageColor")
                    self.alertMessageText.text = "Hey Bro! 🤔 You didn't enter your phone number?"
                }

            case 10:
//                otpView.isHidden = false
               

                    registerFlow(userName: "\(safeName)", phoneNumber: "\(safeNumber)")
                    print("Phone number text is \(safeNumber)")
                self.otpView.isHidden = false
                




            default:
                DispatchQueue.main.async {
                    self.alertMessageText.textColor = UIColor(named: "CoinMessageColor")
                    self.alertMessageText.text = "Bro? 🧐 Please enter a valid 10 digit phone number!"
                }
            }

                if let safeName = nameTextField.text {
                    
                    if !safeName.isEmpty && !safeNumber.isEmpty {
                        
                        registerFlow(userName: safeName, phoneNumber: safeNumber)
                    }
                }

        }
        
        
      
        //profile pic check
        
        
       
       
    }
    
        //MARK: - REgister Flow
    
    func registerFlow(userName: String, phoneNumber: String) {
        
        print("The username is \(userName) and phone is \(phoneNumber)")
        
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
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //
        picker.dismiss(animated: true, completion: nil)
    }
    
}
