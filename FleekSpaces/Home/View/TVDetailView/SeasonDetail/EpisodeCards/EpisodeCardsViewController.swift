//
//  EpisodeCardsViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 29/07/22.
//

import UIKit

class EpisodeCardsViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var episodeCount: UILabel!
    var getSeasonID : String?
    var getSeasonNo: String?
    var getSeasonTMDBid: String?
    @IBOutlet weak var episodeCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("This is the show ID - \(getSeasonID)")
        print("This is the season ID - \(getSeasonNo)")
        if let finalShowId = getSeasonID {
            if let seasonNums = getSeasonNo {
                if let seasonTMDbs = getSeasonTMDBid {
                    
                    fetchEpisodeDetails(showId: finalShowId, seasonNo: seasonNums, tmdb_season_id: seasonTMDbs)
                }
            }
           
        }
        
        if let episodeNumber = FinalDataModel.episodesList?.episodes?.count {
            
            self.episodeCount.text = "Episodes \(episodeNumber)"
        }
       
        setupEpisodeCollectionView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    //MARK: - Setup Collection View
    
    func setupEpisodeCollectionView() {
        
        episodeCollectionView.delegate = self
        episodeCollectionView.dataSource = self
        episodeCollectionView.collectionViewLayout = layoutCells()
      
        
        //register cells
        
        episodeCollectionView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellWithReuseIdentifier: "episodeCell")
        
        
    }
    
    
 //MARK: - Get episode data
    
    //MARK: - Fetch Movie Detail
    func fetchEpisodeDetails(showId: String, seasonNo: String, tmdb_season_id: String) {
        
        guard let finalMovieId = getSeasonID else {
            return
        }

        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_season_details?show_id=\(showId)&season_number=\(seasonNo)&season_tmdb_id=\(tmdb_season_id)")
        
        
        network.theBestNetworkCall(EpisodesList.self, url: url) { myMovieResult, yourMessage in
            
          
            switch myMovieResult {
                
            
            case .success(let movieData):
                print("Episode Data is here \(movieData) and \(movieData.name)")
                DispatchQueue.main.async {
                FinalDataModel.episodesList = movieData
                    print("episode data is \(movieData.synopsies)")
                
                
              
                self.episodeCollectionView.reloadData()
                
            }
               
            case .failure(let err):
                print("Failed to show fetch data \(err)")
                
            }
            
        }
    
    }
    
    //MARK: - Compositional layout
    func layoutCells() -> UICollectionViewCompositionalLayout {
        
        
     
        //start
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
                
            case 0:
           
                if UIDevice.current.userInterfaceIdiom == .pad {
                    let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
                    
                        myItem.contentInsets.trailing = 2
                        myItem.contentInsets.bottom = 10
                        myItem.contentInsets.leading = 2
                        myItem.contentInsets.top = 10
                        
                    
                        //group size
                        let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(175)), subitems: [myItem])
                        
                        //section size
                        
                        let section = NSCollectionLayoutSection(group: myGroup)
                    

                    
                    return section
                } else {
                    let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                    
                        myItem.contentInsets.trailing = 2
                        myItem.contentInsets.bottom = 10
                        myItem.contentInsets.leading = 2
                        myItem.contentInsets.top = 10
                        
                    
                        //group size
                        let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(175)), subitems: [myItem])
                        
                        //section size
                        
                        let section = NSCollectionLayoutSection(group: myGroup)
                    

                    
                    return section
                }
         
                
                
            case 1:
                
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 1
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 1
                
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
//                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
//                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(45)), elementKind: self.sec1, alignment: .top)
//
//                section.boundarySupplementaryItems = [header]
                
                
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

}


extension EpisodeCardsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FinalDataModel.episodesList?.episodes?.count ?? 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedController = DetailEpisodeViewController()
        
        guard let showID = FinalDataModel.episodesList?.showID else {return}
        guard let seasonNumber = FinalDataModel.episodesList?.seasonNumber else {return}
        guard let episodeNumber = FinalDataModel.episodesList?.episodes?[indexPath.item].episodeNumber else {return}
        guard let seasTMDBID = UserDefaults.standard.string(forKey: "seasonTMDBs") else {return}
      
        selectedController.getEpisodeData(showId: showID, seasonNo: "\(seasonNumber)", episodeNo: "\(episodeNumber)")
        
        print("Episode call done")
        navigationController?.pushViewController(selectedController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episodeCell", for: indexPath) as! EpisodeCell
        
        if let episodeData = FinalDataModel.episodesList?.episodes {
           
            cell.setupCell(fromData: episodeData[indexPath.item])
        }
       
        
        return cell
    }
    
    
}
