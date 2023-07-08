//
//  SearchViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 13/06/22.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {

    let sec2 = "sec2ID"
    var totalTrending = [Worldwide]()
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var recentSearchCollectionView: UICollectionView!
    @IBOutlet weak var recentSearchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredData = [UResult]()
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        
        setupCollectionView()
        fetchWorldWideTVTrending()
      
        searchController.searchBar.barStyle = .default
        searchController.searchBar.tintColor = .systemTeal
        searchController.searchBar.searchBarStyle = .minimal
        searchBar.becomeFirstResponder()
        recentSearchView.isHidden = false
        
        searchCollectionView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        setupRecentSearchCollectionView()
//        setupCollectionView()
        // Do any additional setup after loading the view.
    }
    
   
    override func viewWillLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func fetchResults(searchWord: String) {
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/shows/search_movies_and_shows?search_query=\(searchWord)") else {return}
        let network = NetworkURL()
        network.theBestNetworkCall([SearchResultElement].self, url: myUrl) { myResult, yourMessage in
            
            switch myResult {
                
            case .success(let searchData):
                FinalDataModel.searchResult =  searchData
                
                DispatchQueue.main.async {
                    self.searchCollectionView.reloadData()
                    
                }
              
                
            case .failure(let err):
                print("failure to fetch")
                
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
                   
    //                self.displayUIAlert(yourMessage: "Movie data \(movieData)")
                    for eachMovie in movieData {
                        
                        
                        self.totalTrending.append(eachMovie)
                        self.recentSearchCollectionView.reloadData()
                        
                    }
                    
                case .failure(let err):
                    print("Failure in TV show fetch")
    //                self.displayUIAlert(yourMessage: "Error \(err)")
                    
                }
            }
      
            
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == recentSearchCollectionView {
            
            let lay = collectionViewLayout as! UICollectionViewFlowLayout
            let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
            
            return CGSize(width:widthPerItem, height:75)
            
        }
     
        return CGSize(width:320, height:175)
    }

    @IBAction func backBtnTap(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func filterTapBtn(_ sender: Any) {
        
//        setupBottomSheetAlert()
        presentModal()
    }
    
    func setupRecentSearchCollectionView() {
        
        recentSearchCollectionView.delegate = self
        recentSearchCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        recentSearchCollectionView.setCollectionViewLayout(layout, animated: true)
        
        //register cells
        recentSearchCollectionView.register(UINib(nibName: "RecentTrendinCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "trendSearch")
        
        //register header
        
        recentSearchCollectionView.register(UINib(nibName: "Section2CRV", bundle: nil), forSupplementaryViewOfKind: self.sec2, withReuseIdentifier: "sec2Header")
        
        
        
    }
    //MARK: - Bottom sheet
    
    private func presentModal() {
        let detailViewController = GenreBottomViewController()
        let nav = UINavigationController(rootViewController: detailViewController)
        // 1
        nav.modalPresentationStyle = .pageSheet

        
        // 2
        if let sheet = nav.sheetPresentationController {

            // 3
            sheet.detents = [.medium(), .large()]

        }
        // 4
        present(nav, animated: true, completion: nil)

    }
    
   
    
    //MARK: - Setup collectionview
    
    func setupCollectionView() {
        
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.collectionViewLayout = layoutCells()
        
        
        //register cells
        searchCollectionView.register(UINib(nibName: "SearchResultCVC", bundle: nil), forCellWithReuseIdentifier: "searchResults")
        
        //register headers
        
        
        
    }
    
    //MARK: - search layout
    func layoutCells() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
                
            case 0:
               
                //item size
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
                    
                    myItem.contentInsets.trailing = 10
                    myItem.contentInsets.bottom = 10
                    myItem.contentInsets.leading = 10
                    myItem.contentInsets.top = 10
                    
                    //group size
                    let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [myItem])
                    
                    //section size
                    
                    let section = NSCollectionLayoutSection(group: myGroup)
                    
     
                    return section
                } else {
                    let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                    
                    myItem.contentInsets.trailing = 10
                    myItem.contentInsets.bottom = 10
                    myItem.contentInsets.leading = 10
                    myItem.contentInsets.top = 10
                    
                    //group size
                    let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [myItem])
                    
                    //section size
                    
                    let section = NSCollectionLayoutSection(group: myGroup)
                    
     
                    return section
                }
            
                
                
            default:
                
                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(210)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                return section
                
            }
            //switch ends here
            
            
        }
        //layout ends here
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
        
        
    }
    
    func recentLayoutCells() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
                
            case 0:
               
                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.20), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuous
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec2, alignment: .top)
//                header.pinToVisibleBounds = true
                section.boundarySupplementaryItems = [header]
                
                return section
                
                
            default:
                
                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                return section
                
            }
            //switch ends here
            
            
        }
        //layout ends here
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
        
        
    }
    
    
 //MARK: - Search button stuff
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("\(searchBar.text) is entered tap")
        if let safeText = searchBar.text {
            if safeText.count > 1 {
                guard let escapeAdd = safeText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
                setupCollectionView()
                fetchResults(searchWord: escapeAdd)
            } else if safeText.count == 0 {
                FinalDataModel.searchResult?.removeAll()
                self.searchCollectionView.reloadData()
            }
            
          
        }
    }
    //MARK: - Searchbar stuff
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        recentSearchView.isHidden = true

        
        if let safeText = searchBar.text {
            
            guard let escapeAdd = safeText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
            if safeText.count == 0 {
                FinalDataModel.searchResult?.removeAll()
                searchCollectionView.reloadData()
            } else {
                setupCollectionView()
                fetchResults(searchWord: escapeAdd)
            }
           
        }
        
        
    }
   

}


extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        
        switch collectionView {
        case recentSearchCollectionView:
         
            return 1
        case searchCollectionView:
            return 1
            
        default:
            return 1
        }
        
    
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
            
        case recentSearchCollectionView:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sec2Header", for: indexPath) as! Section2CRV
            header.headerText.text = "Trending Search"
           
           
            return header
        
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sec2Header", for: indexPath) as! Section2CRV
           
           
            return header
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case searchCollectionView:
            
            guard let contentType = FinalDataModel.searchResult?[indexPath.item].type else {return}
            
            if contentType == "movie" {
                
                var selectedController = MovieDetailViewController()
                if let jsonData = FinalDataModel.searchResult {
        
                    guard let thisTmdbId = jsonData[indexPath.item].tmdbID else {return}
        
                    selectedController.tmdbID = "\(thisTmdbId)"
                    selectedController.fetchMovieDetailswithTMDBid(tmdbID: "\(thisTmdbId)")            }
                
               
                
                    
                navigationController?.pushViewController(selectedController, animated: true)
            } else {
                var selectedController = TVDetailViewController()
                if let jsonData = FinalDataModel.searchResult {
        
                    guard let thisTmdbId = jsonData[indexPath.item].tmdbID else {return}
        
                    selectedController.tmdbID = "\(thisTmdbId)"
                    selectedController.fetchTVDetailswithTMDBid(tmdbID: "\(thisTmdbId)")
                    
                    
                }
                
               
                
                    
                navigationController?.pushViewController(selectedController, animated: true)
                
            }
           
            
        
        
        case recentSearchCollectionView:
           
            if let safeTitle = totalTrending[indexPath.item].title {
//                self.searchBar.text = safeTitle

                guard let escapeAdd = safeTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
                recentSearchView.isHidden = true

                fetchResults(searchWord: escapeAdd)





            }
            
            
//            selectedController.passedData = filteredData[indexPath.item]
            
                
            
            
        default:
            var selectedController = MovieDetailViewController()
    //        if let jsonData = MyMovieDataModel.upcoming?.results {
    //
    //            selectedController.passedData = jsonData[indexPath.item]
    //
    //        }
            
            selectedController.passedData = filteredData[indexPath.item]
            
                
            navigationController?.pushViewController(selectedController, animated: true)
            
            
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case recentSearchCollectionView:
            return totalTrending.count - 9
            
        case searchCollectionView:
            return FinalDataModel.searchResult?.count ?? 4
            
        default:
            return 2
        }
//        if collectionView == recentSearchCollectionView {
//
//            return MyMovieDataModel.upcoming?.results?.count ?? 3
//        } else {
//
//            return filteredData.count
//        }
//
//        if let mySearchCount = MyMovieDataModel.upcoming?.results?.count {
//            return mySearchCount
//        }
//        return filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case recentSearchCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendSearch", for: indexPath) as! RecentTrendinCollectionViewCell
            
//            if let myMovieDataStuff = FinalDataModel.worldWide {
//
////                cell.setupCell(fromData: myMovieDataStuff[indexPath.item])
//
//                let randoms = myMovieDataStuff.shuffled()
//                cell.setupCell(fromData: randoms[indexPath.item])
//            }
            
            let shuffleRandom = totalTrending.shuffled()
            
            cell.setupCell(fromData: shuffleRandom[indexPath.item])
            
            
            return cell
            
        case searchCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchResults", for: indexPath) as! SearchResultCVC
            
            if let myMovieDataStuff = FinalDataModel.searchResult {
    
                cell.setupCell(fromData: myMovieDataStuff[indexPath.item])
    
            }
            
            //TODO: - Undo this
//            cell.setupCell(fromData: filteredData[indexPath.item])
            
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sec2", for: indexPath) as! Section2CollectionViewCell
            
            if let myMovieDataStuff = FinalDataModel.worldWide {
                
                cell.setupCell(fromData: myMovieDataStuff[indexPath.item])
                
            }
            
            return cell
            
            
        }
    
        
    }
    
    
}
