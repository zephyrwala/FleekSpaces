//
//  BooksDetailViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 16/07/22.
//

import UIKit

class BooksDetailViewController: UIViewController, UICollectionViewDelegate, previewBtn {
    func didTapPreviewBtn(sender: UIButton) {
        
        let controller = BookPreviewUIViewViewController()
//        navigationController?.pushViewController(controller, animated: true)
        
        self.present(controller, animated: true)
        
        
    }
    

    var passedData: Logos?
    @IBOutlet weak var bookDetailCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func backbtnTap(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Setup Collection View
    
    func setupCollectionView() {
        
        //delegates
        
        bookDetailCollectionView.delegate = self
        bookDetailCollectionView.dataSource = self
        bookDetailCollectionView.contentInsetAdjustmentBehavior = .never
        bookDetailCollectionView.collectionViewLayout = layoutCells()
        
        
        
        //cells

        bookDetailCollectionView.register(UINib(nibName: "BookSectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bookSection")
        
        
        //headers
        
    }

    //MARK: - Layout cell
    
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
            let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(760)), subitems: [myItem])
            
            //section size
            
            let section = NSCollectionLayoutSection(group: myGroup)
            
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension BooksDetailViewController: UICollectionViewDataSource {
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        
            
            
        default:
            return 1
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookSection", for: indexPath) as! BookSectionCollectionViewCell
           
            cell.previewDelegate = self
            if let posterData = passedData {
                cell.setupCell(fromData: posterData)

            }
         
            return cell
            
   
            
        
            
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieInfo", for: indexPath) as! MovieInfoCollectionViewCell
            
            
            return cell
            
            
        }
        
    }
    
}
