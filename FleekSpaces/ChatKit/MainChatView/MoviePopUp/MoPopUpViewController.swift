//
//  MoPopUpViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 16/02/23.
//

import UIKit

class MoPopUpViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    var movieId: String?
    var tvId: String?
    var showType: String?
    var posterURL: String?
    
    //showType
    //myTitle
    //showID
    //posterURL
    var myTitle: String?
    var myposterURL: String?
    var myShowID: String?
    
    
    @IBOutlet weak var movieBio: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("SHOWS \(showType)")
        guard let safeShowType = showType else {return}
        
        checkLikes(thisShowType: safeShowType)
        
        

    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let safeShowType = showType else {return}
        
        checkLikes(thisShowType: safeShowType)
        

        
    }
    
    
    @IBAction func likeBtnTapped(_ sender: Any) {
        
//        self.myTitle = movieData.title
//        self.myShowID = movieData.movieID
//        self.myposterURL = movieData.posterURL
        
        guard let safeShowType = showType else {return}
        guard let safeTitle = myTitle else {return}
        guard let safeShowID = myShowID else {return}
        guard let safePosterURL = myposterURL else {return}
        
       
        if safeShowType == "movie" {
            
            addLikes(showType: safeShowType, myTitle: safeTitle, myShowID: safeTitle, myPosterURL: safePosterURL)
            
            
            
        }else if safeShowType == "tv_series"  {
            addLikes(showType: safeShowType, myTitle: safeTitle, myShowID: safeTitle, myPosterURL: safePosterURL)
        }
        
        
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
              
                    self.myTitle = movieData.title
                    self.myShowID = movieData.movieID
                    self.myposterURL = movieData.posterURL
                    
                    
                    print("Show type is \(self.showType) - title :\(self.myTitle) - showID is \(self.myShowID) and poster url is \(self.myposterURL)")
                    if let safeRating = movieData.tmdbRating {
                        
                        self.movieRating.text = "\(safeRating)"
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
    
    
    
    
    //MARK: - Add Likes Function
    
    func addLikes(showType: String, myTitle: String, myShowID: String, myPosterURL: String) {
        
     

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api-space-dev.getfleek.app"
        urlComponents.path = "/activity/add_likes_dislikes/"
        //api-space-dev.getfleek.app/
        urlComponents.queryItems = [
           URLQueryItem(name: "show_type", value: showType),
           URLQueryItem(name: "show_id", value: myShowID),
           URLQueryItem(name: "posters_url", value: myPosterURL),
           URLQueryItem(name: "like", value: "1"),
           URLQueryItem(name: "title", value: myTitle),
           URLQueryItem(name: "dislike", value: "0")
        ]

        print(urlComponents.url?.absoluteString)
        print("Clubbed url is ")
        print(urlComponents.url?.absoluteString)
        
        

        
        
        guard let myTOken = UserDefaults.standard.string(forKey: "userToken") else {return}
        print("My token is \(myTOken)")
        guard let myUrl = urlComponents.url else {return}
        
        let network = NetworkURL()
        network.tokenCalls(AddLike.self, url: myUrl, token: myTOken, methodType: "POST") { myResults, yourMessage in
                
            
            switch myResults {
                
                
                
            case .success(let likes):
                print("Movie result is \(likes.title) \(yourMessage) \(likes.like)")
                DispatchQueue.main.async {
                    self.likeBtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                }
               
                
//                self.checkLikes()
                
            case .failure(let err):
                print("We have movie error \(err)")
                
                
                
                
            }
            
            
        }
        
        
        
        
        
    }
    
    
    //MARK: - Check Likes
    
    func checkLikes(thisShowType: String) {
        
        
//        guard let showType = FinalDataModel.showDetails?.type else {return}
       
     
        guard let safeID = myShowID else {return}
        
//        guard let myShowId = FinalDataModel.showDetails?.showID else {return}
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api-space-dev.getfleek.app"
        urlComponents.path = "/activity/get_likes_dislikes_of_show/"
        //api-space-dev.getfleek.app/
        urlComponents.queryItems = [
           URLQueryItem(name: "show_type", value: thisShowType),
           URLQueryItem(name: "show_id", value: safeID)
         
        ]
        
        
        let network = NetworkURL()
        

        guard let myTOken = UserDefaults.standard.string(forKey: "userToken") else {return}
        print("My token is \(myTOken)")
        print("URL is \(urlComponents.url)")
        guard let myUrl = urlComponents.url else {return}
        
        network.tokenCalls(CheckLikes.self, url: myUrl, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let likeStatus):
                print("Number of likes are \(likeStatus.totalLikes) and dislikes are \(likeStatus.totalDislikes)")
                
                guard let safeLikes = likeStatus.totalLikes else { return }
                guard let safeLikeValue = likeStatus.like else {
                    return}
              
                
                DispatchQueue.main.async {
                    if safeLikeValue == true {
                        self.likeBtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                        self.likeBtn.setTitle("\(safeLikes)", for: .normal)                    }
                   
//                    print("this is self like \(self.liked) and this is safelike \(safeLikeValue)")
//                    self.numberOfLikes = safeLikes
//                    self.movieDetailCollectionView.reloadData()
                }
              
                
                
            case .failure(let err):
                print("We have an error \(err)")
                
            }
            
            
        }
    }
    
    
    
    
 
    
    //MARK: - Fetch TV Detail
    func fetchTVDetails(movieID: String) {
        
        guard let finalMovieId = movieId else {
            return
        }

        
      
        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_tv_show_details?TVshow_id=\(movieID)")
        
        
        network.theBestNetworkCall(TVshowDetail.self, url: url) { myMovieResult, yourMessage in
            
          
            switch myMovieResult {
                
            
            case .success(let movieData):
                print("Movie Data is here \(movieData) and \(movieData.title)")
                DispatchQueue.main.async {
                FinalDataModel.showDetails = movieData
                print("passed data is \(movieData.title)")
                
                //images[1].backdrops[0].file_path
                    if let safeBackdropURL = movieData.images?[1].backdrops?[0].filePath {
                        
                        if let saferBG = URL(string: "https://image.tmdb.org/t/p/w500/\(safeBackdropURL)"){
                            
                            self.backdropImage.sd_setImage(with: saferBG)
                            
                        }
                        
                    }
              
                    print("TV Synopsis - \(movieData.synopsies) and movie title \(movieData.title)")
                    self.movieName.text = movieData.title
                    if let safeRating = movieData.tmdbRating {
                        
                        self.movieRating.text = "\(safeRating)"
                    }
                    if let safeSynop = movieData.synopsies {
                        self.movieBio.text = safeSynop
                    }
                  
                    if let safeURL = movieData.posterURL {
                        
                        let saferURL = URL(string: "https://image.tmdb.org/t/p/w500/\(safeURL)")
                        self.posterImage.sd_setImage(with: saferURL)
                    }
                    
                    self.myTitle = movieData.title
                    self.myShowID = movieData.showID
                    self.myposterURL = movieData.posterURL
                
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
