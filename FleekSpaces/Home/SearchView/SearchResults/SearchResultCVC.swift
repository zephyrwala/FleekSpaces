//
//  SearchResultCVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 13/06/22.
//

import UIKit

class SearchResultCVC: UICollectionViewCell {

    @IBOutlet weak var posterBg: UIView!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieBio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(fromData: ActCast) {
        
        self.movieTitle.text = fromData.title
        self.movieBio.text = fromData.overview
 
        if let myposter = fromData.posterPath {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(myposter)")
            self.posterImage.sd_setImage(with: newURL)
        }
       
        self.movieRating.text = "\(fromData.voteAverage!)/10"
        if let releaseDate = fromData.releaseDate {
            self.movieReleaseDate.text = "Year: \(releaseDate)"
        }
       
        posterImage.layer.cornerRadius = 4
        posterBg.layer.cornerRadius = 5
//        self.movieDirector.text = fromData
       
        
    }

}
