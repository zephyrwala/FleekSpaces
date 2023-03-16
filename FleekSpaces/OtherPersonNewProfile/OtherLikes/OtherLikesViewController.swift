//
//  OtherLikesViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/03/23.
//

import UIKit

class OtherLikesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var totalLikes: UILabel!
    @IBOutlet weak var otherLikesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        guard let otherUserID = UserDefaults.standard.string(forKey: "otherUserID") else {return}
        fetchOtherUserMovieData(otherUserID: otherUserID)
        // Do any additional setup after loading the view.
    }

    
    
    func setupCollectionView() {
        
        otherLikesCollectionView.delegate = self
        otherLikesCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        otherLikesCollectionView.setCollectionViewLayout(layout, animated: true)
        
        otherLikesCollectionView.register(UINib(nibName: "UserDataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "userData")

        
        
        
        
    }


    
    //MARK: - Fetch other user data
    
    
    func fetchOtherUserMovieData(otherUserID: String) {
        
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/activity/get_likes_dislikes_of_user/?user_id=\(otherUserID)") else {return}
                
        guard let myTOken = UserDefaults.standard.string(forKey: "userToken") else {return}
    
        network.tokenCalls([UserLike].self, url: myUrl, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let userData):
                FinalDataModel.userLikes = userData
                DispatchQueue.main.async {
                    
//                    self.likeBtn.setTitle("\(userData.count)", for: .normal)
                    UserDefaults.standard.set(FinalDataModel.userLikes?.count, forKey: "likesCont")
                    
                    if let safeLikes = FinalDataModel.userLikes?.count {
                        self.totalLikes.text = "\(safeLikes) Likes"
                    }
                    self.otherLikesCollectionView.reloadData()
                }
                for users in userData {
                    print("Movie liked are \(users.title)")
                    
                }
            case .failure(let err):
                print("Error is \(err)")
                
                
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FinalDataModel.userLikes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userData", for: indexPath) as! UserDataCollectionViewCell
        
        if let posterURL = FinalDataModel.userLikes?[indexPath.item].postersURL {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)")
            cell.posterImage.layer.cornerRadius = 6
            cell.posterImage.sd_setImage(with: newURL)
            cell.userProfileImage.isHidden = true
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:175)
    }

}
