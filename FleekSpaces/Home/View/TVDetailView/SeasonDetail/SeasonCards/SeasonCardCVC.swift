//
//  SeasonCardCVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 29/07/22.
//

import UIKit

class SeasonCardCVC: UICollectionViewCell {

    @IBOutlet weak var seasonName: UILabel!
    @IBOutlet weak var seasonPoster: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func setupSeasonCell(fromData: TVSeason ) {
        
        if let posterPath = fromData.posterPath {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
            self.seasonPoster.sd_setImage(with: newURL)
            
        }
        
        seasonPoster.layer.cornerRadius = 10
        self.seasonName.text = fromData.name
        
    }

}


