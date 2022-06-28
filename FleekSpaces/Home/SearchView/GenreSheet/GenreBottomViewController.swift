//
//  GenreBottomViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/06/22.
//

import UIKit

class GenreBottomViewController: UIViewController, UICollectionViewDelegate {
    
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    var genresData = [
        MovieGenres(genreName: "Action"),
        MovieGenres(genreName: "Adventure"),
        MovieGenres(genreName: "Animation"),
        MovieGenres(genreName: "Comedy"),
        MovieGenres(genreName: "Romance"),
        MovieGenres(genreName: "Drama"),
        MovieGenres(genreName: "Biography"),
        MovieGenres(genreName: "Drama"),
        MovieGenres(genreName: "Biography"),
        MovieGenres(genreName: "Drama"),
        MovieGenres(genreName: "Biography"),
        MovieGenres(genreName: "Drama"),
        MovieGenres(genreName: "Biography"),
        MovieGenres(genreName: "Crime")
    ]

    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        
        // Do any additional setup after loading the view.
    }


    func setupCollectionView() {
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        genreCollectionView.collectionViewLayout = layoutCells()
        
        //register header
        
        genreCollectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "genCell")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func layoutCells() -> UICollectionViewCompositionalLayout {
        
        
           //start
           let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
               
               switch sectionNumber {
                   
               case 0:
              
               let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
               
               myItem.contentInsets.trailing = 10
               myItem.contentInsets.bottom = 2
               myItem.contentInsets.leading = 10
               myItem.contentInsets.top = 2
               
               
               //group size
               let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55)), subitems: [myItem])
               
               //section size
               
               let section = NSCollectionLayoutSection(group: myGroup)
               
        
               
   //            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec1, alignment: .top)
   //            header.pinToVisibleBounds = true
   //            section.boundarySupplementaryItems = [header]
               
               
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

}


extension GenreBottomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genresData.count
    }
    
  
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
     
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genCell", for: indexPath) as! GenreCollectionViewCell
            
            cell.setupCell(fromData: genresData[indexPath.item])
            
            return cell
            
     
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorBioCVC", for: indexPath) as! ActorBioCVC
            
            return cell
            
            
            
        }
        
    }
    
}
