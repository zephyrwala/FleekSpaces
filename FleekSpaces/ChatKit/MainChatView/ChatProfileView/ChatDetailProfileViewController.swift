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
    var profileImageUrls = ""
    var otherUserIDis = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        fetchRecommendedToThisUser(otheruserUID: otherUserIDis)
        fetchRecommendedToThisUsertoMe(otheruserUID: otherUserIDis)
        // Do any additional setup after loading the view.
    }

    
    
    //MARK: - recommended by this user to me
    func fetchRecommendedToThisUsertoMe(otheruserUID: String) {
        
        
        //url: https://api-space-dev.getfleek.app/activity/recommendations/?recommended_to_firebase_uid=TBUBN5PTvEPYQb6ZKetxP1B55ms1
        
        
        guard let safeURL = URL(string: "https://api-space-dev.getfleek.app/activity/recommendations/?recommended_by_firebase_uid=\(otheruserUID)") else {return}
        
        guard let myTOken = UserDefaults.standard.string(forKey: "userToken") else {return}
        
        
        let network = NetworkURL()
        
        network.tokenCalls(RecommendedByUID.self, url: safeURL, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let recMovies):
                print("Movies of rec are \(recMovies.recommendedList)")
                
                FinalDataModel.recommendedBy = recMovies
                
                
                DispatchQueue.main.async {
                    self.profileCollectionView.reloadData()
                }
                
                
            case .failure(let err):
                print("There is an error in rec fetch \(err)")
                
                
            }
        }
        
        
    }
    
//MARK: - rec by me to this user
    func fetchRecommendedToThisUser(otheruserUID: String) {
        
        
        //url: https://api-space-dev.getfleek.app/activity/recommendations/?recommended_to_firebase_uid=TBUBN5PTvEPYQb6ZKetxP1B55ms1
        
        
        guard let safeURL = URL(string: "https://api-space-dev.getfleek.app/activity/recommendations/?recommended_to_firebase_uid=\(otheruserUID)") else {return}
        
        guard let myTOken = UserDefaults.standard.string(forKey: "userToken") else {return}
        
        
        let network = NetworkURL()
        
        network.tokenCalls(RecommendedToUID.self, url: safeURL, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let recMovies):
                print("Movies of rec are \(recMovies.recommendedList)")
                
                FinalDataModel.recommendedTo = recMovies
                
                
                DispatchQueue.main.async {
                    self.profileCollectionView.reloadData()
                }
                
                
            case .failure(let err):
                print("There is an error in rec fetch \(err)")
                
                
            }
        }
        
        
    }
    
    
    //MARK: - Setup Collection View
    
    func setupCollectionView() {
        
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.collectionViewLayout = layoutCells()
        
      
        
        
        profileCollectionView.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "heads")
        profileCollectionView.register(UINib(nibName: "recByUserposterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rec1")
        
        profileCollectionView.register(UINib(nibName: "recPosterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rec2")
        
        
        
        
        profileCollectionView.register(UINib(nibName: "header2CollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "secs2", withReuseIdentifier: "head2")
        
        profileCollectionView.register(UINib(nibName: "ProfileTitlesCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "secs1", withReuseIdentifier: "head1")
        
        
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
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: "secs1", alignment: .top)
               
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
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(50)), elementKind: "secs2", alignment: .top)
               
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
            if let safeImageUrl = URL(string: profileImageUrls) {
                
                cell.userProfile.sd_setImage(with: safeImageUrl)
            }
           
            
            return cell
            
        
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rec1", for: indexPath) as! recByUserposterCollectionViewCell
            
            if let safeIndex = FinalDataModel.recommendedBy?.recommendedList?[indexPath.item] {
                cell.setupCell(fromdata: safeIndex)
            }
            
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rec2", for: indexPath) as! recPosterCollectionViewCell
            if let safeIndex = FinalDataModel.recommendedTo?.recommendedList?[indexPath.item] {
                cell.setupCell(fromdata: safeIndex)
            }
           
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
            return FinalDataModel.recommendedBy?.recommendedList?.count ?? 1
            
        case 2:
            
            
            return FinalDataModel.recommendedTo?.recommendedList?.count ?? 1
            
            
        default:
            return 1
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        switch indexPath.section {
            
            
        case 1:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "head1", for: indexPath) as! ProfileTitlesCollectionReusableView
            if let safename = FinalDataModel.recommendedBy?.recommendedBy?.name {
                
                print("safe name is \(safename)")
                header.recommendedByOtheruser.text = "Recommended By \(safename)"
            }
           
           
            return header
            
        case 2:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "head2", for: indexPath) as! header2CollectionReusableView
           
         
           
            return header
            
            
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "head1", for: indexPath) as! ProfileTitlesCollectionReusableView
           
           
            return header
            
            
            
        }
        
        
     
        
        
    }
   
    
}
