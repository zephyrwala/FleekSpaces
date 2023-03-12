//
//  HomeViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 01/06/22.
//

import UIKit


enum DeepLink: String {
    case home
    case profile
}

class HomeViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {
    
    //MARK: - Over lay delegate
    func recording(text: String?, final: Bool?, error: Error?) {
        
        
        
        
    }
    

   
    @IBOutlet weak var subsCollectionHts: NSLayoutConstraint!

   
    var scrollSize = 0.0
    var isMovieSelected = true
    var isIndiaSelected = true
    var chatUser: ChatUser?
    var indiaMovies: [Movies]?
    var usaMovies: [Movies]?
    
    @IBOutlet weak var aiBtoBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var visualBlurHt: NSLayoutConstraint!
    @IBOutlet weak var visualBlurLayer: UIVisualEffectView!
    @IBOutlet weak var discoverView: UIView!
    @IBOutlet weak var subsCollectionView: UICollectionView!
    @IBOutlet weak var collectionHt: NSLayoutConstraint!
    @IBOutlet weak var testViewHt: NSLayoutConstraint!
    @IBOutlet weak var addBtnChoose: UIButton!
    @IBOutlet weak var testView: UIView!
    var safeEmail = ""
    
    
    @IBOutlet weak var homeCollectionViews: UICollectionView!
    //category ID
    let sec1 = "sec1ID"
    let sec2 = "sec2ID"
    let sec3 = "sec3ID"
    let sec0 = "sec0ID"
    let sec4 = "sec4ID"
    let newTOpID = "Top"
    let defaults = UserDefaults.standard
    var myLogos = [
//        Logos(posterImage: UIImage(systemName: "plus.circle.fill")!),
        Logos(posterImage:  UIImage(named: "bo1")!, bookName: "VOGUE", author: "Vogue India"),
        Logos(posterImage:  UIImage(named: "bo22")!, bookName: "Outlook", author: "Outlook India"),
        Logos(posterImage:  UIImage(named: "bo2")!, bookName: "GQ", author: "GQ India"),
        Logos(posterImage:  UIImage(named: "bo3")!, bookName: "FEMINA", author: "Femina India"),
        Logos(posterImage:  UIImage(named: "bo4")!, bookName: "FILMFARE", author: "Filmfare India"),
        Logos(posterImage:  UIImage(named: "bo6")!, bookName: "AUTOCAR", author: "Autocar India"),
        Logos(posterImage:  UIImage(named: "bo7")!, bookName: "GRAZIA", author: "Grazia India")
                  
                 
                   
                
                   
                   
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        fetchCurrentUser()
        self.testViewHt.constant = 250
        self.collectionHt.constant = 250
        self.subsCollectionHts.constant = 110
        self.testView.layoutIfNeeded()
        fetchNewStreaming()
//        fetchNowPlaying()
//        fetchTopRated()
        fetchOTTtvShow(ottName: "Netflix")
        fetchOTTmovie(ottName: "Netflix")
        fetchTVshows()
        fetchWorldWideTrending()
        fetchUpcomingMovies()
        setupBtn()
        setupCollectionView()
        setupSubsCollectionView()
        print("Access token: \(UserDefaults.standard.string(forKey: "userToken"))")
       
       
        
       
        
      
       
       
                // Do any additional setup after loading the view.
    }
    
    //Ai Bro button tap
    
    @IBAction func aiBroBtnTap(_ sender: Any) {
        
//        // First way to listen to recording through callbacks
//           voiceOverlay.start(on: self, textHandler: { (text, finals, extraInfo) in
//             print("callback: getting \(String(describing: text))")
//             print("callback: is it final? \(String(describing: finals))")
//
//             if finals {
////
//             }
//           }, errorHandler: { (error) in
//             print("callback: error \(String(describing: error))")
//           }, resultScreenHandler: { (text) in
//             print("Result Screen: \(text)")
//           }
//           )
//
//
        
        let vc = AiBroViewController()
        self.present(vc, animated: true)
        
    }
    
 
 
    //MARK: - Search button tapped
    @IBAction func searchBtnTapped(_ sender: Any) {
        let controller = SearchViewController()
        navigationController?.pushViewController(controller, animated: true)
        
        

        
        
    }
    
    
    //MARK: - Fetch Current user
    func fetchCurrentUser()  {
        
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.displayUIAlert(yourMessage: "You need to login to access your profile!")
            print("COuld not find firebase uid")
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.displayUIAlert(yourMessage: "Failed to fetch current user: \(error)")
                
                print("Failed to fetch current user:", error)
                return
            }
            
            self.chatUser = try? snapshot?.data(as: ChatUser.self)
            print("chat user data is \(self.chatUser)")
            FirebaseManager.shared.currentUser = self.chatUser
            print("chat user singleton data is \(self.chatUser)")
            
            guard let imageURL = self.chatUser?.profileImageUrl else {return}
          
                if let userName = self.chatUser?.email {
                    
                    self.safeEmail = userName
                    
                    if let fcmName = self.defaults.string(forKey: "userFCMtoken") {
                        print("User defaults fcm \(fcmName)")
                       
                        self.saveFCM(fcmTokens: fcmName, emails: userName)
                        self.defaults.set(userName, forKey: "userName")
                       
                        print("username is \(userName)")
                       
                    }
                  
                    
                    
                }
            
            DispatchQueue.main.async {
                self.tabBarController?.addSubviewToLastTabItem(imageURL)
            }
            
            
            
          
        }
        
       
        
        
    }
    
    
    //MARK: - save fcm token here
    
    func saveFCM(fcmTokens: String, emails: String) {
        
        
        let network = NetworkURL()
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/update_firebase_token?fcmToken=\(fcmTokens)&email=\(emails)") else {return}
        
        network.loginCalls(UpdateToken.self, url: myUrl) { myResult, yourMessage in
            
            switch myResult {
                
                
            case .success(let tokens):
                print("Success is here \(tokens.isAFirebaseUser)")
                
            case .failure(let err):
                print("Error is here \(err)")
                
            }
            
            
            
        }
        
    }
    //MARK: - scroll detect
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
        let offset = homeCollectionViews.contentOffset
        print("Collection view offset \(offset)")
        DispatchQueue.main.async {
            
            self.homeCollectionViews.delegate = self
            self.scrollSize = scrollView.contentOffset.y
            DispatchQueue.main.async {

                
                switch self.homeCollectionViews.contentOffset.y {
             
                    
                    //max height tag
                case 100...1000:
                    
                    UIView.animate(withDuration: 0.5) {
                       
                        self.testViewHt.constant = 190
                        self.visualBlurHt.constant = 190
//                        self.visualBlurLayer.isHidden = false
//                        self.visualBlurLayer.alpha = 1
                        self.collectionHt.constant = 100
                        self.subsCollectionHts.constant = 30
                        self.testView.layoutIfNeeded()
//                        self.discoverView.alpha = self.scrollSize
                        self.discoverView.alpha = 0
    //
                       }

                    
                //change case for min height tags
                   
                case -1000...100:
                    UIView.animate(withDuration: 0.15) {
                        self.testViewHt.constant = 250
//                        self.visualBlurHt.constant = 250
//                        self.visualBlurLayer.isHidden = true
                        self.collectionHt.constant = 250
                        self.subsCollectionHts.constant = 110
                        self.testView.layoutIfNeeded()
                        self.discoverView.alpha = 1
                    }
                    
                default:
//                    self.testViewHt.constant = 200
                    print("This is default")
//                    self.testView.layoutIfNeeded()
                    
                    
                    
                    
                }

              
            }
        }
       
        
        

        
    }
    func setupBtn() {
        self.addBtnChoose.isHidden = true
        self.addBtnChoose.layer.cornerRadius = 12
       
        
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        let controller = ChooseSubsViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - Subs Collectionview cell
    
    func setupSubsCollectionView() {
        
        subsCollectionView.delegate = self
        subsCollectionView.dataSource = self
        subsCollectionView.collectionViewLayout = subLayoutCells()
        subsCollectionView.register(UINib(nibName: "Section1CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "sec1")
        subsCollectionView.register(UINib(nibName: "Section2CRV", bundle: nil), forSupplementaryViewOfKind: self.sec1, withReuseIdentifier: "sec2Header")
        subsCollectionView.allowsMultipleSelection = false
        
 //TODO: - remove this
      
        
    }
    
    
    //MARK: - Setup Collectionview
    func setupCollectionView() {
        
        homeCollectionViews.delegate = self
        homeCollectionViews.dataSource = self
        homeCollectionViews.collectionViewLayout = layoutCells()
        
        //register the cells
        
        homeCollectionViews.register(UINib(nibName: "NavCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "navCollection")
        homeCollectionViews.register(UINib(nibName: "Section1CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "sec1")
        homeCollectionViews.register(UINib(nibName: "Section2CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "sec2")
        homeCollectionViews.register(UINib(nibName: "Section3CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "sec3")
        homeCollectionViews.register(UINib(nibName: "TrendingWorldCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "trendCell")
        homeCollectionViews.register(UINib(nibName: "BookCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "books")
        homeCollectionViews.register(UINib(nibName: "UpcomingMoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "upcomingMov")
        
        //register the header
        homeCollectionViews.register(UINib(nibName: "Section1HeaderCRV", bundle: nil), forSupplementaryViewOfKind: self.sec1, withReuseIdentifier: "sec1Header")
        homeCollectionViews.register(UINib(nibName: "Section2CRV", bundle: nil), forSupplementaryViewOfKind: self.sec2, withReuseIdentifier: "sec2Header")
        homeCollectionViews.register(UINib(nibName: "Section3CRV", bundle: nil), forSupplementaryViewOfKind: self.sec3, withReuseIdentifier: "sec3Header")
        homeCollectionViews.register(UINib(nibName: "TrendingtCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: self.sec0, withReuseIdentifier: "worldTrend")
        homeCollectionViews.register(UINib(nibName: "BooksHeaderCRV", bundle: nil), forSupplementaryViewOfKind: self.sec4, withReuseIdentifier: "booksHead")
        
     
        
    }
    
    //MARK: - Fetch OTT Movie Url
    
    func fetchOTTmovie(ottName: String) {
        
        let network = NetworkURL()
//        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_ott_trending")
        
        
        var components = URLComponents()
            components.scheme = "https"
            components.host = "api-space-dev.getfleek.app"
            components.path = "/shows/get_ott_trending"
            components.queryItems = [
                URLQueryItem(name: "ott_name", value: ottName),
                URLQueryItem(name: "type", value: "movie")
            ]

            // Getting a URL from our components is as simple as
            // accessing the 'url' property.
            let url = components.url
        
       
        print("FINAL URL \(url)")
        
        network.theBestNetworkCall([OTTmovie].self, url: url) { myResult, yourMessage in
            
            DispatchQueue.main.async {
                switch myResult {
                    
                case .success(let movieData):
                    print("Movie is here \(movieData)")
                    FinalDataModel.ottMovie = movieData
                    self.homeCollectionViews.reloadData()
    //                self.displayUIAlert(yourMessage: "Movie data \(movieData)")
                    for eachMovie in movieData {
                        
                        print("OTT Movie : \(eachMovie.title)")
                        
                    }
                    
                case .failure(let err):
                    print("Failure in Movie fetch")
    //                self.displayUIAlert(yourMessage: "Error \(err)")
                    
                }
            }
      
            
        }
        
      
        
    }
    
    //MARK: - Fetch TV Show Url
    
    func fetchOTTtvShow(ottName: String) {
        
        let network = NetworkURL()
//        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_ott_trending")
        
        
        var components = URLComponents()
            components.scheme = "https"
            components.host = "api-space-dev.getfleek.app"
            components.path = "/shows/get_ott_trending"
            components.queryItems = [
                URLQueryItem(name: "ott_name", value: ottName),
                URLQueryItem(name: "type", value: "tv_series")
            ]

            // Getting a URL from our components is as simple as
            // accessing the 'url' property.
            let url = components.url
        
       
        print("FINAL URL \(url)")
        
        network.theBestNetworkCall([OTTshow].self, url: url) { myResult, yourMessage in
            
            DispatchQueue.main.async {
                switch myResult {
                    
                case .success(let movieData):
                    print("Movie is here \(movieData)")
                    FinalDataModel.ottShow = movieData
                    self.homeCollectionViews.reloadData()
    //                self.displayUIAlert(yourMessage: "Movie data \(movieData)")
                    for eachMovie in movieData {
                        
                        print("OTT TV SHows : \(eachMovie.title)")
                        
                    }
                    
                case .failure(let err):
                    print("Failure in OTT TV show fetch")
    //                self.displayUIAlert(yourMessage: "Error \(err)")
                    
                }
            }
      
            
        }
        
      
        
    }
    
    //MARK: - Fetch top tv shows
    
    func fetchTVshows() {
        
        let network = NetworkURL()
        let url = URL(string: "https://api.themoviedb.org/3/tv/popular")
        
        var urlComponents = URLComponents()
        
        urlComponents.queryItems = [
           URLQueryItem(name: "api_key", value: "840895aebb62f355e4e4b4e7b5d0259b")
        ]
        
        if var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/tv/popular") {
          urlComponents.queryItems = [URLQueryItem(name: "api_key", value: "840895aebb62f355e4e4b4e7b5d0259b")]
          // 3
          guard let url = urlComponents.url else {
            return
          }
            print("This is another url \(url)")
            network.theBestNetworkCall(TVshow.self, url: url) { myResult, yourMessage in
                
                DispatchQueue.main.async {
                    
                    
                    switch myResult {
                        
                    case .success(let tvData):
                        MyMovieDataModel.tvshow = tvData
                        self.homeCollectionViews.reloadData()
                        
                        
                    case .failure(let tvError):
                        self.displayUIAlert(yourMessage: "Error is here \(tvError) \(yourMessage)")
                        
                        
                    }
                    
                }
            }
        }
            
    }
    
    
    //MARK: - Fetch streaming service call
    
    func fetchNewStreaming() {
        
        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_available_streaming_services/")
        
        
        network.theBestNetworkCall([StreamingElement].self, url: url) { myResult, yourMessage in
            
            switch myResult {
                
            case .success(let streams):
                print("This is streams \(streams)")
                DispatchQueue.main.async {
                    MyMovieDataModel.streamingPlatform = streams
                    self.subsCollectionView.reloadData()
                }
                
                for eachStreams in streams {
                    print("\(eachStreams.streamingServiceName)")
                }
                
            case .failure(let err):
                print("This is failure \(err)")
                
            }
            
            
        }
        
    }
    
    
    //MARK: - Fetch upcoming movies
    
    func fetchUpcomingMovies() {
        
        
        let network = NetworkURL()
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/shows/get_upcoming_movies_theatres") else {return}
        
        network.theBestNetworkCall([UpcomingMovie].self, url: myUrl) { myResult, yourMessage in
            
            switch myResult {
                
            case .success(let movieData):
                print("upcoming data is here \(movieData)")
                FinalDataModel.upcomingMovies = movieData
                
                self.indiaMovies = movieData[0].movies
                self.usaMovies = movieData[1].movies
                
                
            case .failure(let err):
                print("error upcoming is \(err)")
            }
            
        }
        
        
        
    }
    
    
    
    //MARK: - Worldwide Trending
    
    func fetchWorldWideTVTrending() {
        
        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_universal_trending/?type=tv_series")
        
        network.theBestNetworkCall([Worldwide].self, url: url) { myResult, yourMessage in
            
            DispatchQueue.main.async {
                switch myResult {
                    
                case .success(let movieData):
                    print("Movie is here \(movieData)")
                    FinalDataModel.worldWide = movieData
                    self.homeCollectionViews.reloadData()
    //                self.displayUIAlert(yourMessage: "Movie data \(movieData)")
                    for eachMovie in movieData {
                        
                        print("TV SHows : \(eachMovie.title)")
                        
                    }
                    
                case .failure(let err):
                    print("Failure in TV show fetch")
    //                self.displayUIAlert(yourMessage: "Error \(err)")
                    
                }
            }
      
            
        }
        
        
    }
    
    
    //MARK: - Worldwide Trending
    
    func fetchWorldWideTrending() {
        
        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_universal_trending/?type=movie")
        
        network.theBestNetworkCall([Worldwide].self, url: url) { myResult, yourMessage in
            
            DispatchQueue.main.async {
                switch myResult {
                    
                case .success(let movieData):
                    print("Movie is here \(movieData)")
                    FinalDataModel.worldWide = movieData
                    self.homeCollectionViews.reloadData()
    //                self.displayUIAlert(yourMessage: "Movie data \(movieData)")
                    for eachMovie in movieData {
                        
                        print("Moviesa : \(eachMovie.title)")
                        
                    }
                    
                case .failure(let err):
                    print("Failure in movie fetch")
    //                self.displayUIAlert(yourMessage: "Error \(err)")
                    
                }
            }
      
            
        }
        
        
    }
    //MARK: - Top Rated is fetched here
    
    
    func fetchTopRated() {
        
        let network = NetworkURL()
        let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming")
        
        var urlComponents = URLComponents()
        
        urlComponents.queryItems = [
           URLQueryItem(name: "api_key", value: "840895aebb62f355e4e4b4e7b5d0259b")
        ]
        
        if var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/movie/upcoming") {
          urlComponents.queryItems = [URLQueryItem(name: "api_key", value: "840895aebb62f355e4e4b4e7b5d0259b")]
          // 3
          guard let url = urlComponents.url else {
            return
          }
            
//            self.displayUIAlert(yourMessage: "URL: \(url)")


            network.theBestNetworkCall(Upcoming.self, url: url) { myResult, yourMessage in
                
                //handling result case
                
                
                
                
                DispatchQueue.main.async {
                    
                    //success
                    
                    switch myResult {
                        
                        
                    case .success(let myData):
//                        self.displayUIAlert(yourMessage: "Top rated Data is here")
                        
                        MyMovieDataModel.upcoming = myData
                        self.homeCollectionViews.reloadData()
                        
                    case .failure(let myError):
                        self.displayUIAlert(yourMessage: "Error is her")
                        
                    }
                    
                    
                    //error
                    
                    
                }
                
                
            }
        
        
    }
        //movie/top_rated
    }
    
    //MARK: - Now Playing is fetched from here
    
    
    
    func fetchNowPlaying() {
        
        let network = NetworkURL()
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")
        
        var urlComponents = URLComponents()
        
        urlComponents.queryItems = [
           URLQueryItem(name: "api_key", value: "840895aebb62f355e4e4b4e7b5d0259b")
        ]
        
        if var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/movie/now_playing") {
          urlComponents.queryItems = [URLQueryItem(name: "api_key", value: "840895aebb62f355e4e4b4e7b5d0259b")]
          // 3
          guard let url = urlComponents.url else {
            return
          }
            
//            self.displayUIAlert(yourMessage: "URL: \(url)")


            network.theBestNetworkCall(NowPlayings.self, url: url) { myResult, yourMessage in
                
                //handling result case
                
                
                
                
                DispatchQueue.main.async {
                    
                    //success
                    
                    switch myResult {
                        
                        
                    case .success(let myData):
//                        self.displayUIAlert(yourMessage: "Data is here")
                        
                        MyMovieDataModel.nowPlaying = myData
                        self.homeCollectionViews.reloadData()
                        
                    case .failure(let myError):
                        self.displayUIAlert(yourMessage: "Error is here \(myError)")
                        
                    }
                    
                    
                    //error
                    
                    
                }
                
                
            }
        
        
    }
    }

    //MARK: - OTT Platform Layout
    func subLayoutCells() -> UICollectionViewCompositionalLayout {
     
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
                
            case 0:
                
                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 6
                myItem.contentInsets.bottom = 6
                myItem.contentInsets.leading = 6
                myItem.contentInsets.top = 6
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(88), heightDimension: .absolute(88)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec1, alignment: .top)
                header.pinToVisibleBounds = true
                section.boundarySupplementaryItems = [header]
                
                
                return section
                
         
                
            default:
                let myItem = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(120), heightDimension: .absolute(170)), subitems: [myItem])
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                

                
                return section
                
            }
            
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
    }
   
    //MARK: - Main Section Layout
    func layoutCells() -> UICollectionViewCompositionalLayout {
     
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
                
            case 0:

                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.43), heightDimension: .absolute(220)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec2, alignment: .top)
//                header.pinToVisibleBounds = true
                section.boundarySupplementaryItems = [header]
                
                return section
        
                
            case 1:
        
                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.43), heightDimension: .absolute(220)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec3, alignment: .top)
               
//                header.pinToVisibleBounds = true

                section.boundarySupplementaryItems = [header]
                
                return section
                
                
            
            case 2:
                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.43), heightDimension: .absolute(220)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec0, alignment: .top)
               
//                header.pinToVisibleBounds = true

                section.boundarySupplementaryItems = [header]
                
                return section
                
                
                
            case 3:
                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.90), heightDimension: .absolute(235)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec4, alignment: .top)
               
//                header.pinToVisibleBounds = true

                section.boundarySupplementaryItems = [header]
                
                return section
                
                
         
        
                
                
            default:
                let myItem = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(120), heightDimension: .absolute(170)), subitems: [myItem])
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                

                
                return section
                
            }
            
        }
        
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


//MARK: - Extension
extension HomeViewController: UICollectionViewDataSource {
    
    //select cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
            //top collectionview
        case subsCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sec1", for: indexPath) as! Section1CollectionViewCell
            
            cell.isSelected = true

            print("hi")
            if let movieData = MyMovieDataModel.streamingPlatform?[indexPath.item] {
                
                print("Selected Service \(movieData.streamingServiceName)")
                
                if let selectedOTT = movieData.streamingServiceName {
                    fetchOTTtvShow(ottName: "\(selectedOTT)")
                    fetchOTTmovie(ottName: "\(selectedOTT)")
                    homeCollectionViews.reloadData()
                }
                
                
            }

  
          //main collectionview
        case homeCollectionViews:
            
            
            switch indexPath.section {
                
            case 0:
                
                
                var selectedController = MovieDetailViewController()
                
                //pass the movie ID
                if let movieDataId = FinalDataModel.ottMovie?[indexPath.item].movieID {
                    selectedController.movieId = movieDataId
                    selectedController.fetchMovieDetails(movieID: movieDataId)
                }
                
                if let tmdbDataID = FinalDataModel.ottMovie?[indexPath.item].tmdbID {
                    selectedController.fetchMoreLikeThis(tmdbID: "\(tmdbDataID)")
                }
               
                //pass movie data
//                if let jsonData = MyMovieDataModel.upcoming?.results {
//
//                    selectedController.passedData = jsonData[indexPath.item]
//
//                }
                    
                navigationController?.pushViewController(selectedController, animated: true)
                
                
                //change case1 to tv show for displaying TV shows
            case 1:
                var selectedController = TVDetailViewController()
                
                //pass the movie ID
                if let movieDataId = FinalDataModel.ottShow?[indexPath.item].showID {
                    selectedController.showId = movieDataId
                    selectedController.fetchMovieDetails(movieID: movieDataId)
                }
               //pass tmdb ID
                if let tmdbDataID = FinalDataModel.ottShow?[indexPath.item].tmdbID {
                    selectedController.tmdbID = "\(tmdbDataID)"
                    selectedController.fetchMoreTVLikeThis(tmdbID: "\(tmdbDataID)")
                }
               
                    
                navigationController?.pushViewController(selectedController, animated: true)
                
          
            case 2:
                
                if isMovieSelected == true {
                    
                    var selectedController = MovieDetailViewController()
                    
                    //pass the movie ID
                    if let movieDataId = FinalDataModel.worldWide?[indexPath.item].movieID {
                        selectedController.movieId = movieDataId
                        selectedController.fetchMovieDetails(movieID: movieDataId)
                    }
                    
                    if let tmdbDataID = FinalDataModel.worldWide?[indexPath.item].tmdbID {
                        selectedController.fetchMoreLikeThis(tmdbID: "\(tmdbDataID)")
                    }
                   
                        
                    navigationController?.pushViewController(selectedController, animated: true)
                    
                    
                } else {
                    
                    var selectedController = TVDetailViewController()
                    
                    //pass the movie ID
                    if let movieDataId = FinalDataModel.worldWide?[indexPath.item].showID {
                        selectedController.showId = movieDataId
                        selectedController.fetchMovieDetails(movieID: movieDataId)
                    }
                   //pass tmdb ID
                    if let tmdbDataID = FinalDataModel.worldWide?[indexPath.item].tmdbID {
                        selectedController.tmdbID = "\(tmdbDataID)"
                        selectedController.fetchMoreTVLikeThis(tmdbID: "\(tmdbDataID)")
                    }
                   
 
                        
                    navigationController?.pushViewController(selectedController, animated: true)
                    
                }
                
        
                
                
            case 3:
                
                var selectedController = MovieDetailViewController()
                
                //pass the movie ID
                
                if isIndiaSelected == true {
                    
                    
                    if let upcomingData = FinalDataModel.upcomingMovies {
                        
                        if let mydata = upcomingData[0].movies?[indexPath.item] {
                            if let safeTMDBid = mydata.id {
                                
                                selectedController.tmdbID = "\(safeTMDBid)"
                                selectedController.fetchMovieDetailswithTMDBid(tmdbID: "\(safeTMDBid)")
                                
                                print("this is new movieID \(safeTMDBid)")
                                
                            }
                           
                        }
                        
                       
                    }
                    
                } else {
                    
                    
                    if let upcomingData = FinalDataModel.upcomingMovies {
                        
                        if let mydata = upcomingData[1].movies?[indexPath.item] {
                            if let safeTMDBid = mydata.id {
                                
                                selectedController.tmdbID = "\(safeTMDBid)"
                                selectedController.fetchMovieDetailswithTMDBid(tmdbID: "\(safeTMDBid)")
                                
                                print("this is new movieID \(safeTMDBid)")
                                
                            }
                           
                        }
                        
                       
                    }
                    
                }
          
                
                
             
                //pass movie data
//                if let jsonData = MyMovieDataModel.upcoming?.results {
//
//                    selectedController.passedData = jsonData[indexPath.item]
//
//                }
                    
                navigationController?.pushViewController(selectedController, animated: true)
                
              
            default:
                print("something tapped")
                
            }
            
            
//            //cv2 start
//            if indexPath.section == 1 {
//
//                var plusPosition = myLogos.count
//
//                if indexPath.item == 1 {
//    //                myLogos.append(Logos(posterImage: UIImage(named: "hbomax")!))
//
//                    myLogos.insert(contentsOf: moreLogos, at: 0)
//                    homeCollectionViews.reloadData()
//                } else if indexPath.item == 0 {
//
//                    var selectedController = ChooseSubsViewController()
//                    navigationController?.pushViewController(selectedController, animated: true)
//
//                }
//            }
            //cv2 end
        
        default:
            print("hello")
            
        }
 
       
    }
    
    //number of sections
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case subsCollectionView:
         
            return 1
        case homeCollectionViews:
            return 4
            
        default:
            return 1
        }
        
    }
    
    //number of items per section
    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        switch collectionView {
//            case
//
//        }
//           return 100
//       }
    
    //number of items
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
     
        if collectionView == subsCollectionView {
            
            return MyMovieDataModel.streamingPlatform?.count ?? 1
        } else if collectionView == homeCollectionViews{
            
            switch section {
                
                //change this
            case 0:
               
                if let finalCount = FinalDataModel.ottMovie?.count {
                    
                    
                    if finalCount >= 15 {
                        return 15
                    } else {
                        return finalCount
                    }
                    
                }
               
                
            case 1:
                
                return FinalDataModel.ottShow?.count ?? 3 
                
//                if FinalDataModel.ottShow?.count ?? 3 >= 15 {
//                    return 15
//                } else {
//                    return 9
//                }
                
                //worldwide trending
            case 2:
                
                if let finalWWcount = FinalDataModel.worldWide?.count {
                    
                    if finalWWcount >= 15 {
                        return 15
                    } else {
                        return finalWWcount
                    }
                    
                }
                
            
                
            case 3:
                if isIndiaSelected == true {
                    
                    if let safeIndiaMovie = indiaMovies?.count {
                        
                        return safeIndiaMovie
                        
                    }
                      
                     
                    
                }
                   
                 else if isIndiaSelected == false{
                     if let safeUSAmovie = usaMovies?.count {
                         
                         return safeUSAmovie
                     }
                     
                     
                }
               
            
            default:
                return 1
                
            }
        }
            
            
        
          
            return 1
     
        //section ends here
    }
    //configure the cel
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        switch collectionView {
          
        //streaming golas are here
        case subsCollectionView:
            switch indexPath.section {
                
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sec1", for: indexPath) as! Section1CollectionViewCell


                if let movieData = MyMovieDataModel.streamingPlatform?[indexPath.item] {
                    
                    cell.setupStreamCells(fromData: movieData)
                }
              
                cell.selectedSub.makeItGolGol()
                
               
//                cell.setupLogos(fromData: myLogos[indexPath.item])
                
                return cell
                
            default:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sec1", for: indexPath) as! Section1CollectionViewCell


                
                cell.setupLogos(fromData: myLogos[indexPath.item])
                
                return cell
                
            }
        
        //case 2
        case homeCollectionViews:
            
            
            switch indexPath.section {
                
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sec2", for: indexPath) as! Section2CollectionViewCell
                
                if let myMovieDataStuff = FinalDataModel.ottMovie {
                    
                    cell.setupOTTmovie(fromData: myMovieDataStuff[indexPath.item])
                    
                }
                
                return cell
                
            case 1:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sec3", for: indexPath) as! Section3CollectionViewCell
                
                if let myTopRatedMovieStuff =   FinalDataModel.ottShow {
                    
                    cell.setupCell(fromData: myTopRatedMovieStuff[indexPath.item])
                }
                
                return cell
                
            
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendCell", for: indexPath) as! TrendingWorldCollectionViewCell
                
                if let myMovieDataStuff = FinalDataModel.worldWide {
                    
                    cell.setupCell(fromData: myMovieDataStuff[indexPath.item])
                    
                }
                
                return cell
                
        
            
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingMov", for: indexPath) as! UpcomingMoviesCollectionViewCell
                
              
                
//                if let upcomingData = FinalDataModel.upcomingMovies {
//
//                    if let mydata = upcomingData[0].movies?[indexPath.item] {
//
//                        cell.setupCell(fromData: mydata)
//                    }
//
//
//                }
                print("Usa movies are \(usaMovies?[0].title)")
                if isIndiaSelected == true {
                    
                    if let saveIndiaMovies = indiaMovies?[indexPath.item] {
                     
                        cell.setupCell(fromData: saveIndiaMovies)
                    }
                } else {
                    
                    if let saveIndiaMovies = usaMovies?[indexPath.item] {
                     
                        cell.setupCell(fromData: saveIndiaMovies)
                    }
                    
                }
                
               
                
               
                
                return cell
                
            
                
                
                
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sec1", for: indexPath) as! Section1CollectionViewCell
                
                
                return cell
                
                
            }
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sec1", for: indexPath) as! Section1CollectionViewCell
            
            return cell
            
        }
  
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch collectionView {
            
        case subsCollectionView:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sec2Header", for: indexPath) as! Section2CRV
            header.headerText.text = "🫧 Select One"
            
            return header
            
        
        case homeCollectionViews:
            
            if indexPath.section == 0 {
                
                
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sec2Header", for: indexPath) as! Section2CRV
               
               
                return header
                
            } else if indexPath.section == 1 {
                
                
                

                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sec3Header", for: indexPath) as! Section3CRV
               
               
                return header
             
                
            } else if indexPath.section == 2 {
                
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "worldTrend", for: indexPath) as! TrendingtCollectionReusableView
               
                header.movieDelegate = self
                return header
             
                
                
            } else if indexPath.section == 3 {
                
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "booksHead", for: indexPath) as! BooksHeaderCRV
                
                header.conutryDelegate = self
               
               
                return header
             
                
                
            }
            
        
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sec2Header", for: indexPath) as! Section2CRV
           
           
            return header
            
            
        }
        
  
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sec2Header", for: indexPath) as! Section2CRV
       
       
        return header
        
        
        
       
    }
    
    
}


extension HomeViewController: seeAllTapped {
    func didTapSeeAllBtn(sender: UIButton) {
        let addSubController = ChooseSubsViewController()
        navigationController?.pushViewController(addSubController, animated: true)
    }
    
    
}

extension HomeViewController: TVshowTap, CountrySelection {
    func indiaSelected() {
        self.isIndiaSelected = true
        homeCollectionViews.reloadData()
    }
    
    func usaSelected() {
        self.isIndiaSelected = false
        homeCollectionViews.reloadData()
    }
    
    func movieSelected() {
        //TODO: - Cal movie function here
        self.isMovieSelected = true
        fetchWorldWideTrending()
    }
    
    func tvShowSelected() {
        //TODO: - Call tv show function here
        self.isMovieSelected = false
        fetchWorldWideTVTrending()
    }
    
    
    
    
}
