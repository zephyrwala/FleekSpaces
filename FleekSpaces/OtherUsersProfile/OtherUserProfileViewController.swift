//
//  OtherUserProfileViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 10/03/23.
//

import UIKit

class OtherUserProfileViewController: UIViewController {
    
    
    @IBOutlet weak var userProfileBG: UIImageView!
    @IBOutlet weak var userProfilePic: UIImageView!
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    @IBOutlet weak var followingCount: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        userProfilePic.makeItGolGol()
        // Do any additional setup after loading the view.
    }

    

    func setupUserProfile(otherUserID: String) {
        
        //https://api-space-dev.getfleek.app/users/get_user_details?user_id=0a0c4e5d-25df-427b-9d84-760e658b9a51
        
        
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/get_user_details?user_id=\(otherUserID)") else {return}
                
        guard let myTOken = UserDefaults.standard.string(forKey: "userToken") else {return}
    
        network.tokenCalls(OtherUserProfile.self, url: myUrl, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let userData):
                FinalDataModel.otherUserProfile = userData
                DispatchQueue.main.async {
                    
                    self.userName.text = userData.name
                    if let safeFollowers = userData.followersCount {
                        self.followersCount.text = "\(safeFollowers) Followers"
                    }
                   
                    if let safeFollowing = userData.followingCount {
                        self.followingCount.text = "\(safeFollowing) Following"
                    }
                    
                    if let otherUserProfilePic = userData.avatarURL {
                        if let safeURL = URL(string: otherUserProfilePic) {
                            self.userProfilePic.sd_setImage(with: safeURL)
                            self.userProfileBG.sd_setImage(with: safeURL)
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
