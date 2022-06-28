//
//  EpisodeCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 21/06/22.
//

import UIKit

class EpisodeCell: UICollectionViewCell {

    @IBOutlet weak var episodeRating: UILabel!
    @IBOutlet weak var episodeDate: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var episodeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setupCell(fromData: Episode) {
        
        let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(fromData.stillPath!)")
        self.episodeImage.sd_setImage(with: newURL)
        self.episodeTitle.text = fromData.name
        self.episodeRating.text = "\(fromData.voteAverage!)/10"
        
        episodeImage.layer.cornerRadius = 10
    }

}
