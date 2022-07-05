//
//  EmailSignInViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 27/06/22.
//

import UIKit
//import FirebaseAuth
import JGProgressHUD

class EmailSignInViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var addProfileBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    private let spinner = JGProgressHUD(style: .dark)
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var emailIDLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameField.becomeFirstResponder()
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailAddressField.delegate = self
        setupSignUp()
        addProfileBtn.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }

    @IBAction func createAccountBtnTap(_ sender: Any) {
        
    validateFields()
        spinner.show(in: view)
     
        spinner.dismiss(animated: true)
       
        
    }
    
    @IBAction func addProfileImageBtnTap(_ sender: Any) {
        
        presentPhotoActionSheet()
        
    }
    //MARK: - Prompt
    
    func loginPrompt() {
        
        let actionSheet = UIAlertController(title: "Authentication Status", message: "Hey Bro! Signup was Successful!", preferredStyle: .alert)
        
        //3 buttons - cancel , take ,choose
        
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {  [weak self] _ in
//
//            self?.dismiss(animated: true)
//
//
//
//        }))
        
        actionSheet.addAction(UIAlertAction(title: "Log In", style: .default, handler: { [weak self] _ in
            
           
            
//            let controller = LoginEmailViewController()
//
//                self?.present(controller, animated: true)
            
            self?.dismiss(animated: true)
            
          
            
        }))
        
    
        
        present(actionSheet, animated: true)
        
        
    }
    
    
    //MARK: - Validate text fields
    
    func validateFields() {
        
        
         let firstName = firstNameField.text ?? ""
         let lastName = lastNameField.text ?? ""
        let emailID = emailAddressField.text ?? ""
        let passwords = passwordField.text ?? ""

        if firstName.isEmpty {
            firstNameLabel.text = "Bro? Enter First name!"
            firstNameLabel.textColor = .red
        }
        
        if lastName.isEmpty {
            secondNameLabel.text = "Bro? Enter your last name!"
            secondNameLabel.textColor = .red
        }
        
        if emailID.isEmpty {
            emailIDLabel.text = "Bro? Enter your email ID!"
            emailIDLabel.textColor = .red
        }
        
        
        if passwords.isEmpty {
            passwordLabel.text = "Bro? Enter your password!"
            passwordLabel.textColor = .red
        }
        
        
       
        
    }
    
    
    //MARK: - register user on firebase

    
    func alertUserLoginError() {
        
//        let alert = UIAlertController(title: "", message: <#T##String?#>, preferredStyle: <#T##UIAlertController.Style#>)
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


extension EmailSignInViewController: UITextFieldDelegate, UIImagePickerControllerDelegate {
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
    
    func presentPhotoActionSheet() {
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        
        //3 buttons - cancel , take ,choose
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            
            self?.presentCamera()
            
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            
            self?.presentPhotoPicker()
            
        }))
        
        present(actionSheet, animated: true)
        
        
    }
    
    
    //MARK: - show camera
    
    func presentCamera() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
        
    }
    //MARK: - show photo picker
    
    func presentPhotoPicker() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
        
        
    }
    
    
    //MARK: - Camera and Photo picker functions
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
       
        
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
   
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        
        self.profilePic.image = selectedImage
       
    
    }
}
