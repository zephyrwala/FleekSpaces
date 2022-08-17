//
//  SearchViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 13/06/22.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UISearchBarDelegate {

    let sec2 = "sec2ID"
    @IBOutlet weak var recentSearchCollectionView: UICollectionView!
    @IBOutlet weak var recentSearchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredData = [UResult]()
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
//        recentSearchView.isHidden = false
//        if let mainData = MyMovieDataModel.upcoming?.results {
//            filteredData = mainData
//        }
        recentSearchView.isHidden = true
        
//        setupRecentSearchCollectionView()
//        setupCollectionView()
        // Do any additional setup after loading the view.
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
        recentSearchCollectionView.collectionViewLayout = recentLayoutCells()
        
        
        //register cells
        recentSearchCollectionView.register(UINib(nibName: "Section2CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "sec2")
        
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
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
//                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
//                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(35)), elementKind: self.newTOpID, alignment: .top)
//                section.boundarySupplementaryItems = [header]
                
                return section
                
                
            default:
                
                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(300)), subitems: [myItem])
                
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
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(270)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
//                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
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
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(300)), subitems: [myItem])
                
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
    
    
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("\(searchBar.text) is entered tap")
        if let safeText = searchBar.text {
            
            setupCollectionView()
            fetchResults(searchWord: safeText)
        }
    }
    //MARK: - Searchbar stuff
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        recentSearchView.isHidden = true
        filteredData = []
        guard let mainData = MyMovieDataModel.upcoming?.results else {return}
        if let looper = MyMovieDataModel.upcoming?.results {
            
            for result in looper  {
                if let textFilter = result.title {
                    
                    if textFilter.lowercased().contains(searchText.lowercased()) {
                        
                        filteredData.append(result)
                    }
                    
                   
                }
                
            }
            
            searchCollectionView.reloadData()
            
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
            header.headerText.text = "Recent Search"
           
           
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
            var selectedController = MovieDetailViewController()
            if let jsonData = MyMovieDataModel.upcoming?.results {
    
                selectedController.passedData = jsonData[indexPath.item]
    
            }
            
//            selectedController.passedData = filteredData[indexPath.item]
            
                
            navigationController?.pushViewController(selectedController, animated: true)
            
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
            return MyMovieDataModel.upcoming?.results?.count ?? 3
            
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sec2", for: indexPath) as! Section2CollectionViewCell
            
            if let myMovieDataStuff = FinalDataModel.worldWide {
                
                cell.setupCell(fromData: myMovieDataStuff[indexPath.item])
                
            }
            
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
