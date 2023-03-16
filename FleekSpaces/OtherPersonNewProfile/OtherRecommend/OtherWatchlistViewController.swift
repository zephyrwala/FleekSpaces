//
//  OtherWatchlistViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/03/23.
//

import UIKit

class OtherWatchlistViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var totalWatchlist: UILabel!
    @IBOutlet weak var otherWatchlistCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let otherUserID = UserDefaults.standard.string(forKey: "otherUserID") else {return}
        
        setupCollectionView()
        fetchOtherUserWatchlistData(otherUserID: otherUserID)
        // Do any additional setup after loading the view.
    }

    
    func setupCollectionView() {
        
        otherWatchlistCollectionView.delegate = self
        otherWatchlistCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        otherWatchlistCollectionView.setCollectionViewLayout(layout, animated: true)
        
        otherWatchlistCollectionView.register(UINib(nibName: "UserDataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "userData")

        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func fetchOtherUserWatchlistData(otherUserID: String) {
        
        
        //https://api-space-dev.getfleek.app/activity/get_user_watch_list/?user_id=0a0c4e5d-25df-427b-9d84-760e658b9a51
        
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/activity/get_user_watch_list/?user_id=\(otherUserID)") else {return}
                
        guard let myTOken = UserDefaults.standard.string(forKey: "userToken") else {return}
    
        network.tokenCalls([FetchWatchList].self, url: myUrl, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let userData):
                FinalDataModel.fetchWatchList = userData
                DispatchQueue.main.async {
                    
                    UserDefaults.standard.set(FinalDataModel.fetchWatchList?.count, forKey: "watchCount")
                    
                    if let safeWatchCOunt = FinalDataModel.fetchWatchList?.count {
                        self.totalWatchlist.text = "\(safeWatchCOunt) Watchlist"
                    }
                        
//                    self.watchlistBtn.setTitle("\(userData.count)", for: .normal)
                    
                    
                    self.otherWatchlistCollectionView.reloadData()
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
        return FinalDataModel.fetchWatchList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userData", for: indexPath) as! UserDataCollectionViewCell
        
        if let posterURL = FinalDataModel.fetchWatchList?[indexPath.item].postersURL {
            
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
