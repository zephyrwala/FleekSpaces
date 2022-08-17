//
//  ActorDetailViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 14/06/22.
//

import UIKit

class ActorDetailViewController: UIViewController, UICollectionViewDelegate {
    
    var actorId: String?
    var passedData: Crew?
    var sec1 = "sec1"

    @IBOutlet weak var actorCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchActorDetail(actor: "\(actorId)")
        setupCollectionView()
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Fetch Movie Detail
    func fetchActorDetail(actor: String) {
        
//        guard let finalMovieId = actorId
//        else {
//            return
//        }

      
        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_cast_details/?people_id=\(actor)")
        
        
        network.theBestNetworkCall(ActorMovieDetail.self, url: url) { myMovieResult, yourMessage in
            
          
            switch myMovieResult {
                
            
            case .success(let actorData):
                print("Actor Data is here \(actorData) and \(actorData.name)")
                DispatchQueue.main.async {
                FinalDataModel.actorMovie = actorData
                    print("passed actor is \(actorData.biography)")
                
                   
                        self.actorCollectionView.reloadData()
                    
              
              
                
            }
               
            case .failure(let err):
                print("Failed to fetch data")
                
            }
            
        }
        
        
    
    }
    
    //MARK: - setup collectionview
    func setupCollectionView() {
        
        actorCollectionView.delegate = self
        actorCollectionView.dataSource = self
        actorCollectionView.collectionViewLayout = layoutCells()
        
        //register cell
        
        actorCollectionView.register(UINib(nibName: "ActorBioCVC", bundle: nil), forCellWithReuseIdentifier: "actorBio")
        actorCollectionView.register(UINib(nibName: "SearchResultCVC", bundle: nil), forCellWithReuseIdentifier: "searchResults")
        
        
        //register header
        actorCollectionView.register(UINib(nibName: "filmographyHeader", bundle: nil), forSupplementaryViewOfKind: self.sec1, withReuseIdentifier: "filmoH")
        
        
        
    }
    
    
//MARK: - layout cells
    func layoutCells() -> UICollectionViewCompositionalLayout {
        
        
           //start
           let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
               
               switch sectionNumber {
                   
               case 0:
              
               let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
               
               myItem.contentInsets.trailing = 10
               myItem.contentInsets.bottom = 10
               myItem.contentInsets.leading = 10
               myItem.contentInsets.top = 10
               
               
               //group size
               let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(400)), subitems: [myItem])
               
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
                   let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [myItem])
                   
                   //section size
                   
                   let section = NSCollectionLayoutSection(group: myGroup)
                   
                 
                   
                   let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(45)), elementKind: self.sec1, alignment: .top)

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


extension ActorDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if let movieCount = FinalDataModel.actorMovie?.filmography?.cast?.count {
               
                switch movieCount {
                    
                case 3:
                    return 3
                    
                case 4:
                    return 4
                    
                case 5:
                    return 5
                    
                case 6:
                    return 6
                    
                case 7:
                    return 7
                    
                case 8:
                    return 8
                    
                case 9:
                    return 9
                    
                default:
                    return 3
                    
                }
            }
           
        
        default:
            return 5
        }
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
      
        case 1:
            var selectedController = MovieDetailViewController()
//            if let jsonData = MyMovieDataModel.upcoming?.results {
//
//                selectedController.passedData = jsonData[indexPath.item]
//
//            }
            
            if let tmdbID = FinalDataModel.actorMovie?.filmography?.cast?[indexPath.item].id {
                
                selectedController.fetchMovieDetailswithTMDBid(tmdbID: "\(tmdbID)")
                selectedController.fetchMoreLikeThis(tmdbID: "\(tmdbID)")
            }
            
//            selectedController.passedData = filteredData[indexPath.item]
//
                
            navigationController?.pushViewController(selectedController, animated: true)
        
        default:
            var selectedController = MovieDetailViewController()
            if let jsonData = MyMovieDataModel.upcoming?.results {
    
                selectedController.passedData = jsonData[indexPath.item]
    
            }
            
//            selectedController.passedData = filteredData[indexPath.item]
//
                
            navigationController?.pushViewController(selectedController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
            
        case 1:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "filmoH", for: indexPath) as! filmographyHeader
          
            
            if let nameOfActor = FinalDataModel.actorMovie?.name {
                
                header.actorTitlehead.text = "\(nameOfActor)'s Filmography"
            }
//            if let actorName = passedData?.name {
//
//
//            }
           
            return header
            
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "filmoH", for: indexPath) as! filmographyHeader
          
           
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
     
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actorBio", for: indexPath) as! ActorBioCVC
            
           
    
             
                if let actorData = FinalDataModel.actorMovie {
                    cell.setupActorCell(fromData: actorData)
                }
               
    
            
           
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchResults", for: indexPath) as! SearchResultCVC
            
            if let myMovieDataStuff = FinalDataModel.actorMovie?.filmography?.cast {
    
                cell.setupActCell(fromData: myMovieDataStuff[indexPath.item])
    
            }
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorBioCVC", for: indexPath) as! ActorBioCVC
            
            return cell
            
            
            
        }
        
    }
    
    
    
}

