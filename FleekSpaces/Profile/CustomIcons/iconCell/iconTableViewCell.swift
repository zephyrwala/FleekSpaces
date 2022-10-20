//
//  iconTableViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 20/10/22.
//

import UIKit

class iconTableViewCell: UITableViewCell {

    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        checkMarkImage.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            checkMarkImage.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                checkMarkImage.image = UIImage(systemName: "circle")
            }
    }
    
}
