//
//  ChooseSubsViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 02/06/22.
//

import UIKit

class ChooseSubsViewController: UIViewController, UICollectionViewDelegate {


    

    @IBOutlet weak var backBtnTap: UIButton!
    var sec0 = "YourSubs"
    @IBOutlet weak var chooseSubsCollectionView: UICollectionView!
    
//    var myLogos = [Logos(posterImage: UIImage(named: "hbomax")!),
//                   Logos(posterImage: UIImage(named: "netflix")!),
//                   Logos(posterImage: UIImage(named: "hotstar")!),
//                   Logos(posterImage: UIImage(named: "hbomax")!),
//                   Logos(posterImage: UIImage(named: "zee5")!),
//                   Logos(posterImage: UIImage(named: "hotstar")!)
//    ]
    
    var optionsLogos = [
    
        TextLogos(posterImage: UIImage(named: "hbomax")!, postername: "HBOmax"),
        TextLogos(posterImage: UIImage(named: "netflix")!, postername: "Netflix"),
        TextLogos(posterImage: UIImage(named: "hotstar")!, postername: "Hotstar"),
        TextLogos(posterImage: UIImage(named: "zee5")!, postername: "Zee5"),
        TextLogos(posterImage: UIImage(named: "prime video")!, postername: "Prime Video"),
        
        
    
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func backBtnAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    //MARK: - setup collectionview
    
    func setupCollectionView() {
        
        chooseSubsCollectionView.allowsMultipleSelection = true
        chooseSubsCollectionView.delegate = self
        chooseSubsCollectionView.dataSource = self
        chooseSubsCollectionView.collectionViewLayout = layoutCells()
        
        //register cells
        chooseSubsCollectionView.register(UINib(nibName: "SearchCollectionCell", bundle: nil), forCellWithReuseIdentifier: "searchSection")
        
        
            //TODO: - Add header
        chooseSubsCollectionView.register(UINib(nibName: "AddSubCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "addSub")
        chooseSubsCollectionView.register(UINib(nibName: "SelectedSubCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "subSelected")
        
        //register headers
        
        chooseSubsCollectionView.register(UINib(nibName: "SelectedSubCRV", bundle: nil), forSupplementaryViewOfKind: self.sec0, withReuseIdentifier: "selectedSubHeader")
        
        chooseSubsCollectionView.register(UINib(nibName: "Section2HeadersCRV", bundle: nil), forSupplementaryViewOfKind: self.sec0, withReuseIdentifier: "sec2Headers")
        
        
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
        
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, Env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
                
            case 0:
                //item
                let myItem = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                //group
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitems: [myItem])
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
               
                
                return section
                
            case 1:
                
                let myItem = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 5
                myItem.contentInsets.bottom = 5
                myItem.contentInsets.leading = 5
                myItem.contentInsets.top = 5
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(85), heightDimension: .absolute(85)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55)), elementKind: self.sec0, alignment: .top)
                section.boundarySupplementaryItems = [header]
                section.contentInsets.leading = 15
                
                return section
                
            case 2:
                
                let myItem = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 5
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 5
                
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: self.sec0, alignment: .top)
                section.boundarySupplementaryItems = [header]
                
               return section
                
                
            default:
                //item
                let myItem = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                //group
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitems: [myItem])
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                return section
                
                
            }
            //switch sectionNumber ends here
            
            
        }
        //layout ends here
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
        
        
    }

}


extension ChooseSubsViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch indexPath.section {
            
        case 1:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "selectedSubHeader", for: indexPath) as! SelectedSubCRV
          
           
            return header
            
            
        case 2:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sec2Headers", for: indexPath) as! Section2HeadersCRV
          
           
            return header
            
        
        default:
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "selectedSubHeader", for: indexPath) as! SelectedSubCRV
          
           
            return header
            
            
        }
      
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        switch section {
            
        case 0:
            return 1
            
        case 1:
            return 3
            
        
        case 2:
            return optionsLogos.count
            
        default:
            return 1
            
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchSection", for: indexPath) as! SearchCollectionCell
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subSelected", for: indexPath) as! SelectedSubCollectionViewCell
            
//            cell.setupCell(fromData: myLogos[indexPath.item])
            
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addSub", for: indexPath) as! AddSubCollectionViewCell
            
            cell.setupCell(fromData: optionsLogos[indexPath.item])
//            cell.selectedImage = UIImage(systemName: "checkmark.circle.fill")
//            cell.deselectedImage = UIImage(systemName: "circle")
//            cell.tintColor = UIColor(named: "Fleek_600")
//            cell.checkmarkSize = 30.0
//            cell.checkmarkMargin = 17.0
//            cell.checkmarkLocation = [NSLayoutConstraint.Attribute.top, NSLayoutConstraint.Attribute.right]
//            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchSection", for: indexPath) as! SearchCollectionCell
            return cell
            
            
            
        }
        
       
    }
    
    
}
