//
//  TVDetailViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 20/06/22.
//

import UIKit

class TVDetailViewController: UIViewController, UICollectionViewDelegate, episodeBtnTap, likeBtnTap, dislikeBtnTap {
    
    
    var tvShowDetail: TVshowDetail?
  
    

    
    
    
    
    //protocols
    func didTapEpisodeBtn(sender: UIButton) {
        let controller = SeasonsViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    func checkSignIn() {
        
        if  FirebaseManager.shared.auth.currentUser == nil {
           loginPrompt()
        } else {
           
            
            
            
        }
    }
    
    

    
    //MARK: - Login Prompt
    
    func loginPrompt() {
        
        let actionSheet = UIAlertController(title: "Must Login!", message: "Hey Bro! You must login to add likes and dislikes for this section!", preferredStyle: .alert)
        
        
        actionSheet.addAction(UIAlertAction(title: "Log In", style: .default, handler: { [weak self] _ in
            
           
            
            let controller = LoginVC()
                
              
//            self?.navigationController?.pushViewController(controller, animated: true)
            
            self?.present(controller, animated: true)
//            self?.present(controller, animated: true)
            
          
            
        }))
        
    
        
        present(actionSheet, animated: true)
        
        
    }

    let defaults = UserDefaults.standard
    var tmdbID: String?
    var showId: String?
    let sec1 = "sec1ID"
    let sec2 = "sec2ID"
    let sec3 = "sec3ID"
    let sec0 = "sec0ID"
    var passedData: UResult?
    var tvPassedData: TVResult?

    
    
    @IBOutlet weak var tvCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let safeTMDBId = tmdbID {
            fetchMoreTVLikeThis(tmdbID: safeTMDBId)
        }
        print("This is show id: \(showId)")
        print("This is tmdb tv id: \(tmdbID)")
//        fetchMovieDetails(movieID: showId!)
       
        setupCollectionView()
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnTap(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    
  //MARK: - Fetch tv show with tmdb id
    
    func fetchTVDetailswithTMDBid(tmdbID: String) {
        
//        guard let finalMovieId = showId else {
//            return
//        }

      
        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_tv_show_details?tmdb_id=\(tmdbID)")
        
        
        network.theBestNetworkCall(TVshowDetail.self, url: url) { myMovieResult, yourMessage in
            
          
            switch myMovieResult {
                
            
            case .success(let movieData):
                print("TV tmdb Show Data is here \(movieData) and \(movieData.title)")
                DispatchQueue.main.async {
                FinalDataModel.showDetails = movieData
                print("tmdb passed data is \(movieData.title)")
                
                
              
                self.tvCollectionView.reloadData()
                
            }
               
            case .failure(let err):
                print("Failed to show fetch tmdb data \(err)")
                
            }
            
        }
        
        
    
    }
    
    //MARK: - Fetch Movie Detail
    func fetchMovieDetails(movieID: String) {
        
        guard let finalMovieId = showId else {
            return
        }

      
        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_tv_show_details?TVshow_id=\(movieID)")
        
        
        network.theBestNetworkCall(TVshowDetail.self, url: url) { myMovieResult, yourMessage in
            
          
            switch myMovieResult {
                
            
            case .success(let movieData):
                print("TV Show Data is here \(movieData) and \(movieData.title)")
                DispatchQueue.main.async {
                FinalDataModel.showDetails = movieData
                print("passed data is \(movieData.title)")
                
                
              
                self.tvCollectionView.reloadData()
                
            }
               
            case .failure(let err):
                print("Failed to show fetch data \(err)")
                
            }
            
        }
        
        
    
    }
    
    
    //MARK: - Setup Collectionview
    
    
    func setupCollectionView() {
        
        tvCollectionView.delegate = self
        tvCollectionView.dataSource = self
        tvCollectionView.collectionViewLayout = layoutCells()
        //register cell
        tvCollectionView.register(UINib(nibName: "MovieInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieInfo")
        tvCollectionView.register(UINib(nibName: "MoviePlayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "moviePDF")
        tvCollectionView.register(UINib(nibName: "MovieCastCell", bundle: nil), forCellWithReuseIdentifier: "movCast")
        tvCollectionView.register(UINib(nibName: "MoreLikeThisCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "moreLike")

        //register header
        tvCollectionView.register(UINib(nibName: "Section2CRV", bundle: nil), forSupplementaryViewOfKind: self.sec1, withReuseIdentifier: "sec2Header")
        tvCollectionView.register(UINib(nibName: "MovieCastCRV", bundle: nil), forSupplementaryViewOfKind: self.sec2, withReuseIdentifier: "casts")
        tvCollectionView.register(UINib(nibName: "MoreLikeThisCRV", bundle: nil), forSupplementaryViewOfKind: self.sec3, withReuseIdentifier: "moreH")
        
 
    }

    
 
    
    //MARK: - Fetch More Like This
    
    func fetchMoreTVLikeThis(tmdbID: String){
        
        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_similar_tv_shows?tmdb_id=\(tmdbID)")
        
        network.theBestNetworkCall(SimilarTV.self, url: url) { mySimilarMovieResult, yourMessage in
            
            
            switch mySimilarMovieResult {
                
                
            case .success(let movieData):
                
                DispatchQueue.main.async {
                    
                    FinalDataModel.similarTV = movieData
                    self.tvCollectionView.reloadData()
                    print("Similar TV Data is here \(movieData) and \(movieData.results?[0].posterPath)")
                }
                
            case .failure(let err):
                print("Failed to fetch similar movie data : \(err)")
                
            }
            
            
        }
        
    }

    
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
            
            
            //group size
            let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(550)), subitems: [myItem])
            
            //section size
            
            let section = NSCollectionLayoutSection(group: myGroup)
            
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            
//            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec1, alignment: .top)
//            header.pinToVisibleBounds = true
//            section.boundarySupplementaryItems = [header]
            
            
            return section
                
                
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
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.42), heightDimension: .absolute(240)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)

                section.orthogonalScrollingBehavior = .groupPaging
//
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec2, alignment: .top)
                header.pinToVisibleBounds = true
                section.boundarySupplementaryItems = [header]
                
                
                return section
                
            case 3:
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
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
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
             
                
                
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
    
    func didTapdisikeButtonTv(_ cell: MovieInfoCollectionViewCell) {
       
            
       
        
        
        cell.likeBtn.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        
        cell.dislikeBtn.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
        
        cell.dislikeBtn.tintColor = .systemPink
          
          print("Dislike tapp")
        
    }
    
    
    func didTapLikeButtonTv(_ cell: MovieInfoCollectionViewCell) {
//        cell.likeBtn.backgroundColor = .green
        
        if FirebaseManager.shared.auth.currentUser == nil {
            loginPrompt()
        } else if FirebaseManager.shared.auth.currentUser != nil {
            
            addLikes(movieTitle: "The Grudge 3")
            cell.likeBtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            
            cell.dislikeBtn.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
            
            cell.likeBtn.tintColor = .systemTeal
          
            
            //TODO: - Add like network call here
//            addLike()
       
            
        }
        
        print("Like tapp")
        
       
    }
    
    
    func addLikes(movieTitle: String) {
        
    
//        print("This is our URL \(url)")
        let showType = "movie"
        let searchTerm = "obi wan kenobi"
        let format = "The Grudge 3"
        let showId = "af6ea506-a1fb-43b9-ba21-ea3735fb6dc7"
        let posterUrl = "/gBCkf1rk9KyJt9o6wC866BM6WWi.jpg"
        let like = "1"
        let dislike = "0"

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api-space-dev.getfleek.app"
        urlComponents.path = "/activity/add_likes_dislikes/"
        //api-space-dev.getfleek.app/
        urlComponents.queryItems = [
           URLQueryItem(name: "show_type", value: showType),
           URLQueryItem(name: "show_id", value: showId),
           URLQueryItem(name: "posters_url", value: posterUrl),
           URLQueryItem(name: "like", value: like),
           URLQueryItem(name: "title", value: format),
           URLQueryItem(name: "dislike", value: dislike)
        ]

        print(urlComponents.url?.absoluteString)
        print("Clubbed url is ")
        print(urlComponents.url?.absoluteString)
        
        
   //https://api-space-dev.getfleek.app/activity/add_likes_dislikes?show_type=movie&show_id=af6ea506-a1fb-43b9-ba21-ea3735fb6dc7&posters_url=/gBCkf1rk9KyJt9o6wC866BM6WWi.jpg&like=1&title=The%20Grudge%203&dislike=0
        
        
     //https://api-space-dev.getfleek.app/activity/add_likes_dislikes/?show_type=movie&show_id=af6ea506-a1fb-43b9-ba21-ea3735fb6dc7&posters_url=/gBCkf1rk9KyJt9o6wC866BM6WWi.jpg&like=1&title=The Grudge 3&dislike=0
        
        
        guard let myTOken = defaults.string(forKey: "userToken") else {return}
        print("My token is \(myTOken)")
        guard let myUrl = urlComponents.url else {return}
        
        let network = NetworkURL()
        network.tokenCalls(AddLike.self, url: myUrl, token: myTOken) { myResults, yourMessage in
                
            
            switch myResults {
                
                
                
            case .success(let likes):
                print("result is \(likes.title) \(yourMessage) \(likes)")
                
            case .failure(let err):
                print("We have error \(err)")
                
                
                
                
            }
            
            
        }
        
        
        
        
        
    }

}


extension TVDetailViewController: UICollectionViewDataSource {
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            
        case 2:
       
            var selectedController = ActorDetailViewController()
            
            
            if let actorDataId = FinalDataModel.showDetails?.castAndCrew?[indexPath.item].id {
                selectedController.actorId = "\(actorDataId)"
                selectedController.fetchActorDetail(actor: "\(actorDataId)")
                
                print("This is the TV actor ID here: \(actorDataId)")
                
                
            }
            
            navigationController?.pushViewController(selectedController, animated: true)
            
        case 3:
            var selectedController = TVDetailViewController()
//            if let jsonData = MyMovieDataModel.upcoming?.results {
//
//                selectedController.passedData = jsonData[indexPath.item]
//
//            }
            
            //pass data to more like this tc
            
            if let tmdbDataID = FinalDataModel.similarTV?.results?[indexPath.item].id {
                selectedController.fetchTVDetailswithTMDBid(tmdbID: "\(tmdbDataID)")
                selectedController.tmdbID = "\(tmdbDataID)"
                print("TMDB wala id is \(tmdbDataID)")
            }
            navigationController?.pushViewController(selectedController, animated: true)
        
            
        default:
        
            print("default tap")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return FinalDataModel.showDetails?.providerOffers?.providerOffersIN?.flatrate?.count ?? 1
        case 2:
            return FinalDataModel.showDetails?.castAndCrew?.count ?? 1
        case 3:
            return FinalDataModel.similarTV?.results?.count ?? 1
            
            
        default:
            return 1
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
           
        case 1:
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sec2Header", for: indexPath) as! Section2CRV
            header.headerText.text = "Streaming Platforms"
           
            return header
        
        case 2:
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "casts", for: indexPath) as! MovieCastCRV
            return header
            
        case 3:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "moreH", for: indexPath) as! MoreLikeThisCRV
            return header
            
        
            
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sec2Header", for: indexPath) as! Section2CRV
            header.headerText.text = "Streaming Platforms"
           
            return header
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieInfo", for: indexPath) as! MovieInfoCollectionViewCell
           
            cell.episodeDelegate = self
            cell.likeBtnDelegate = self
            cell.dislikeBtnDelegate = self
            
//            if let movieData = tvPassedData {
//                cell.setupTVCell(fromData: movieData)
//
//            }
            
            if let showData =  FinalDataModel.showDetails {
                
                cell.setupTVShowDetail(fromData: showData)
                
            }
            
           
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviePDF", for: indexPath) as! MoviePlayCollectionViewCell
//            cell.setupCell(fromData: optionsLogos[indexPath.item])
            if let streamData = FinalDataModel.showDetails?.providerOffers?.providerOffersIN?.flatrate?[indexPath.item] {
                
                cell.setupTVStreaming(fromData: streamData)
            }
          
            
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movCast", for: indexPath) as! MovieCastCell
//            cell.setupCell(fromData: optionsLogos[indexPath.item])
            
            if let showData =  FinalDataModel.showDetails?.castAndCrew {
                
                cell.setupTVShowCell(fromData: showData[indexPath.item])
                
            }
            
            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreLike", for: indexPath) as! MoreLikeThisCollectionViewCell
            
            if let myMovieDataStuff = FinalDataModel.similarTV?.results {
                
                cell.setupTVMoreLikeThis(fromData: myMovieDataStuff[indexPath.item])
                
            }
            
            return cell
            
        
            
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieInfo", for: indexPath) as! MovieInfoCollectionViewCell
            
            
            return cell
            
            
        }
        
    }
}
