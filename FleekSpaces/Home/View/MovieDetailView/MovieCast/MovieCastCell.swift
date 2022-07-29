//
//  MovieCastCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 10/06/22.
//

import UIKit

class MovieCastCell: UICollectionViewCell {

    @IBOutlet weak var movieBg: UIView!
    @IBOutlet weak var actorImage: UIImageView!
    @IBOutlet weak var actorName: UILabel!
    
    @IBOutlet weak var characterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieBg.layer.cornerRadius = 10
        actorImage.layer.cornerRadius = 10
        // Initialization code
    }
    
    func setupCell(fromData: CastAndCrew) {
        
        if let pathWay = fromData.profilePath {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500\(pathWay)")
            self.actorImage.sd_setImage(with: newURL)
        }
      
        self.characterName.text = fromData.character
        self.actorName.text = fromData.name
        
    }
    
    
    func setupTVShowCell(fromData: TVCastAndCrew) {
        
        if let pathWay = fromData.profilePath {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500\(pathWay)")
            self.actorImage.sd_setImage(with: newURL)
        }
      
        self.characterName.text = fromData.character
        self.actorName.text = fromData.name
        
    }

}
