//
//  RecentChatViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/07/22.
//

import UIKit

class RecentChatViewCell: UICollectionViewCell {

    @IBOutlet weak var userMessageTime: UILabel!
    @IBOutlet weak var userMessage: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(fromData: Conversation) {
        
        self.userName.text = fromData.name
        self.userMessage.text = fromData.latestMessage.text
        
        let path = "image/\(fromData.otherUserEmail).png"
        
        print("path is \(path)")
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            
            switch result {
                
            case .success(let url):
                DispatchQueue.main.async {
                    
                    
                    self?.userProfileImage.sd_setImage(with: url)
                    
                }
            case .failure(let err):
                print("we got error \(err)")
                
            }
            
            
            
            
            
        })
//        self.userMessageTime.text = fromData.timeAgo
       
       
//        self.userProfileImage.sd_setImage(with: URL(string: fromData.profileImageUrl))
        
        userProfileImage.makeItGolGol()
        
    }
}
