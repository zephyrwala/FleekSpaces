//
//  NewProfileViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 11/03/23.
//

import UIKit


class NewProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profilePic: UIImageView!
    
    var chatUser: ChatUser?
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userCoverPic: UIImageView!
    var vc1 = LoadsViewController()
    var vc2 = LoadsViewController()
    var vc3 = LoadsViewController()
    let defaults = UserDefaults.standard
  
    var myfireBaseUID = ""
    var myEmailID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        profilePic.makeItGolGol()
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
//            self.displayUIAlert(yourMessage: "You need to login to access your profile!")
//            print("COuld not find firebase uid")
//            return
//        }
        
        fetchCurrentUser()
        
       
        
        // Do any additional setup after loading the view.
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCurrentUser()
        
    }
    
    //Fetch Firebase details:
    
    //MARK: - Fetch Current user
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.displayUIAlert(yourMessage: "You need to login to access your profile!")
            print("COuld not find firebase uid")
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.displayUIAlert(yourMessage: "Failed to fetch current user: \(error)")
                
                print("Failed to fetch current user:", error)
                return
            }
            
            self.chatUser = try? snapshot?.data(as: ChatUser.self)
            print("chat user data is \(self.chatUser)")
            FirebaseManager.shared.currentUser = self.chatUser
            print("chat user singleton data is \(self.chatUser)")
            
            guard let imageURL = self.chatUser?.profileImageUrl else {return}
            let userName = self.chatUser?.email ?? "loading..."
            
            self.defaults.set(userName, forKey: "userName")
            if let fcmName = self.defaults.string(forKey: "userFCMtoken") {
                print("User defaults fcm \(fcmName)")
                
                self.saveFCM(fcmTokens: fcmName, emails: userName)
                print("profileview username is \(userName)")
               
            }
            
          
            self.setupUserProfile(email: userName, fireUID: uid)
               
//                self.tabBarController?.addSubviewToLastTabItem(imageURL)

                
            
        }
    }
    
    
    //MARK: - save fcm token here
    
    func saveFCM(fcmTokens: String, emails: String) {
        
        
        let network = NetworkURL()
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/update_firebase_token?fcmToken=\(fcmTokens)&email=\(emails)") else {return}
        
        network.loginCalls(UpdateToken.self, url: myUrl) { myResult, yourMessage in
            
            switch myResult {
                
                
            case .success(let tokens):
                print("Success is here \(tokens.isAFirebaseUser)")
                
            case .failure(let err):
                print("Error is here \(err)")
                
            }
            
            
            
        }
        
    }
    
    
    //MARK: - Setup Profile
    func setupUserProfile(email: String, fireUID: String) {
        
        //https://api-space-dev.getfleek.app/users/get_user_details?user_id=0a0c4e5d-25df-427b-9d84-760e658b9a51
        
        //https://api-space-dev.getfleek.app/users/get_user_details?email=niharika13@gmail.com&firebase_uid=ESw2sp5ehadbifI6opXoFkVZcnG3
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/get_user_details?email=\(email)&firebase_uid=\(fireUID)") else {return}
                        
        print("safe URL = \(myUrl)")
                
        guard let myTOken = UserDefaults.standard.string(forKey: "userToken") else {return}
    
        network.tokenCalls(OtherUserProfile.self, url: myUrl, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let userData):
                FinalDataModel.otherUserProfile = userData
                DispatchQueue.main.async {
                    
                    self.userName.text = userData.name
//                    if let safeFollowers = userData.followersCount {
//                        self.followersCount.text = "\(safeFollowers) Followers"
//                    }
//
//                    if let safeFollowing = userData.followingCount {
//                        self.followingCount.text = "\(safeFollowing) Following"
//                    }
                    
                    if let otherUserProfilePic = userData.avatarURL {
                        if let safeURL = URL(string: otherUserProfilePic) {
                            self.profilePic.sd_setImage(with: safeURL)
                            //FIXME: - uncomment the below once the profile is sorted
//                            self.userCoverPic.sd_setImage(with: safeURL)
                        }
                    }
                }
               
                    
                
            case .failure(let err):
                print("Error is \(err)")
                
                
            }
        }
        
        
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
