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

    func setupCell(fromData: RecentMessage) {
        
        self.userName.text = fromData.username
        self.userMessage.text = fromData.text
        self.userMessageTime.text = fromData.timeAgo
       
        self.userProfileImage.sd_setImage(with: URL(string: fromData.profileImageUrl))
        
        userProfileImage.makeItGolGol()
        
    }
}
