//
//  FollowersFollowingTableViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 04/03/23.
//

import UIKit

class FollowersFollowingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var followBlurBg: UIImageView!
    @IBOutlet weak var followBg: UIView!
    @IBOutlet weak var followersProfileImage: UIImageView!
    
    
    @IBOutlet weak var blurViews: UIVisualEffectView!
    
    @IBOutlet weak var followersName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.followersProfileImage.makeItGolGol()
        self.followBg.layer.cornerRadius = 10
        self.followBg.layer.cornerCurve = .continuous
       
        self.followBlurBg.clipsToBounds = true
        self.followBlurBg.layer.cornerRadius = 10
        self.followBlurBg.layer.borderWidth = 1
        self.followBlurBg.layer.borderColor = UIColor.lightGray.cgColor
       
        self.blurViews.clipsToBounds = true
        self.blurViews.layer.cornerRadius = 10
        self.blurViews.layer.cornerCurve = .continuous
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupCell (fromData: GetFollower) {
        
        
        self.followersName.text = fromData.userDetails?.name
        
        if let safeProfilePic = fromData.userDetails?.avatarURL {
            
            let newURL = URL(string: safeProfilePic)
            self.followersProfileImage.sd_setImage(with: newURL)
            self.followBlurBg.sd_setImage(with: newURL)
        }
       
    }
    
}
