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
    var optionsLogos = [
    
        TextLogos(posterImage: UIImage(named: "hbomax")!, postername: "HBOmax"),
        TextLogos(posterImage: UIImage(named: "prime video")!, postername: "Prime Video"),
        TextLogos(posterImage: UIImage(named: "hotstar")!, postername: "Hotstar"),
        TextLogos(posterImage: UIImage(named: "zee5")!, postername: "Zee5"),
        TextLogos(posterImage: UIImage(named: "prime video")!, postername: "Prime Video"),
    
    ]

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
       
       
        // Do any additional setup after loading the view.
    }

    
    @IBAction func backBtnTap(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
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
                    print("Similar Data is here \(movieData) and \(movieData.results?[0].posterPath)")
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
            
            
            //group size
            let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(500)), subitems: [myItem])
            
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
//                header.pinToVisibleBounds = true
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

extension MovieDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return FinalDataModel.movieDetails?.providerOffers?.providerOffersIN?.flatrate?.count ?? 1
        case 2:
            if FinalDataModel.movieDetails?.castAndCrew?.count ?? 12 >= 12 {
                return 12
            } else {return 6}
        case 3:
            return FinalDataModel.similarMovies?.results?.count ?? 1
            
            
        default:
            return 1
        }
        
    }
    
    //MARK: - Headers CV
    
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
   
    //MARK: - Did select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            
        case 2:
            var selectedController = ActorDetailViewController()
            
            if let actorDataId = FinalDataModel.movieDetails?.castAndCrew?[indexPath.item].id {
                selectedController.actorId = "\(actorDataId)"
                selectedController.fetchActorDetail(actor: "\(actorDataId)")            }
           
            
            navigationController?.pushViewController(selectedController, animated: true)
            
            
        case 3:
            var selectedController = MovieDetailViewController()
            
            //TODO: - More Like This
            //pass tmdbID to a new function to fetch movies
            //same data model
            //pass tmdbid to fetch more like this
            
            if let tmdbDataID = FinalDataModel.similarMovies?.results?[indexPath.item].id {
                selectedController.fetchMovieDetailswithTMDBid(tmdbID: "\(tmdbDataID)")
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
           
            if let movieData = FinalDataModel.movieDetails {
                print("movie data is here")
                cell.setupCell(fromData: movieData)
               
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
                
                if let cast = castDetails.castAndCrew {
                    cell.setupCell(fromData: cast[indexPath.item])
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
