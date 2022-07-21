//
//  MovieInfoCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 09/06/22.
//

import UIKit

protocol episodeBtnTap: class {
    func didTapEpisodeBtn(sender: UIButton)
}

class MovieInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var genreView: UIView!
    var episodeDelegate: episodeBtnTap?
    @IBOutlet weak var episodeBtn: UIButton!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieBackdrop: UIImageView!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var movieDuration: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    @IBOutlet weak var movieReleaseYear: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func episodeBtnTap(_ sender: UIButton) {
        episodeDelegate?.didTapEpisodeBtn(sender: sender)
    }
    
    
    func setupCell(fromData: MovieDetail) {
        
        self.movieTitle.text = fromData.title
        self.moviePlot.text = fromData.synopsies
        self.movieLanguage.text = "Language: \(fromData.originalLanguage!)"
        let newURL = URL(string: "https://image.tmdb.org/t/p/w500\(fromData.posterURL!)")
        self.movieBackdrop.sd_setImage(with: newURL)
        self.movieRating.text = "\(fromData.tmdbRating!)/10"
        self.movieReleaseYear.text = "Year: \(fromData.releaseDate!)"
//        self.movieDirector.text = fromData
        self.genreView.isHidden = true
        self.episodeBtn.isHidden = true
        
    }
    
    func setupTVCell(fromData: TVResult) {
        
        self.movieTitle.text = fromData.name
        self.moviePlot.text = fromData.overview
        self.movieLanguage.text = "Language: \(fromData.originalLanguage!)"
        if let backdropURL = fromData.backdropPath {
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(backdropURL)")
            self.movieBackdrop.sd_setImage(with: newURL)
            self.episodeBtn.isHidden = false
        }
       
        self.genreView.isHidden = true
        self.movieRating.text = "\(fromData.voteAverage!)/10"
        self.movieReleaseYear.text = "Year: \(fromData.firstAirDate!)"
//        self.movieDirector.text = fromData
       
        
    }
    
    func setupEpisodeCell(fromData: Episode) {
        
        self.movieTitle.text = fromData.name
        self.moviePlot.text = fromData.overview
//        self.movieLanguage.text = "Language: \(fromData.!)"
        if let backdropURL = fromData.stillPath {
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(backdropURL)")
            self.movieBackdrop.sd_setImage(with: newURL)
            self.episodeBtn.isHidden = false
        }
       
        self.episodeBtn.isHidden = true
        self.movieRating.text = "\(fromData.voteAverage!)/10"
        self.movieReleaseYear.text = "Year: \(fromData.airDate!)"
//        self.movieDirector.text = fromData
        
        self.genreView.isHidden = false
        self.movieDuration.isHidden = true
        self.movieLanguage.isHidden = true
        self.movieDirector.isHidden = true
        self.movieReleaseYear.isHidden = true
        
    }
    
    
    
}
