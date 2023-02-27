//
//  ChatDetailProfileViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 27/02/23.
//

import UIKit

class ChatDetailProfileViewController: UIViewController {

    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    let sec1 = "sec1ID"
    let sec2 = "sec2ID"
    let sec3 = "sec3ID"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        // Do any additional setup after loading the view.
    }


    
    //MARK: - Setup Collection View
    
    func setupCollectionView() {
        
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.collectionViewLayout = layoutCells()
        
        profileCollectionView.register(UINib(nibName: "ProfileTitlesCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: self.sec1, withReuseIdentifier: "profi")
        
        profileCollectionView.register(UINib(nibName: "ProfileTitlesCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: self.sec2, withReuseIdentifier: "profi")
        
        
        
        profileCollectionView.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "heads")
        profileCollectionView.register(UINib(nibName: "recByUserposterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rec1")
        
        profileCollectionView.register(UINib(nibName: "recPosterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rec2")
        
        
        
    }
    
    
    
    //MARK: - Main Section Layout
    func layoutCells() -> UICollectionViewCompositionalLayout {
     
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
                
            case 0:

                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 1
                myItem.contentInsets.bottom = 1
                myItem.contentInsets.leading = 1
                myItem.contentInsets.top = 1
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
//                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec1, alignment: .top)
//                header.pinToVisibleBounds = true
//                section.boundarySupplementaryItems = [header]
                
                return section
        
                
            case 1:
        
                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.43), heightDimension: .absolute(220)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec1, alignment: .top)
               
//                header.pinToVisibleBounds = true

                section.boundarySupplementaryItems = [header]
                
                return section
                
                
            
            case 2:
                //item size
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.43), heightDimension: .absolute(220)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec2, alignment: .top)
               
//                header.pinToVisibleBounds = true

                section.boundarySupplementaryItems = [header]
                
                return section
                
                
                
        
                
         
        
                
                
            default:
                let myItem = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                //group
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(120), heightDimension: .absolute(170)), subitems: [myItem])
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                

                
                return section
                
            }
            
        }
        
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


extension ChatDetailProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "heads", for: indexPath) as! HeaderCollectionViewCell
            
            return cell
            
        
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rec1", for: indexPath) as! recByUserposterCollectionViewCell
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rec2", for: indexPath) as! recPosterCollectionViewCell
            return cell
            
            
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "heads", for: indexPath) as! HeaderCollectionViewCell
            
            return cell
        }
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            
        case 0:
            return 1
        
        case 1:
            return 6
            
        case 2:
            return 6
            
            
        default:
            return 1
        }
    }
    
    
   
    
}
