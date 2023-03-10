//
//  UserDataCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 04/10/22.
//

import UIKit

class UserDataCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userProfileImage.makeItGolGol()
        userProfileImage.layer.borderWidth = 1
        userProfileImage.layer.borderColor = UIColor.black.cgColor
    }

}
