//
//  NotificationsCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 04/03/23.
//

import UIKit

class NotificationsCell: UITableViewCell {

    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notificationImage.makeItGolGol()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupCell(fromData: GetFollower) {
        if let safeName = fromData.userDetails?.name {
            self.notificationLabel.text = "\(safeName) has started following you"
        }
        
        
        
        if let safeProfilePic = fromData.userDetails?.avatarURL {
            
            let newURL = URL(string: safeProfilePic)
            self.notificationImage.sd_setImage(with: newURL)
          
        }
        
        
        
    }
    
}
