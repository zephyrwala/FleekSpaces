//
//  NewChatsTableViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 19/09/22.
//

import UIKit

class NewChatsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        profiles.layer.cornerRadius = 30
        profiles.makeItGolGol()
    }
    
    @IBOutlet weak var profiles: UIImageView!
    
  @IBOutlet weak var userNameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
