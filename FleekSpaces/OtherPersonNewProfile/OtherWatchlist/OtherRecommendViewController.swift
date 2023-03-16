//
//  OtherRecommendViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/03/23.
//

import UIKit

class OtherRecommendViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var otherRecommendCollectionView: UICollectionView!
    
    @IBOutlet weak var totalRecommend: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        guard let otherUserID = UserDefaults.standard.string(forKey: "otherUserID") else {return}
        fetchOtheruserRecommend(otherUserID: otherUserID)
        // Do any additional setup after loading the view.
    }

    
    func setupCollectionView() {
        
        otherRecommendCollectionView.delegate = self
        otherRecommendCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        otherRecommendCollectionView.setCollectionViewLayout(layout, animated: true)
        
        otherRecommendCollectionView.register(UINib(nibName: "UserDataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "userData")

   
        
    }

    
    
    //MARK: - Fetch Other User Recommend
    func fetchOtheruserRecommend(otherUserID: String) {
        
        
        //https://api-space-dev.getfleek.app/activity/get_recommendations_list?user_id=0a0c4e5d-25df-427b-9d84-760e658b9a51
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/activity/get_recommendations_list/?user_id=\(otherUserID)") else {return}
                
        guard let myTOken = UserDefaults.standard.string(forKey: "userToken") else {return}
    
        network.tokenCalls(RecommendProfile.self, url: myUrl, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let userData):
                FinalDataModel.recommendedProfile = userData
                print("Recommemnd Data is \(userData.recommendedList)")
                DispatchQueue.main.async {
                    if let safeCount = userData.recommendedList?.count {
//                        self.recommendBtn.setTitle("\(safeCount)", for: .normal)
                    }
                   
                    
                    
                    self.otherRecommendCollectionView.reloadData()
                }
              
            case .failure(let err):
                print("Error is \(err)")
                
                
            }
        }
        
        
        
        
    }
    
    
 
    
    
    
    //MARK: - COllection view stuff
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:175)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FinalDataModel.recommendedProfile?.recommendedList?.count ??
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userData", for: indexPath) as! UserDataCollectionViewCell
        
        if let posterURL = FinalDataModel.recommendedProfile?.recommendedList?[indexPath.item].postersURL {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)")
            cell.posterImage.layer.cornerRadius = 10
            cell.posterImage.sd_setImage(with: newURL)
            cell.posterImage.layer.cornerCurve = .continuous
            
            cell.userProfileImage.isHidden = false
        }
        
        if let avatarURL = FinalDataModel.recommendedProfile?.recommendedList?[indexPath.item].recommendedTo?.avatarURL {
            let newURL = URL(string: avatarURL)
            cell.userProfileImage.sd_setImage(with: newURL)
        }
        
        return cell
        
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
