//
//  SeasonsViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 21/06/22.
//

import UIKit

class SeasonsViewController: UIViewController, UICollectionViewDelegate {
    
    
    let sec1 = "sec1ID"
    let sec2 = "sec2ID"
    let sec3 = "sec3ID"
    let sec0 = "sec0ID"

    @IBOutlet weak var seasonCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
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
        seasonCollectionView.collectionViewLayout = layoutCells()
        seasonCollectionView.allowsMultipleSelection = false
        
        //register cells
        
        seasonCollectionView.register(UINib(nibName: "SeasonCell", bundle: nil), forCellWithReuseIdentifier: "seasonCell")
        seasonCollectionView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellWithReuseIdentifier: "episodeCell")
        
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
            
        case 1:
            var selectedController = DetailEpisodeViewController()
            if let jsonData = MyMovieDataModel.tvEpisodes?.episodes {
                
                selectedController.tvPassedData = jsonData[indexPath.item]
                
            }
            navigationController?.pushViewController(selectedController, animated: true)
            
        default:
           print("Hello")
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            
        case 0:
            return SeasonNumbers.slideCollection.count ?? 5
            
        case 1:
            return MyMovieDataModel.tvEpisodes?.episodes?.count ?? 6
            
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0:
            
            if indexPath.item == 0 {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seasonCell", for: indexPath) as! SeasonCell
                cell.setupSelectedCell()
                
                return cell
                
            } else {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seasonCell", for: indexPath) as! SeasonCell


                cell.setupCell(fromData: SeasonNumbers.slideCollection[indexPath.item])
                
    //            cell.setupLogos(fromData: myLogos[indexPath.item])
                
                return cell
                
            }
            
          
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "episodeCell", for: indexPath) as! EpisodeCell

            if let jsonData = MyMovieDataModel.tvEpisodes?.episodes {
                cell.setupCell(fromData: jsonData[indexPath.item])
            }

       
//            cell.setupLogos(fromData: myLogos[indexPath.item])
            
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
