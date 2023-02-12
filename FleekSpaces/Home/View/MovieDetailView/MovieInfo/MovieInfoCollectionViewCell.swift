//
//  MovieInfoCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 09/06/22.
//

import UIKit
import YouTubeiOSPlayerHelper
import JGProgressHUD


//MARK: - Button Tap Protocols

protocol episodeBtnTap: class {
    func didTapEpisodeBtn(sender: UIButton)
}



protocol dislikeBtnTap: class {
    
    
    func didTapdisikeButtonTv(_ cell: MovieInfoCollectionViewCell)
 
    
}

protocol likeBtnTap: class {
    
    
    func didTapLikeButtonTv(_ cell: MovieInfoCollectionViewCell)

    
}

protocol watchListTap: class {
    
    func didTapWatchlistButton(_ cell: MovieInfoCollectionViewCell)
}




class MovieInfoCollectionViewCell: UICollectionViewCell, YTPlayerViewDelegate {
   
    var liked = true
    @IBOutlet weak var watchBtn: UIButton!
    @IBOutlet weak var dislikeBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var progress = JGProgressHUD()
    @IBOutlet weak var utubePlayer: YTPlayerView!
    @IBOutlet weak var genreView: UIView!
    var episodeDelegate: episodeBtnTap?
    var likeBtnDelegate: likeBtnTap?
    var dislikeBtnDelegate: dislikeBtnTap??
    var watchlistBtnDelegate: watchListTap?
    @IBOutlet weak var episodeBtn: UIButton!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieBackdrop: UIImageView!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var movieDuration: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    @IBOutlet weak var movieReleaseYear: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    
    @IBOutlet weak var moReleaseDate: UILabel!
    @IBOutlet weak var moDuration: UILabel!
    @IBOutlet weak var moLanguage: UILabel!
    
    
    @IBOutlet weak var cat1: UIView!
    @IBOutlet weak var cat2: UIView!
    @IBOutlet weak var cat3: UIView!
    
    @IBOutlet weak var cat1Label: UILabel!
    @IBOutlet weak var cat2Label: UILabel!
    @IBOutlet weak var cat3Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        utubePlayer.delegate = self
        utubePlayer.isHidden = true
        cat1.layer.cornerRadius = 10
        cat2.layer.cornerRadius = 10
        cat3.layer.cornerRadius = 10
       
      
    
    }

    
    
    @IBAction func episodeBtnTap(_ sender: UIButton) {
        episodeDelegate?.didTapEpisodeBtn(sender: sender)
    }
    
    
    
    @IBAction func watchListBtnTaps(_ sender: Any) {
        
        watchlistBtnDelegate?.didTapWatchlistButton(self)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
//        utubePlayer.playVideo()
    }
    
    
    @IBAction func likeBtnTap(_ sender: UIButton) {
        likeBtnDelegate?.didTapLikeButtonTv(self)
        
      
        
    }
    
    @IBAction func dislikeBtnTap(_ sender: UIButton) {
        
        dislikeBtnDelegate??.didTapdisikeButtonTv(self)
  
        
    }
    
    
    //Setup Calls
    func setupCell(fromData: MovieDetail) {
        
        loader.startAnimating()
        
        if fromData.trailerUrls?.count != 0 {
            if let trailerUrl = fromData.trailerUrls {
                if let trailerID = trailerUrl[0].key {
                    self.utubePlayer.load(withVideoId: trailerID)
                }
               
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.progress.dismiss(animated: true)
                self.utubePlayer.isHidden = false
            })
        } else {
            self.utubePlayer.isHidden = true
            loader.stopAnimating()
        }
     
    
        if let safeRuntime = fromData.runtime {
            
            self.movieDuration.text = "Runtime: \(safeRuntime) mins"
        }
       
       
        
        self.movieTitle.text = fromData.title
        self.moviePlot.text = fromData.synopsies
        self.movieLanguage.text = "Language: \(fromData.originalLanguage ?? "-")"
        
        if fromData.images?[1].backdrops?.count == 0 {
            if let backdropURL = fromData.posterURL {
                
                let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(backdropURL)")
                self.movieBackdrop.sd_setImage(with: newURL)
            }
           
            
        } else {
            
            if let backdropURL = fromData.images?[1].backdrops?[0].filePath {
                let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(backdropURL)")
                self.movieBackdrop.sd_setImage(with: newURL)
                self.episodeBtn.isHidden = false
            }
        }
        
//        if let images = fromData.images![1].backdrops {
//            let newURL = URL(string: "https://image.tmdb.org/t/p/w500\(images[0].filePath!)")
//            self.movieBackdrop.sd_setImage(with: newURL)
//            print("Picture url: \(newURL)\(images[0].filePath!)")
    
        
        if let safeDate = fromData.releaseDate {
            moReleaseDate.text = "\(safeDate)"
        }
        
        if let safeDuration = fromData.runtime {
            moDuration.text = "\(safeDuration) mins"
        }
        
        if let safeLanguage = fromData.originalLanguage {
            switch safeLanguage {
                
            case "hi":
                moLanguage.text = "Hindi"
            case "en":
                moLanguage.text = "English"
            case "ta":
                moLanguage.text = "Tamil"
            case "de":
                moLanguage.text = "German"
            case "no":
                moLanguage.text = "Norwegian"
            case "kn":
                moLanguage.text = "Kannada"
            case "ml":
                moLanguage.text = "Malayalam"
            case "pa":
                moLanguage.text = "Punjabi"
            case "te":
                moLanguage.text = "Telugu"
                
            default:
                moLanguage.text = safeLanguage
                
                
            }
        }
        
        
        
      
        var category = fromData.genres
        
        switch category?.count {
        case 0:
//            cat1.isHidden = true
//            cat2.isHidden = true
//            cat3.isHidden = true
            
            cat1.alpha = 0
            cat2.alpha = 0
            cat3.alpha = 0
            
        case 1:
//            cat1.isHidden = false
//            cat2.isHidden = true
//            cat3.isHidden = true
            
            cat1.alpha = 1
            cat2.alpha = 0
            cat3.alpha = 0
            
            cat1Label.text = category?[0].name
            
            
        case 2:
//            cat1.isHidden = false
//            cat2.isHidden = false
//            cat3.isHidden = true
            
            cat1.alpha = 1
            cat2.alpha = 1
            cat3.alpha = 0
            
            cat1Label.text = category?[0].name
            cat2Label.text = category?[1].name
            
        case 3:
//            cat1.isHidden = false
//            cat2.isHidden = false
//            cat3.isHidden = false
            
            cat1.alpha = 1
            cat2.alpha = 1
            cat3.alpha = 1
            
            cat1Label.text = category?[0].name
            cat2Label.text = category?[1].name
            cat3Label.text = category?[2].name
            

            
        default:
            print("default cat")
            cat1.isHidden = false
            cat2.isHidden = false
            cat3.isHidden = false
            
            cat1Label.text = category?[0].name
            cat2Label.text = category?[1].name
            cat3Label.text = category?[2].name
            
        }
       
        self.movieRating.text = "\(fromData.tmdbRating ?? 0)"
        self.movieReleaseYear.text = "Year: \(fromData.releaseDate ?? "-")"
//        self.movieDirector.text = fromData
        self.genreView.isHidden = false
        self.episodeBtn.isHidden = true
        if let safeTagline = fromData.tagline {
            self.movieDirector.text = "Tagline: \(safeTagline)"
        }
        
        
       
        
        
        
        
    }
    
    func setupTVShowDetail(fromData: TVshowDetail) {
        
        if fromData.episodeRuntime?.count != 0 {
            
            if let episodeRuntime = fromData.episodeRuntime?[0] {
                self.movieDuration.text = "Episode Runtime: \(episodeRuntime) mins"
            }
        }
       
       
        if fromData.trailerUrls?.count != 0 {
            if let trailerUrl = fromData.trailerUrls {
                if let trailerID = trailerUrl[0].key {
                    self.utubePlayer.load(withVideoId: trailerID)
                }
               
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.progress.dismiss(animated: true)
                self.utubePlayer.isHidden = false
            })
        }
     
        
     
        
        if let seasonCount = FinalDataModel.showDetails?.seasons?.count {
            self.episodeBtn.setTitle("Episode Guide (\(seasonCount) Seasons)", for: .normal)
           
        }
        if let safeTagline = fromData.tagline {
            self.movieDirector.text = "Tagline: \(safeTagline)"
        }
        self.movieTitle.text = fromData.title
        self.moviePlot.text = fromData.synopsies
        if let language = fromData.originalLanguage {
            self.movieLanguage.text = "Language: \(language)"
        }
       
        if fromData.images?[1].backdrops?.count == 0 {
            if let backdropURL = fromData.posterURL {
                let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(backdropURL)")
                self.movieBackdrop.sd_setImage(with: newURL)
            }
           
           
            self.episodeBtn.isHidden = false
        } else {
            
            if let backdropURL = fromData.images?[1].backdrops?[0].filePath {
                let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(backdropURL)")
                self.movieBackdrop.sd_setImage(with: newURL)
                self.episodeBtn.isHidden = false
            }
        }
     
       
        self.genreView.isHidden = false
        
        if let safeDate = fromData.firstAirDate {
            moReleaseDate.text = "\(safeDate)"
        }
        
        if let safeDuration = fromData.episodeRuntime {
            moDuration.text = "\(safeDuration) mins"
            
            print("episode runtime \(safeDuration)")
        }
        
        if let safeLanguage = fromData.originalLanguage {
            switch safeLanguage {
                
            case "hi":
                moLanguage.text = "Hindi"
            case "en":
                moLanguage.text = "English"
            case "ta":
                moLanguage.text = "Tamil"
            case "de":
                moLanguage.text = "German"
            case "no":
                moLanguage.text = "Norwegian"
            case "kn":
                moLanguage.text = "Kannada"
            case "ml":
                moLanguage.text = "Malayalam"
            case "pa":
                moLanguage.text = "Punjabi"
            case "te":
                moLanguage.text = "Telugu"
                
            default:
                moLanguage.text = safeLanguage
                
                
            }
        }
        
        
        var category = fromData.genres
        
        switch category?.count {
        case 0:
//            cat1.isHidden = true
//            cat2.isHidden = true
//            cat3.isHidden = true
            
            cat1.alpha = 0
            cat2.alpha = 0
            cat3.alpha = 0
            
        case 1:
//            cat1.isHidden = false
//            cat2.isHidden = true
//            cat3.isHidden = true
            
            cat1.alpha = 1
            cat2.alpha = 0
            cat3.alpha = 0
            
            cat1Label.text = category?[0].name
            
            
        case 2:
//            cat1.isHidden = false
//            cat2.isHidden = false
//            cat3.isHidden = true
            
            cat1.alpha = 1
            cat2.alpha = 1
            cat3.alpha = 0
            
            cat1Label.text = category?[0].name
            cat2Label.text = category?[1].name
            
        case 3:
//            cat1.isHidden = false
//            cat2.isHidden = false
//            cat3.isHidden = false
            
            cat1.alpha = 1
            cat2.alpha = 1
            cat3.alpha = 1
            
            cat1Label.text = category?[0].name
            cat2Label.text = category?[1].name
            cat3Label.text = category?[2].name
            

            
        default:
            print("default cat")
            cat1.isHidden = false
            cat2.isHidden = false
            cat3.isHidden = false
            
            cat1Label.text = category?[0].name
            cat2Label.text = category?[1].name
            cat3Label.text = category?[2].name
            
        }
       
        if let movieRating = fromData.tmdbRating {
            
            self.movieRating.text = "\(movieRating)"
        }
        if let airDate = fromData.firstAirDate {
            self.movieReleaseYear.text = "Year: \(airDate)"
        }
       
//        self.movieDirector.text = fromData
       
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
        if let safeVotes = fromData.voteAverage {
          
            self.movieRating.text =   String(format:"%.1f", safeVotes)
        }
        self.movieReleaseYear.text = "Year: \(fromData.firstAirDate!)"
//        self.movieDirector.text = fromData
       
        
    }
    
    func setupEpisodeCell(fromData: EpisodeDetailData) {
        
        if let safeRuntime = fromData.runtime {
            
            self.movieDuration.text = "Runtime: \(safeRuntime) mins"
        }
        self.movieTitle.text = fromData.name
        self.moviePlot.text = fromData.overview
//        self.movieLanguage.text = "Language: \(fromData.!)"
        if let backdropURL = fromData.stillPath {
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(backdropURL)")
            self.movieBackdrop.sd_setImage(with: newURL)
            self.episodeBtn.isHidden = false
        }
       
        genreView.isHidden = true
        self.movieDirector.isHidden = true
        self.episodeBtn.isHidden = true
        if let safeVotes = fromData.voteAverage {
          
            self.movieRating.text =   String(format:"%.1f", safeVotes)
        }
       
       
        self.movieReleaseYear.text = "Year: \(fromData.airDate!)"
//        self.movieDirector.text = fromData
        
        self.movieDuration.isHidden = true
//        self.genreView.isHidden = false
//        self.movieDuration.isHidden = true
        self.movieLanguage.isHidden = true
        self.movieDirector.isHidden = true
        self.movieReleaseYear.isHidden = true
        
    }
    
    
    
}
