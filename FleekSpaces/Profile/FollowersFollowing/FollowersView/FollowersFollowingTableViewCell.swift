//
//  FollowersFollowingTableViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 04/03/23.
//

import UIKit

class FollowersFollowingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var followBg: UIView!
    @IBOutlet weak var followersProfileImage: UIImageView!
    
    @IBOutlet weak var followersName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.followersProfileImage.makeItGolGol()
        self.followBg.layer.cornerRadius = 15
        self.followBg.layer.cornerCurve = .continuous
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
