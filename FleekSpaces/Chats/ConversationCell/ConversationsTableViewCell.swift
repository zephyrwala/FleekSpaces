//
//  ConversationsTableViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 02/07/22.
//

import UIKit
import SDWebImage

class ConversationsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userConversation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.makeItGolGol()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: Conversation) {
        self.userConversation.text = model.latestMessage.text
        self.userName.text = model.name
        
        let path = "image/\(model.otherUserEmail)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path) {[weak self] results in
            
            switch results {
                
            case .success(let url):
                DispatchQueue.main.async {
                    self?.userImage.sd_setImage(with: url)
                }
               
            case .failure(let error):
                print("failed to get an image url: \(error)")
            }
        }
        
    }
    
}
