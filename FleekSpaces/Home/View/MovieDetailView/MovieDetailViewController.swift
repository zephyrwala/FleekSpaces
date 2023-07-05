//
//  MovieDetailViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 09/06/22.
//

import UIKit

class MovieDetailViewController: UIViewController, UICollectionViewDelegate {
    
    let sec1 = "sec1ID"
    let sec2 = "sec2ID"
    let sec3 = "sec3ID"
    let sec0 = "sec0ID"

    var watchlisted = false
    var liked = false
    var disliked = false
    
    var numberOfLikes = 0
    var numberOfDislikes = 0
    let defaults = UserDefaults.standard
    var tmdbID: String?
    var movieId: String?
    var passedData: UResult?
    var movieDetailData: MovieDetail?
    var tvPassedData: TVResult?
    @IBOutlet weak var movieDetailCollectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        fetchMovieDetails(movieID: movieId)
        print("This is movie id: \(movieId)")
        if let myMovieID = movieId {
            fetchMovieDetails(movieID: myMovieID)
        }
       
        print("This is tmdb id: \(tmdbID)")
        setupCollectionView()
       
        if let myTmdbID = tmdbID {
            fetchMoreLikeThis(tmdbID: myTmdbID)
        }
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        checkLikes()
        checkWatchlist()
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    

    //MARK: - Add Likes Function
    
    func addLikes(like: String, dislike: String) {
        
        
       
        
        guard let showType = FinalDataModel.movieDetails?.type else {return}
       
        guard let title = FinalDataModel.movieDetails?.title else {return}
        
        guard let myShowId = FinalDataModel.movieDetails?.movieID else {return}
        
        guard let posterUrl = FinalDataModel.movieDetails?.posterURL else {return}
        
//        let like = "1"
//        let dislike = "0"
//
    
//        print("This is our URL \(url)")
     

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api-space-dev.getfleek.app"
        urlComponents.path = "/activity/add_likes_dislikes/"
        //api-space-dev.getfleek.app/
        urlComponents.queryItems = [
           URLQueryItem(name: "show_type", value: "movie"),
           URLQueryItem(name: "show_id", value: myShowId),
           URLQueryItem(name: "posters_url", value: posterUrl),
           URLQueryItem(name: "like", value: like),
           URLQueryItem(name: "title", value: title),
           URLQueryItem(name: "dislike", value: dislike)
        ]

        print(urlComponents.url?.absoluteString)
        print("Clubbed url is ")
        print(urlComponents.url?.absoluteString)
        
        

        
        
        guard let myTOken = defaults.string(forKey: "userToken") else {return}
        print("My token is \(myTOken)")
        guard let myUrl = urlComponents.url else {return}
        
        let network = NetworkURL()
        network.tokenCalls(AddLike.self, url: myUrl, token: myTOken, methodType: "POST") { myResults, yourMessage in
                
            
            switch myResults {
                
                
                
            case .success(let likes):
                print("Movie result is \(likes.title) \(yourMessage) \(likes)")
                
//                self.checkLikes()
                
            case .failure(let err):
                print("We have movie error \(err)")
                
                
                
                
            }
            
            
        }
        
        
        
        
        
    }

    
    //MARK: - Fetch More Like This
    
    func fetchMoreLikeThis(tmdbID: String){
        
        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_similar_movies?tmdb_id=\(tmdbID)")
        
        network.theBestNetworkCall(SimilarMovies.self, url: url) { mySimilarMovieResult, yourMessage in
            
            
            switch mySimilarMovieResult {
                
                
            case .success(let movieData):
                
                DispatchQueue.main.async {
                    
                    FinalDataModel.similarMovies = movieData
                    self.movieDetailCollectionView.reloadData()
//                    print("Similar Data is here \(movieData) and \(movieData.results?[0].posterPath)")
                }
                
            case .failure(let err):
                print("Failed to fetch similar movie data : \(err)")
                
            }
            
            
        }
        
    }
    
    
    
    //MARK: - Fetch Movie Detail with TMDB id
    func fetchMovieDetailswithTMDBid(tmdbID: String) {
        
//        guard let finalMovieId = movieId else {
//            return
//        }

        //https://api-space-dev.getfleek.app/shows/get_movie_details/?tmdb_id=1396
      
        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_movie_details/?tmdb_id=\(tmdbID)")
        
        
        network.theBestNetworkCall(MovieDetail.self, url: url) { myMovieResult, yourMessage in
            
          
            switch myMovieResult {
                
            
            case .success(let movieData):
                print("Movie tmdb Data is here \(movieData) and \(movieData.title)")
                DispatchQueue.main.async {
                FinalDataModel.movieDetails = movieData
                print("tmdb passed data is \(movieData.title)")
                
                
              
                self.movieDetailCollectionView.reloadData()
                
            }
               
            case .failure(let err):
                print("Failed to fetch data")
                
            }
            
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
                
                
              
                self.movieDetailCollectionView.reloadData()
                
            }
               
            case .failure(let err):
                print("Failed to fetch data")
                
            }
            
        }
        
        
    
    }
    
    
    //MARK: - Setup Collection
    
    func setupCollectionView() {
        
        movieDetailCollectionView.delegate = self
        movieDetailCollectionView.dataSource = self
        movieDetailCollectionView.collectionViewLayout = layoutCells()
        //register cell
        movieDetailCollectionView.register(UINib(nibName: "MovieInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieInfo")
        movieDetailCollectionView.register(UINib(nibName: "MoviePlayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "moviePDF")
        movieDetailCollectionView.register(UINib(nibName: "MovieCastCell", bundle: nil), forCellWithReuseIdentifier: "movCast")
        movieDetailCollectionView.register(UINib(nibName: "MoreLikeThisCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "moreLike")

        //register header
        movieDetailCollectionView.register(UINib(nibName: "Section2CRV", bundle: nil), forSupplementaryViewOfKind: self.sec1, withReuseIdentifier: "sec2Header")
        movieDetailCollectionView.register(UINib(nibName: "MovieCastCRV", bundle: nil), forSupplementaryViewOfKind: self.sec2, withReuseIdentifier: "casts")
        movieDetailCollectionView.register(UINib(nibName: "MoreLikeThisCRV", bundle: nil), forSupplementaryViewOfKind: self.sec3, withReuseIdentifier: "moreH")
        
 
    }
    
    
    //MARK: - Layout cell
    
    func layoutCells() -> UICollectionViewCompositionalLayout {
        
        
     
        //start
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
                
            case 0:
           
            let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            myItem.contentInsets.trailing = 0
            myItem.contentInsets.bottom = 10
            myItem.contentInsets.leading = 0
            myItem.contentInsets.top = 0
            
            
               
                if UIDevice.current.userInterfaceIdiom == .pad {
                    //group size
                        let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(770)), subitems: [myItem])
                    
                    //section size
                    
                    let section = NSCollectionLayoutSection(group: myGroup)
                    
                    section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                    
          
                    return section
                } else {
                    //group size
                        let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(550)), subitems: [myItem])
                    
                    //section size
                    
                    let section = NSCollectionLayoutSection(group: myGroup)
                    
                    section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                    
          
                    return section
                }
        
                
                
            case 1:
                
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
//                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(45)), elementKind: self.sec1, alignment: .top)
              
                section.boundarySupplementaryItems = [header]
                
                
                return section
                
            
            case 2:
                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 6
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 6
                myItem.contentInsets.top = 6
                
                //group size
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.21), heightDimension: .absolute(240)), subitems: [myItem])
                    
                    //section size
                    
                    let section = NSCollectionLayoutSection(group: myGroup)

                    section.orthogonalScrollingBehavior = .groupPaging
    //
                    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec2, alignment: .top)
    //                header.pinToVisibleBounds = true
                    section.boundarySupplementaryItems = [header]
                    
                    
                    return section
                } else {
                    let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.42), heightDimension: .absolute(240)), subitems: [myItem])
                    
                    //section size
                    
                    let section = NSCollectionLayoutSection(group: myGroup)

                    section.orthogonalScrollingBehavior = .groupPaging
    //
                    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec2, alignment: .top)
    //                header.pinToVisibleBounds = true
                    section.boundarySupplementaryItems = [header]
                    
                    
                    return section
                }
              
                
            case 3:
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    
                    //group size
                    let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.21), heightDimension: .absolute(220)), subitems: [myItem])
                    
                    //section size
                    
                    let section = NSCollectionLayoutSection(group: myGroup)
                    
                    section.orthogonalScrollingBehavior = .continuous
                    
                    //TODO: - Setup header after the cell is generated.
                    
                    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec3, alignment: .top)
    //                header.pinToVisibleBounds = true
                    section.boundarySupplementaryItems = [header]

                    return section
            
                    
                } else {
                    
                    //group size
                    let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.43), heightDimension: .absolute(220)), subitems: [myItem])
                    
                    //section size
                    
                    let section = NSCollectionLayoutSection(group: myGroup)
                    
                    section.orthogonalScrollingBehavior = .continuous
                    
                    //TODO: - Setup header after the cell is generated.
                    
                    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec3, alignment: .top)
    //                header.pinToVisibleBounds = true
                    section.boundarySupplementaryItems = [header]

                    return section
            
                    
                }
            
                
                
                
            default:
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(480)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuous
             
                
                
                return section
                    

            }
            
        }
        //end
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
        
        
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

//MARK: -  Data Source

extension MovieDetailViewController: UICollectionViewDataSource, likeBtnTap, watchListTap, dislikeBtnTap {
    
    func didTapdisikeButtonTv(_ cell: MovieInfoCollectionViewCell) {
       
            
       
        
        
        cell.likeBtn.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        
        cell.dislikeBtn.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
        
        cell.dislikeBtn.tintColor = .systemPink
          
        addLikes(like: "0", dislike: "1")
          print("Dislike tapp")
        
    }
    
    //watchlist
    func didTapWatchlistButton(_ cell: MovieInfoCollectionViewCell) {
        
        if FirebaseManager.shared.auth.currentUser == nil {
            loginPrompt()
        } else if FirebaseManager.shared.auth.currentUser != nil {
            
            if self.watchlisted == false {
                
                addWatchlist()
                
                //movie prompt comes here
                
                watchlistPrompt()
                cell.watchBtn.setImage(UIImage(systemName: "video.fill.badge.checkmark"), for: .normal)
                cell.watchBtn.tintColor = .systemYellow
                
            }
            
            
            
            
        }
        
        
    }
    
    
    //PROTOCOL
    func didTapLikeButtonTv(_ cell: MovieInfoCollectionViewCell) {
        
        
        if FirebaseManager.shared.auth.currentUser == nil {
            loginPrompt()
        } else if FirebaseManager.shared.auth.currentUser != nil {
            
           
                
                addLikes(like: "1", dislike: "0")
                
                //the pormpt should come here
                cell.likeBtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                
             
                
                cell.dislikeBtn.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
                
                cell.likeBtn.tintColor = .systemTeal
                
//                basicPrompt()
            
          
          
           
                

//                cell.likeBtn.setTitle("\(self.numberOfLikes)", for: .normal)
               

            
           
         
           
            //TODO: - Add like network call here
//            addLike()
            
          
       
            
        }
        
        print("Like tapp")
        
        
        
    }
    
    
    //MARK: - Login Prompt
    
    func loginPrompt() {
        
        let actionSheet = UIAlertController(title: "Must Login!", message: "Hey Bro! You must login to add likes and dislikes for this section!", preferredStyle: .alert)
        
        
        actionSheet.addAction(UIAlertAction(title: "Log In", style: .default, handler: { [weak self] _ in
            
           
            
            let controller = LoginVC()
                
              
            self?.navigationController?.pushViewController(controller, animated: true)
            
//            self?.present(controller, animated: true)
//            self?.present(controller, animated: true)
            
          
            
        }))
        
    
        
        present(actionSheet, animated: true)
        
        
    }
    
    
    //MARK: - Add Watchlist
    
    func addWatchlist() {
        
        
       
        
        guard let showType = FinalDataModel.movieDetails?.type else {return}
       
        guard let title = FinalDataModel.movieDetails?.title else {return}
        
        guard let myShowId = FinalDataModel.movieDetails?.movieID else {return}
        
        guard let posterUrl = FinalDataModel.movieDetails?.posterURL else {return}
        
      
     

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api-space-dev.getfleek.app"
        urlComponents.path = "/activity/add_to_user_watch_list/"
        //api-space-dev.getfleek.app/
        urlComponents.queryItems = [
           URLQueryItem(name: "show_type", value: "movie"),
           URLQueryItem(name: "show_id", value: myShowId),
           URLQueryItem(name: "posters_url", value: posterUrl),
           URLQueryItem(name: "title", value: title)
         
        ]

        print(urlComponents.url?.absoluteString)
        print("Clubbed url is ")
        print(urlComponents.url?.absoluteString)
        
        

        
        
        guard let myTOken = defaults.string(forKey: "userToken") else {return}
        print("My token is \(myTOken)")
        guard let myUrl = urlComponents.url else {return}
        
        let network = NetworkURL()
        network.tokenCalls(WatchList.self, url: myUrl, token: myTOken, methodType: "POST") { myResults, yourMessage in
                
            
            switch myResults {
                
                
                
            case .success(let likes):
                print("result of watchlist is \(likes.title) \(yourMessage) \(likes)")
                self.checkLikes()
                
            case .failure(let err):
                print("We have error \(err)")
                
                
                
                
            }
            
            
        }
        
        
        
        
        
    }
    
    
    //MARK: - Basic prompt
    
    func basicPrompt() {
        
        let actionSheet = UIAlertController(title: "Like-d 👍🏼", message: "Your Like has been added!", preferredStyle: .alert)
        
        
        actionSheet.addAction(UIAlertAction(title: "Awesome!", style: .default, handler: { [weak self] _ in
            
            if let strongSelf = self {
                
                strongSelf.checkLikes()
                
                print("strong self and like generatoed for movies")
            }
     
           
            
          
            
        }))
        
    
        
        present(actionSheet, animated: true)
        
        
    }
    
    func watchlistPrompt() {
        
        let actionSheet = UIAlertController(title: "Watchlist-ed 🎉", message: "This movie has been added to your Watchlist!", preferredStyle: .alert)
        
        
        actionSheet.addAction(UIAlertAction(title: "Awesome!", style: .default, handler: { [weak self] _ in
            
            if let strongSelf = self {
                
//                strongSelf.checkLikes()
                
                //TODO: - watch listed or not over here
                
                print("strong self and like generatoed for movies")
            }
     
           
            
          
            
        }))
        
    
        
        present(actionSheet, animated: true)
        
        
    }
    
    //MARK: - Check Likes
    
    func checkLikes() {
        
        
//        guard let showType = FinalDataModel.showDetails?.type else {return}
       
     
        guard let safeID = movieId else {return}
        
//        guard let myShowId = FinalDataModel.showDetails?.showID else {return}
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api-space-dev.getfleek.app"
        urlComponents.path = "/activity/get_likes_dislikes_of_show/"
        //api-space-dev.getfleek.app/
        urlComponents.queryItems = [
           URLQueryItem(name: "show_type", value: "movie"),
           URLQueryItem(name: "show_id", value: safeID)
         
        ]
        
        
        let network = NetworkURL()
        

        guard let myTOken = defaults.string(forKey: "userToken") else {return}
        print("My token is \(myTOken)")
        guard let myUrl = urlComponents.url else {return}
        
        network.tokenCalls(CheckLikes.self, url: myUrl, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let likeStatus):
                print("Number of likes are \(likeStatus.totalLikes) and dislikes are \(likeStatus.totalDislikes)")
                
                guard let safeLikes = likeStatus.totalLikes else { return }
                guard let safeLikeValue = likeStatus.like else {
                    return}
                guard let safeDislikeValue = likeStatus.dislike else {return}
                
                DispatchQueue.main.async {
                    self.liked = safeLikeValue
                    self.disliked = safeDislikeValue
                    print("this is self like \(self.liked) and this is safelike \(safeLikeValue)")
                    self.numberOfLikes = safeLikes
                    self.movieDetailCollectionView.reloadData()
                }
              
                
                
            case .failure(let err):
                print("We have an error \(err)")
                
            }
            
            
        }
    }
    
    
    
    //MARK: - Check watchlist
    

    
    func checkWatchlist() {
        
        
//        guard let showType = FinalDataModel.showDetails?.type else {return}
       
     
        guard let safeID = movieId else {return}
        
//        guard let myShowId = FinalDataModel.showDetails?.showID else {return}
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api-space-dev.getfleek.app"
        urlComponents.path = "/activity/get_show_watch_list/"
        //api-space-dev.getfleek.app/
        urlComponents.queryItems = [
           URLQueryItem(name: "show_type", value: "movie"),
           URLQueryItem(name: "show_id", value: safeID)
         
        ]
        
        
        let network = NetworkURL()
        

        guard let myTOken = defaults.string(forKey: "userToken") else {return}
        print("My token is \(myTOken)")
        guard let myUrl = urlComponents.url else {return}
        
        network.tokenCalls(WatchlistedData.self, url: myUrl, token: myTOken, methodType: "GET") { myResults, yourMessage in
            
            
            switch myResults {
                
                
            case .success(let watchData):
                print("Watclisted data is \(watchData.watchlisted)")
                if watchData.watchlisted == true {
                    
                    DispatchQueue.main.async {
                        
                        self.watchlisted = true
                        self.movieDetailCollectionView.reloadData()
                        
                    }
                    
                }
                
        
            case .failure(let err):
                print("Error is here \(err)")
                
                
                
                
            }
            
        }
        
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.tmdbID == nil {
            return 3
        } else {
            return 4
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return FinalDataModel.movieDetails?.providerOffers?.providerOffersIN?.flatrate?.count ?? 1
        case 2:
            
            if let castCount = FinalDataModel.movieDetails?.castAndCrew?.count {
                
                if castCount >= 12 {
                    return 12
                } else  {
                    return castCount
                    
                }
                
            }
        
          
        case 3:
            return FinalDataModel.similarMovies?.results?.count ?? 1
            
            
        default:
            return 1
        }
        
        return 1
    }
    
    //MARK: - Headers CV
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
           
        case 1:
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sec2Header", for: indexPath) as! Section2CRV
            header.headerText.text = "    Streaming Platforms"
           
            return header
        
        case 2:
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "casts", for: indexPath) as! MovieCastCRV
            return header
            
        case 3:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "moreH", for: indexPath) as! MoreLikeThisCRV
            return header
            
        
            
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sec2Header", for: indexPath) as! Section2CRV
            header.headerText.text = "  Streaming Platforms"
           
            return header
        }
      
    }
   
    //MARK: - Did select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            
        case 2:
            var selectedController = ActorDetailViewController()
            
            if let actorDataId = FinalDataModel.movieDetails?.castAndCrew?[indexPath.item].id {
                selectedController.actorId = "\(actorDataId)"
                selectedController.fetchActorDetail(actor: "\(actorDataId)")
                
                print("This is the actor ID here: \(actorDataId)")
                
                
            }
           
           
            navigationController?.pushViewController(selectedController, animated: true)
            
            
        case 3:
            var selectedController = MovieDetailViewController()
            
            //TODO: - More Like This
            //pass tmdbID to a new function to fetch movies
            //same data model
            //pass tmdbid to fetch more like this
            
            if let tmdbDataID = FinalDataModel.similarMovies?.results?[indexPath.item].id {
                selectedController.fetchMovieDetailswithTMDBid(tmdbID: "\(tmdbDataID)")
                selectedController.tmdbID = "\(tmdbDataID)"
                print("TMDB wala id is \(tmdbDataID)")
            }
            
//            if let jsonData = MyMovieDataModel.upcoming?.results {
//
//                selectedController.passedData = jsonData[indexPath.item]
//
//            }
            navigationController?.pushViewController(selectedController, animated: true)
            
        default:
         print("defaul tap")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieInfo", for: indexPath) as! MovieInfoCollectionViewCell
           
            cell.likeBtnDelegate = self
            cell.dislikeBtnDelegate = self
            cell.watchlistBtnDelegate = self
            if let movieData = FinalDataModel.movieDetails {
                print("movie data is here")
                cell.setupCell(fromData: movieData)
                
                if self.watchlisted == true {
                    
                    cell.watchBtn.setImage(UIImage(systemName: "video.fill.badge.checkmark"), for: .normal)
                    cell.watchBtn.tintColor = .systemYellow
                    
                }
                
                
                if self.liked == true {
                    
                    //the pormpt should come here
                    cell.likeBtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                } else if self.disliked == true {
                    
                    cell.dislikeBtn.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
                }
                
                
                
//                if numberOfLikes != 0 {
//                    
//                    cell.likeBtn.setTitle("\(numberOfLikes)", for: .normal)
//                }
              
               
            }
           
            
    
            cell.moviePlot.text = FinalDataModel.movieDetails?.synopsies
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviePDF", for: indexPath) as! MoviePlayCollectionViewCell
//            cell.setupCell(fromData: optionsLogos[indexPath.item])
            if let movieStreaming = FinalDataModel.movieDetails?.providerOffers?.providerOffersIN?.flatrate?[indexPath.item] {
                
                cell.setupMovieStreaming(fromData: movieStreaming)
            }
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movCast", for: indexPath) as! MovieCastCell
            
            if let castDetails = FinalDataModel.movieDetails {
                
                if castDetails.castAndCrew?.count != 0 {
                    
                    if let cast = castDetails.castAndCrew {
                        cell.setupCell(fromData: cast[indexPath.item])
                    }
                }
               
               
               
            }
           
            
            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreLike", for: indexPath) as! MoreLikeThisCollectionViewCell
            
            if let myMovieDataStuff = FinalDataModel.similarMovies?.results {
                
                cell.setupMoviesMoreLikeThis(fromData: myMovieDataStuff[indexPath.item])
                
            }
            
            return cell
            
        
            
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieInfo", for: indexPath) as! MovieInfoCollectionViewCell
            
            
            return cell
            
            
        }
        
    }
    
    
    
}
