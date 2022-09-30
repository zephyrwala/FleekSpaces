//
//  LoginView.swift
//  FleekSpaces
//
//  Created by Mayur P on 04/07/22.
//

import SwiftUI


struct LoginView: View {

//    init() {
//           //Use this if NavigationBarTitle is with Large Font
//           UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//
//           //Use this if NavigationBarTitle is with displayMode = .inline
//           UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
//       }
    let didCompleteLoginProcess: () -> ()

    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?

    var body: some View {
       
        NavigationView {
            
            ScrollView {

                VStack(spacing: 21) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())

                    if !isLoginMode {
                        Button {

                            shouldShowImagePicker.toggle()
                            
                        } label: {
                            
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 128, height: 128)
                                    .cornerRadius(64)
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 64))
                                    .padding()
                                    .foregroundColor(Color(.white))
                            }
                        }.overlay(RoundedRectangle(cornerRadius: 64)
                            .stroke(Color.gray, lineWidth: 3))
                    }
                    

                    Group {
                        TextField("Email", text: $email, prompt: Text("Enter your email"))
                           
                            .keyboardType(.emailAddress)
                            .foregroundColor(.black)
                            .autocapitalization(.none)
                            SecureField("Password", text: $password)
                            .foregroundColor(.black)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(10)
                   
                  

                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(Color(.init("BtnGreenColor")))
                          

                    }
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()

            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            
            
            .background(Color(.init("BGColor"))
                            .ignoresSafeArea())
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
            ImagePicker(image: $image)
        }
        
    }
    
    
   
    
    private func loginUser() {
//        FirebaseManager.shared.auth.signIn(withCustomToken: <#T##String#>)
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }

            print("Successfully logged in as user: \(result?.user.uid ?? "")")

            self.loginStatusMessage = "Login Successful"
            
            self.didCompleteLoginProcess()
        }
    }

    @State var loginStatusMessage = ""

    private func createNewAccount() {
        
       if self.image == nil {
            self.loginStatusMessage = "Hey Buddy! Please select some avatar image to proceed."
            return
        }
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }

            print("Successfully created user: \(result?.user.uid ?? "")")

            self.loginStatusMessage = "User Successfully Created"
            
            self.persistImageToStorage()
            
        }
    }
    
    
    
    
    
    
    //MARK: - Save Image to storage
    private func persistImageToStorage() {
        
        let filename = "user_profile_pics/\(UUID().uuidString)"
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {return}
        ref.putData(imageData, metadata: nil) { meta, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to storage \(err)"
                
                return
            }
            
            ref.downloadURL { url, err in
                
                if let err = err {
                    self.loginStatusMessage = "failed to retrieve downloadURL: \(err)"
                    return
                }
                
                self.loginStatusMessage = "Image Stored"
                
                guard let url = url else { return }
                storeUserInformation(imageProfileUrl: url)
                
            }
        }
        
    }

    private func handleAction() {
         if isLoginMode {
             loginUser()
         } else {
             createNewAccount()
         }
     }
    
    
    
    
    
    
    
    //MARK: - Store user info - main stuff
    private func storeUserInformation(imageProfileUrl: URL) {


        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        
        //TODO: - Add user first name and last name to this later ^
            FirebaseManager.shared.firestore.collection("users")
                .document(uid).setData(userData) { err in
            if let err = err {
                print(err)
                self.loginStatusMessage = "There is an error \(err)"
                return
            }

            print("Sucess")
        
                self.didCompleteLoginProcess()
        }

    }
    
}
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
