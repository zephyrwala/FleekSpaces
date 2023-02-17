//
//  MoPopUpViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 16/02/23.
//

import UIKit

class MoPopUpViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    var movieId: String?
    @IBOutlet weak var movieBio: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let myMovieID = movieId {
            fetchMovieDetails(movieID: myMovieID)
        }
        // Do any additional setup after loading the view.
    }

    //MARK: - Fetch Movie Detail
    func fetchMovieDetails(movieID: String) {
        
        guard let finalMovieId = movieId else {
            return
        }

        
      
        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_movie_details/?movie_id=\(movieID)")
        
        
        network.theBestNetworkCall(MovieDetail.self, url: url) { myMovieResult, yourMessage in
            
          
            switch myMovieResult {
                
            
            case .success(let movieData):
                print("Movie Data is here \(movieData) and \(movieData.title)")
                DispatchQueue.main.async {
                FinalDataModel.movieDetails = movieData
                print("passed data is \(movieData.title)")
                
                //images[1].backdrops[0].file_path
                    if let safeBackdropURL = movieData.images?[1].backdrops?[0].filePath {
                        
                        if let saferBG = URL(string: "https://image.tmdb.org/t/p/w500/\(safeBackdropURL)"){
                            
                            self.backdropImage.sd_setImage(with: saferBG)
                            
                        }
                        
                    }
              
                    self.movieName.text = movieData.title
                    self.movieBio.text = movieData.synopsies
                    if let safeURL = movieData.posterURL {
                        
                        let saferURL = URL(string: "https://image.tmdb.org/t/p/w500/\(safeURL)")
                        self.posterImage.sd_setImage(with: saferURL)
                    }
                    
                    
                
            }
               
            case .failure(let err):
                print("Failed to fetch data")
                
            }
            
        }
        
        
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}