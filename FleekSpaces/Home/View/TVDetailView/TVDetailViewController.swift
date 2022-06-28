//
//  TVDetailViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 20/06/22.
//

import UIKit

class TVDetailViewController: UIViewController, UICollectionViewDelegate, episodeBtnTap {
    func didTapEpisodeBtn(sender: UIButton) {
        let controller = SeasonsViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    

    let sec1 = "sec1ID"
    let sec2 = "sec2ID"
    let sec3 = "sec3ID"
    let sec0 = "sec0ID"
    var passedData: UResult?
    var tvPassedData: TVResult?
    var optionsLogos = [
    
        TextLogos(posterImage: UIImage(named: "hbomax")!, postername: "HBOmax"),
        TextLogos(posterImage: UIImage(named: "prime video")!, postername: "Prime Video"),
        TextLogos(posterImage: UIImage(named: "hotstar")!, postername: "Hotstar"),
        TextLogos(posterImage: UIImage(named: "zee5")!, postername: "Zee5"),
        TextLogos(posterImage: UIImage(named: "prime video")!, postername: "Prime Video"),
    
    ]
    @IBOutlet weak var tvCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnTap(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
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
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.6), heightDimension: .absolute(350)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
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

}


extension TVDetailViewController: UICollectionViewDataSource {
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            
        case 2:
       
            var selectedController = ActorDetailViewController()
            navigationController?.pushViewController(selectedController, animated: true)
            
        case 3:
            var selectedController = MovieDetailViewController()
            if let jsonData = MyMovieDataModel.upcoming?.results {
    
                selectedController.passedData = jsonData[indexPath.item]
    
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
            return 3
        case 2:
            return 6
        case 3:
            return 6
            
            
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
            if let movieData = tvPassedData {
                cell.setupTVCell(fromData: movieData)
               
            }
            
            
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviePDF", for: indexPath) as! MoviePlayCollectionViewCell
            cell.setupCell(fromData: optionsLogos[indexPath.item])
            
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movCast", for: indexPath) as! MovieCastCell
//            cell.setupCell(fromData: optionsLogos[indexPath.item])
            
            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreLike", for: indexPath) as! MoreLikeThisCollectionViewCell
            
            if let myMovieDataStuff = MyMovieDataModel.upcoming?.results {
                
                cell.setupCell(fromData: myMovieDataStuff[indexPath.item])
                
            }
            
            return cell
            
        
            
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieInfo", for: indexPath) as! MovieInfoCollectionViewCell
            
            
            return cell
            
            
        }
        
    }
}
