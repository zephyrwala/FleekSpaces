//
//  EpisodeCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 21/06/22.
//

import UIKit

class EpisodeCell: UICollectionViewCell {

    @IBOutlet weak var episodeBanner: UIImageView!
    @IBOutlet weak var episodeRating: UILabel!
    @IBOutlet weak var episodeDate: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func setupCell(fromData: MyEpisode) {
        
       
        let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(fromData.backdropPath!)")
//        self.episodeImage.sd_setImage(with: newURL)
        self.episodeBanner.sd_setImage(with: newURL)
        self.episodeTitle.text = fromData.name
        self.episodeRating.text = "\(fromData.airDate!)"
        self.episodeDate.text = "EPISODE \(fromData.episodeNumber!)"
//        episodeImage.layer.cornerRadius = 10
        episodeBanner.layer.cornerRadius = 8
        episodeBanner.layer.borderWidth = 1
        episodeBanner.layer.borderColor = UIColor.gray.cgColor
    }

}
