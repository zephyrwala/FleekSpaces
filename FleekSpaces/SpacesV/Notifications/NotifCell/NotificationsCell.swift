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
    
}
