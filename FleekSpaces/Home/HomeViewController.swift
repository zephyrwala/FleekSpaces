//
//  HomeViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 01/06/22.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {

   
    @IBOutlet weak var subsCollectionHts: NSLayoutConstraint!

    var scrollSize = 0.0
    var isMovieSelected = true
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var visualBlurHt: NSLayoutConstraint!
    @IBOutlet weak var visualBlurLayer: UIVisualEffectView!
    @IBOutlet weak var discoverView: UIView!
    @IBOutlet weak var subsCollectionView: UICollectionView!
    @IBOutlet weak var collectionHt: NSLayoutConstraint!
    @IBOutlet weak var testViewHt: NSLayoutConstraint!
    @IBOutlet weak var addBtnChoose: UIButton!
    @IBOutlet weak var testView: UIView!
    
    
    @IBOutlet weak var homeCollectionViews: UICollectionView!
    //category ID
    let sec1 = "sec1ID"
    let sec2 = "sec2ID"
    let sec3 = "sec3ID"
    let sec0 = "sec0ID"
    let sec4 = "sec4ID"
    let newTOpID = "Top"
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
        
        self.testViewHt.constant = 250
        self.collectionHt.constant = 250
        self.subsCollectionHts.constant = 110
        self.testView.layoutIfNeeded()
        fetchNewStreaming()
//        fetchNowPlaying()
//        fetchTopRated()
        fetchTVshows()
        fetchWorldWideTrending()
        setupBtn()
        setupCollectionView()
        setupSubsCollectionView()
     
   
       
                // Do any additional setup after loading the view.
    }
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        let controller = SearchViewController()
        navigationController?.pushViewController(controller, animated: true)
        
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
        
        //register the header
        homeCollectionViews.register(UINib(nibName: "Section1HeaderCRV", bundle: nil), forSupplementaryViewOfKind: self.sec1, withReuseIdentifier: "sec1Header")
        homeCollectionViews.register(UINib(nibName: "Section2CRV", bundle: nil), forSupplementaryViewOfKind: self.sec2, withReuseIdentifier: "sec2Header")
        homeCollectionViews.register(UINib(nibName: "Section3CRV", bundle: nil), forSupplementaryViewOfKind: self.sec3, withReuseIdentifier: "sec3Header")
        homeCollectionViews.register(UINib(nibName: "TrendingtCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: self.sec0, withReuseIdentifier: "worldTrend")
        homeCollectionViews.register(UINib(nibName: "BooksHeaderCRV", bundle: nil), forSupplementaryViewOfKind: self.sec4, withReuseIdentifier: "booksHead")
        
     
        
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
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.43), heightDimension: .absolute(220)), subitems: [myItem])
                
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
            
            switch indexPath.section {
                
            case 0:
                if indexPath.item == 0 {
                    
                    var selectedController = ChooseSubsViewController()
                    navigationController?.pushViewController(selectedController, animated: true)
                    
                    
                }
              
            default:
                print("something tapped")
                
            }

  
          //main collectionview
        case homeCollectionViews:
            
            
            switch indexPath.section {
                
            case 0:
                
                
                var selectedController = MovieDetailViewController()
                
                //pass the movie ID
                if let movieDataId = FinalDataModel.worldWide?[indexPath.item].movieID {
                    selectedController.movieId = movieDataId
                    selectedController.fetchMovieDetails(movieID: movieDataId)
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
                if let jsonData = MyMovieDataModel.tvshow?.results {

                    selectedController.tvPassedData = jsonData[indexPath.item]

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
                   
                    //pass movie data
    //                if let jsonData = MyMovieDataModel.upcoming?.results {
    //
    //                    selectedController.passedData = jsonData[indexPath.item]
    //
    //                }
                        
                    navigationController?.pushViewController(selectedController, animated: true)
                    
                    
                } else {
                    
                    var selectedController = TVDetailViewController()
                    
                    //pass the movie ID
                    if let movieDataId = FinalDataModel.worldWide?[indexPath.item].showID {
                        selectedController.showId = movieDataId
                        selectedController.fetchMovieDetails(movieID: movieDataId)
                    }
                   
                   
                    //pass movie data
    //                if let jsonData = MyMovieDataModel.upcoming?.results {
    //
    //                    selectedController.passedData = jsonData[indexPath.item]
    //
    //                }
                        
                    navigationController?.pushViewController(selectedController, animated: true)
                    
                }
                
        
                
                
            case 3:
                
                var selectedController = BooksDetailViewController()
               

                    selectedController.passedData = myLogos[indexPath.item]

                
                    
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
        } else {
            
            switch section {
                
                //change this
            case 0:
               
                if FinalDataModel.worldWide?.count ?? 3 >= 15 {
                    return 15
                } else {
                    return 9
                }
                
            case 1:
                return MyMovieDataModel.tvshow?.results?.count ?? 3
                
                //worldwide trending
            case 2:
                if FinalDataModel.worldWide?.count ?? 3 >= 15 {
                    return 15
                } else {
                    return 9
                }
            
                //books
            case 3:
                return myLogos.count
            
            default:
                return 1
                
            }
        }
            
            
        
          
            
     
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
                
                if let myMovieDataStuff = FinalDataModel.worldWide {
                    
                    cell.setupCell(fromData: myMovieDataStuff[indexPath.item])
                    
                }
                
                return cell
                
            case 1:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sec3", for: indexPath) as! Section3CollectionViewCell
                
                if let myTopRatedMovieStuff = MyMovieDataModel.tvshow?.results {
                    
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "books", for: indexPath) as! BookCollectionViewCell
                
                cell.setupCell(fromData: myLogos[indexPath.item])
                
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
            header.headerText.text = "OTT Platforms"
           
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

extension HomeViewController: TVshowTap {
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
