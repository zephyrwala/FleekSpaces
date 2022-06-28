//
//  SignInViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 23/06/22.
//

import UIKit
import AuthenticationServices

protocol DataEnteredDelegate: class {
    func userDidEnterInformation(info: String)
}

class SignInViewController: UIViewController {

    weak var delegate: DataEnteredDelegate? = nil
    let defaults = UserDefaults.standard
    private let signInButton = ASAuthorizationAppleIDButton(
        authorizationButtonType: .default,
           authorizationButtonStyle: UITraitCollection.current.userInterfaceStyle == .light ? .white : .black
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(signInButton)
        // Do any additional setup after loading the view.
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 0, y: 0, width: 250, height: 50)
        signInButton.center = view.center
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    @objc func didTapSignIn() {
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
        
        
    }
    
    func displaymyUIAlert(yourMessage: String) {
        
        var dialogMessage = UIAlertController(title: "Console log 📝", message: yourMessage, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Sign In", style: .default, handler: nil)
        
        let okAction = UIAlertAction(title: "Sign In", style: UIAlertAction.Style.default) {
              UIAlertAction in
              NSLog("OK Pressed")
          }
        
        dialogMessage.addAction(okAction)
        self.present(dialogMessage, animated: true, completion: nil)
        
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

extension SignInViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed to authenticate")
        self.displaymyUIAlert(yourMessage: "Y U NO Sign in?")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            
        case let credentials as ASAuthorizationAppleIDCredential:
            let firstName = credentials.fullName?.givenName
            let emailID = credentials.email
            let lastName = credentials.fullName?.familyName
            defaults.set(firstName, forKey: "firstNames")
            defaults.set(lastName, forKey: "lastName")
            print(emailID)
            print(firstName)
            delegate?.userDidEnterInformation(info: "\(firstName) \(lastName) yo")
            
            self.dismiss(animated: true)
            
            
            break
            
            
            
        default:
            break
        }
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}
