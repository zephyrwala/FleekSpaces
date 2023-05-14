//
//  Section3CollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 01/06/22.
//

import UIKit

class Section3CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.layer.cornerRadius = 6
        bgView.layer.cornerRadius = 30
    }

    
    func setupCell(fromData: OTTshow){
        
        if let mainPosterPath = fromData.posterURL {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(mainPosterPath)")
            self.posterImage.sd_setImage(with: newURL)
        }
       
        
        posterImage.layer.cornerRadius = 6

        
    }
    
    
    
    
    
}
