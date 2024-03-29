//
//  SeasonsViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 21/06/22.
//

import UIKit

class SeasonsViewController: UIViewController, UICollectionViewDelegate {
    
    
    @IBOutlet weak var seasonLabel: UILabel!
    let sec1 = "sec1ID"
    let sec2 = "sec2ID"
    let sec3 = "sec3ID"
    let sec0 = "sec0ID"

    @IBOutlet weak var seasonCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        if let seasonCount = FinalDataModel.showDetails?.seasons?.count {
            self.seasonLabel.text = "Seasons \(seasonCount)"
        }
       
        loadJson(filename: "tvshow")
        self.seasonCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnTap(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK: - Load JSON
    
    func loadJson(filename fileName: String) -> [Episode]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Episodes.self, from: data)
                
                print("Episodes are here \(jsonData.episodes?[0].name)")
                MyMovieDataModel.tvEpisodes = jsonData
                return jsonData.episodes
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    //MARK: - Setup Collection View
    
    
    func setupCollectionView() {
        
        seasonCollectionView.delegate = self
        seasonCollectionView.dataSource = self
        seasonCollectionView.collectionViewLayout = recentLayoutCells()
        seasonCollectionView.allowsMultipleSelection = false
        
        //register cells
        
        seasonCollectionView.register(UINib(nibName: "SeasonCardCVC", bundle: nil), forCellWithReuseIdentifier: "seas")
       
        
    }
    
    
    func layoutCells() -> UICollectionViewCompositionalLayout {
        
        
     
        //start
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
                
            case 0:
           
            let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
                myItem.contentInsets.trailing = 2
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 2
                myItem.contentInsets.top = 10
                
            
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(120), heightDimension: .absolute(80)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
            
                //side scroll is here
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            
//            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec1, alignment: .top)
//            header.pinToVisibleBounds = true
//            section.boundarySupplementaryItems = [header]
            
            
            return section
                
                
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
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(280)), subitems: [myItem])
                
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SeasonsViewController: UICollectionViewDataSource {
    
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            
        case 0:
            var selectedController = EpisodeCardsViewController()
//            if let jsonData = MyMovieDataModel.tvEpisodes?.episodes {
//
//                selectedController.tvPassedData = jsonData[indexPath.item]
//
//            }
            if let showID = FinalDataModel.showDetails?.showID {
                selectedController.getSeasonID = "\(showID)"
                
                if let seasonNum = FinalDataModel.showDetails?.seasons?[indexPath.item].seasonNumber {
                    selectedController.getSeasonNo = "\(seasonNum)"
                    selectedController.fetchEpisodeDetails(showId: "\(showID)", seasonNo: "\(seasonNum)")
                }
               
            }
            
           
            navigationController?.pushViewController(selectedController, animated: true)
            
        default:
           print("Hello")
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            
        case 0:
            return FinalDataModel.showDetails?.seasons?.count ?? 2
            
       
            
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seas", for: indexPath) as! SeasonCardCVC
//            cell.setupSelectedCell()
            
            if let seasonData = FinalDataModel.showDetails?.seasons {
                
                cell.setupSeasonCell(fromData: seasonData[indexPath.item])
            }
           
            return cell
            
          

            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episodeCell", for: indexPath) as! EpisodeCell


            
//            cell.setupLogos(fromData: myLogos[indexPath.item])
            
            return cell
            
            
            
        }
    }
    
    
}

struct mySeasons {
    
}
