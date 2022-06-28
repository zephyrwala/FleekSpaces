//
//  Section2CollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 01/06/22.
//

import UIKit

class Section2CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.layer.cornerRadius = 16
    }
    
    func setupCell(fromData: UResult){
        
        let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(fromData.posterPath!)")
        self.posterImage.sd_setImage(with: newURL)
        
        posterImage.layer.cornerRadius = 16

        
    }

}
