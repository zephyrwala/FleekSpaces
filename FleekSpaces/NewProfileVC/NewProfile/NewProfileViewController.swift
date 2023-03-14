//
//  NewProfileViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 11/03/23.
//

import UIKit


class NewProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var isMyProfile = true

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var chatBtn: UIButton!
    
    var otherProfileID = ""
    @IBOutlet weak var followingBtn: UIButton!
    var chatUser: ChatUser?
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var heightConstants: NSLayoutConstraint!
    var bounds = UIScreen.main.bounds
    
    
    @IBOutlet weak var userCoverPic: UIImageView!
    var vc1 = LoadsViewController()
    var vc2 = LoadsViewController()
    var vc3 = LoadsViewController()
    let defaults = UserDefaults.standard
    @IBOutlet weak var inviteBtn: UIButton!
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Take Photo", image: UIImage(systemName: "camera"), handler: { (_) in
           
                self.presentCamera()
                
            }),
            UIAction(title: "Choose Photo", image: UIImage(systemName: "photo.on.rectangle"), handler: { (_) in
                
            
                self.presentPhotoPicker()
                
            }),
            UIAction(title: "Sign Out", image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), handler: { (_) in
                
              
                try? FirebaseManager.shared.auth.signOut()
    //            NotificationCenter.default.post(name: NSNotification.Name("dismissSwiftUI"), object: nil)
               let controller = LoginVC()
                self.navigationController?.pushViewController(controller, animated: true)
               
                
                
            }),
       
            UIAction(title: "Change App Icon!", image: UIImage(systemName: "wand.and.stars.inverse"),  attributes: .destructive, handler: { (_) in
                
                let controller = IconChangerViewController()
                self.present(controller, animated: true)

//                self.movieDelegate?.tvShowSelected()
            })
   
            
        ]
    }
    
    var demoMenu: UIMenu {
        return UIMenu(title: "Profile Settings", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
  
    @IBOutlet weak var editProfileBtn: UIButton!
    
    var myfireBaseUID = ""
    var myEmailID = ""
    
    @IBOutlet weak var proWidth: NSLayoutConstraint!
    @IBOutlet weak var proheight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        profilePic.makeItGolGol()
        adjustHeight()
      
     
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        UserDefaults.standard.set(true, forKey: "isMyProfile")
//        isMyProfile = true
    }
  
    
    //MARK: - check my profile logic
    func checkMyProfile() {
        if isMyProfile == true {
            //hide other profile btns
            followingBtn.isHidden = true
            chatBtn.isHidden = true
          
                UserDefaults.standard.set(true, forKey: "isMyProfile")
           
//            UserDefaults.standard.set(true, forKey: "isMyProfile")
            //configure current buttons
            configureEditProfileButton()
            setupButton()
            //fetch current data
            fetchCurrentUser()
            
            
           
        } else {
            
           
         
                UserDefaults.standard.set(self.otherProfileID, forKey: "otherUserID")
            
            UserDefaults.standard.set(false, forKey: "isMyProfile")
            setupUserProfile(otherUserID: otherProfileID)
            followingBtn.isHidden = false
            chatBtn.isHidden = false
            inviteBtn.isHidden = true
            editProfileBtn.isHidden = true
        }
    }
    
    //Check height
    func adjustHeight() {
        
        var width = bounds.size.width
        var height = bounds.size.height
        
        if height < 800 {
            proheight.constant = 80
            proWidth.constant = 80
            self.heightConstants.constant = height * 0.4
        }
        self.heightConstants.constant = height * 0.37
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        fetchCurrentUser()
        
//
//        print("OTHER PERSON ID \(self.otherProfileID)")
//
//
//        UserDefaults.standard.set(isMyProfile, forKey: "isMyProfile")
//
//        let safeProfile = UserDefaults.standard.bool(forKey: "isMyProfile")
//
//        print("Isitmyprofile ? \(safeProfile)")
        
        checkMyProfile()

    }
    
    
    func setupButton() {
        
        editProfileBtn.layer.borderWidth = 1
        editProfileBtn.layer.cornerRadius = 9
        inviteBtn.layer.cornerRadius = 9
        editProfileBtn.layer.borderColor = UIColor.darkGray.cgColor
        inviteBtn.layer.borderColor = UIColor.darkGray.cgColor
        inviteBtn.layer.borderWidth = 1
    }
    
    @IBAction func inviteFriendsBtnTap(_ sender: Any) {
        
        
        let shareText = "👋🏻 Hey there! Let's discover some cool movies & TV shows on Fleek Spaces 🍿 on https://getfleek.app/"
        let textShare = [shareText]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    //MARK: - edit Profile actions
    
    //MARK: - Present Camera
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
    
    
  
    
    func configureEditProfileButton() {
        editProfileBtn.menu = demoMenu
        editProfileBtn.showsMenuAsPrimaryAction = true
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
    
    
//MARK: - Fetch Other profile
    
    
    //MARK: - Setup Profile
    func setupUserProfile(otherUserID: String) {
        
       
        
        //https://api-space-dev.getfleek.app/users/get_user_details?user_id=0a0c4e5d-25df-427b-9d84-760e658b9a51
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/get_user_details?user_id=\(otherUserID)") else {return}
                        
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
