//
//  UpcomingMoviesCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 17/10/22.
//

import UIKit

class UpcomingMoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setupCell(fromData: Movie){
        
        if let mainPosterPath = fromData.posterPath {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(mainPosterPath)")
            self.posterImage.sd_setImage(with: newURL)
        }
       
        
        posterImage.layer.cornerRadius = 16
        
        releaseDate.text = "\(fromData.releaseDate)"

        
    }
    
    
    
}
