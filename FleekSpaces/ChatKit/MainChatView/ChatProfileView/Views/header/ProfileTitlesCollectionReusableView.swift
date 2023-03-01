//
//  ProfileTitlesCollectionReusableView.swift
//  FleekSpaces
//
//  Created by Mayur P on 27/02/23.
//

import UIKit

class ProfileTitlesCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var recommendedByOtheruser: UILabel!
    
    var recByOtherGuy = "Recommended by"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recommendedByOtheruser.text = recByOtherGuy
        
    }
    
}
