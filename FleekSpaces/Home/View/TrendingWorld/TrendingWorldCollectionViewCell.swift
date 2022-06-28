//
//  TrendingWorldCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 09/06/22.
//

import UIKit

class TrendingWorldCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImage.layer.cornerRadius = 16
        
        // Initialization code
    }
    
    func setupCell(fromData: UResult) {
        
        let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(fromData.posterPath!)")
        self.posterImage.sd_setImage(with: newURL)
        
        posterImage.layer.cornerRadius = 16
        
        
    }

}
