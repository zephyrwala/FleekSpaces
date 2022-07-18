//
//  SpacesViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 18/07/22.
//

import UIKit
import SwiftUI

class SpacesViewController: UIViewController, UICollectionViewDelegate {

    let myVideoModel = [
        VideoModel(videoFileName: "office", fileFormat: "mp4"),
        VideoModel(videoFileName: "pathala", fileFormat: "mp4"),
        VideoModel(videoFileName: "vikram", fileFormat: "mp4"),
        VideoModel(videoFileName: "thors", fileFormat: "mp4"),
        
    ]
    @IBOutlet weak var spacesCollectinView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //register cells
        
//        setupCollectionView()
        //headers if any
        
        let controllers = UIHostingController(rootView: ReelsView())
//        controllers.modalPresentationStyle = .fullScreen
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(controllers, animated: true)
//        controllers.modalPresentationStyle = .currentContext
//     present(controllers, animated: true)
    }
    
    
    //Setup Collection View
    
    
    func setupCollectionView() {
        
        spacesCollectinView.delegate = self
        spacesCollectinView.dataSource = self
        spacesCollectinView.collectionViewLayout = layoutCells()
        spacesCollectinView.contentInsetAdjustmentBehavior = .never
        spacesCollectinView.register(UINib(nibName: "SpacesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "spacesCell")
        spacesCollectinView.isPagingEnabled = true
      
        
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
            let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(760)), subitems: [myItem])
            
            //section size
            
            let section = NSCollectionLayoutSection(group: myGroup)
            
//            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
               
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
                
//                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//
                
                
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


extension SpacesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleCells = self.spacesCollectinView.visibleCells
        
        for cell in visibleCells {
            if self.spacesCollectinView.bounds.contains(cell.frame) {
                
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        print("start display cell")
   
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spacesCell", for: indexPath) as! SpacesCollectionViewCell
       

        cell.player?.play()
    
        
        if let playme = cell.player {
            print("Video play ond display")
            playme.pause()
        }

            
 
        
    }
 
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
            print("end display cell")
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spacesCell", for: indexPath) as! SpacesCollectionViewCell
           

        cell.player?.pause()
            
            if let playme = cell.player {
                print("Video play ond display")
                playme.pause()
            }
   
                
     
         
            
            
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return myVideoModel.count
        
            
            
        default:
            return 1
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spacesCell", for: indexPath) as! SpacesCollectionViewCell
           
//            cell.previewDelegate = self
//            if let posterData = passedData {
//                cell.setupCell(fromData: posterData)
//
//            }
            
            cell.configure(with: myVideoModel[indexPath.item])
         
            return cell
            
   
            
        
            
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spacesCell", for: indexPath) as! SpacesCollectionViewCell
            
            
            return cell
            
            
        }
        
    }
    
    
}
