//
//  OtherPersonNewProfileVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/03/23.
//

import UIKit

class OtherPersonNewProfileVC: UIViewController {

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
