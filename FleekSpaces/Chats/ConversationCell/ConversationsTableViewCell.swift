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
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.borderWidth = 1
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
}
