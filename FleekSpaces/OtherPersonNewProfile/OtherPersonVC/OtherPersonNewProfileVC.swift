//
//  OtherPersonNewProfileVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/03/23.
//

import UIKit

class OtherPersonNewProfileVC: UIViewController {

    
   
    @IBOutlet weak var userCoverPic: UIImageView!
    @IBOutlet weak var chatBtn: UIButton!
    
    @Published var chatUser: ChatUser?
    var thisMessage: RecentMessage?

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    var firebaseUID = ""
    var email = ""
    var profileImageURL = ""
    var isMyProfile = false
    var otherProfileID = ""
    override func viewDidLoad() {
        super.viewDidLoad()

      
        profilePic.makeItGolGol()
        setupUserProfile(otherUserID: otherProfileID)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        UserDefaults.standard.set(false, forKey: "isMyProfile")
    }

    
    @IBAction func followBtnAction(_ sender: Any) {
        
        guard let safeName = userName.text else {return}
        let alertController = UIAlertController(title: "Oops 💬", message: "You are already following \(safeName)!", preferredStyle: .alert)
        
        
        // create an OK action
        let OKAction = UIAlertAction(title: "Ok?", style: .destructive) { (action) in
            // handle response here.
            
           
    
           
           
        }
        
       
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        // add the cancel action to the alertController
      
       
      
        
        present(alertController, animated: true)
    }
    
    @IBAction func chatBtnTapAction(_ sender: Any) {
        
        guard let safeName = userName.text else {return}
        let alertController = UIAlertController(title: "Chat 💬", message: "Would you like to start a new conversation with \(safeName)?", preferredStyle: .alert)
        
        
        // create an OK action
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            // handle response here.
            
           
            guard let mySafeUID = UserDefaults.standard.string(forKey: "myUID") else {return}
            
            print("myUID = \(mySafeUID)")
            let newChatUser = ChatUser(id: self.firebaseUID, uid: self.firebaseUID, email: self.email, profileImageUrl: self.profileImageURL)
            
          
            
            let targetuserData = newChatUser
            self.chatUser = newChatUser
            self.dismiss(animated: true) {
             
                
                let vc = RecentChatKitViewController()
                vc.chatUser = targetuserData
                self.createnewConversation(result: targetuserData)
                
            }
           
           
        }
        
        // create a cancel action
        let cancelAction = UIAlertAction(title: "No", style: .destructive) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)

       
      
        
        present(alertController, animated: true)
        
       
    }
    
    
    
    
    //MARK: - New conversation is created here
    private func createnewConversation(result: ChatUser) {
        
        let email = result.email
        
        let uid = result.uid
        
        UserDefaults.standard.set(email, forKey: "otherUserEmail")
        
        let vc = ChatViewController(with: email, id: uid)
        //FIXME: - Pass the model
        vc.newChatThisMessage = result
        vc.currentUser = email
//        vc.newChatThisMessage = self.chatUser
//        vc.thisMessage = self.chatUser
        
        //FIXME: - Id is nil over here???
//        controllers.modalPresentationStyle = .fullScreen
        vc.isNewConversation = true
        
        vc.title = email.components(separatedBy: "@").first
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
    
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
//                    self.thisMessage?.profileImageUrl = userData.avatarURL!
//                    self.thisMessage?.email = userData.email
//                    self.thisMessage.
//                    if let safeFollowers = userData.followersCount {
//                        self.followersCount.text = "\(safeFollowers) Followers"
//                    }
//
//                    if let safeFollowing = userData.followingCount {
//                        self.followingCount.text = "\(safeFollowing) Following"
//                    }
                    guard let safeUID = userData.firebaseUid else {return}
                    guard let safeEmail = userData.email else {return}
                    guard let safeProfileURL = userData.avatarURL else {return}
                    self.firebaseUID = safeUID
                    self.email = safeEmail
                    self.profileImageURL = safeProfileURL
                    if let otherUserProfilePic = userData.avatarURL {
                        if let safeURL = URL(string: otherUserProfilePic) {
                            self.profilePic.sd_setImage(with: safeURL)
                            print("OTHER PERSON \(userData.firebaseUid) and email \(userData.email)")
                            //FIXME: - uncomment the below once the profile is sorted
                            self.userCoverPic.sd_setImage(with: safeURL)
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
