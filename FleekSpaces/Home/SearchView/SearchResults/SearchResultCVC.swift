//
//  SearchResultCVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 13/06/22.
//

import UIKit

class SearchResultCVC: UICollectionViewCell {

    @IBOutlet weak var posterShadows: UIView!
    
    @IBOutlet weak var blursView: UIVisualEffectView!
    @IBOutlet weak var posterBackdrops: UIImageView!
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
    
    func setupCell(fromData: SearchResultElement) {
        
        self.movieTitle.text = fromData.title
        self.movieBio.text = fromData.synopsies
 
        if fromData.type == "movie" {
            self.movieGenres.text = "🍿 Movie"
        } else {
            self.movieGenres.text = "📺 TV Show"
        }
       
        if let myposter = fromData.posterPath {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(myposter)")
            self.posterImage.sd_setImage(with: newURL)
            self.posterBackdrops.sd_setImage(with: newURL)

        }
        if let safeMovieRating = fromData.tmdbRating {
            print(String(format: "%.3f", safeMovieRating))
            self.movieRating.text = String(format: "%.1f", safeMovieRating)
        }
       
        if let releaseDate = fromData.releaseYear {
            self.movieReleaseDate.text = "Year: \(releaseDate)"
        }
       
        posterImage.layer.cornerRadius = 6
        posterBg.layer.cornerRadius = 5
        posterBackdrops.layer.cornerRadius = 10
        blursView.layer.cornerRadius = 10
        blursView.clipsToBounds = true
        posterBackdrops.layer.cornerCurve = .continuous
        posterShadows.layer.shadowColor = UIColor.black.cgColor
        posterShadows.layer.shadowOpacity = 0.6
        posterShadows.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        posterShadows.layer.shadowRadius = 3
//        self.movieDirector.text = fromData
       
        
    }
    
    func setupActCell(fromData: ActCast) {
        
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
