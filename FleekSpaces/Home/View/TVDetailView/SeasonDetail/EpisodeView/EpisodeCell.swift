//
//  EpisodeCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 21/06/22.
//

import UIKit

class EpisodeCell: UICollectionViewCell {

    @IBOutlet weak var episodeRuntime: UILabel!
    @IBOutlet weak var episodeBanner: UIImageView!
    @IBOutlet weak var episodeRating: UILabel!
    @IBOutlet weak var episodeDate: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func setupCell(fromData: MyEpisode) {
        
        if let safeURLPath = fromData.backdropPath {
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(safeURLPath)")
                self.episodeBanner.sd_setImage(with: newURL)
        }
        
        if let safeRunTime = fromData.runtime {
            episodeRuntime.text = "\(safeRunTime) mins"
        }
       
//        self.episodeImage.sd_setImage(with: newURL)
        if let safeTitle = fromData.name {
            
            self.episodeTitle.text = " \(fromData.episodeNumber!). \(safeTitle)"
        }
        
        self.episodeRating.text = "\(fromData.airDate!)"
//        self.episodeDate.text = "EPISODE \(fromData.episodeNumber!)"
//        episodeImage.layer.cornerRadius = 10
        episodeBanner.layer.cornerRadius = 8
        episodeBanner.layer.cornerCurve = .continuous
//        episodeBanner.layer.borderWidth = 1
        episodeBanner.layer.borderColor = UIColor.gray.cgColor
    }

}
