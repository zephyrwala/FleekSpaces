//
//  RecommendChatViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/02/23.
//

import UIKit

protocol PassMovieDelegate:AnyObject {
    func cellTapped(posterString: String, showID: String, showType: String)
}

class RecommendChatViewController: UIViewController {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var watchLikeLabel: UISegmentedControl!
    @IBOutlet weak var shareTitle: UILabel!
    @IBOutlet weak var segmentButtons: UISegmentedControl!
    var selectedOption = 0
    var movieDelegate: PassMovieDelegate?
    var recommendCount = [Int]()
    let defaults = UserDefaults.standard
    var recommendToUid: String?
    @IBOutlet weak var postersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Recommend ID is \(recommendToUid)")
//        selectionLogin()
        setupCollectionView()
        fetchUserMovieData()
        fetchUserWatchlistData()
        // Do any additional setup after loading the view.
    }

    
    

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            selectedOption = 0
            fetchUserWatchlistData()
//            self.segmentButtons.selectedSegmentTintColor = .systemOrange
            
        case 1:
            selectedOption = 1
            fetchUserMovieData()
//            segmentButtons.selectedSegmentTintColor = .systemTeal
            
        default:
            print("Default")
        }
        
        
        
    }
    
    
    
    
    //MARK: - Fetch Like Movies
    func fetchUserMovieData() {
        
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/activity/get_likes_dislikes_of_user/") else {return}
                
        guard let myTOken = defaults.string(forKey: "userToken") else {return}
    
        network.tokenCalls([UserLike].self, url: myUrl, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let userData):
                FinalDataModel.userLikes = userData
                DispatchQueue.main.async {
                    
//                    self.likeBtn.setTitle("\(userData.count)", for: .normal)
                    self.selectionLogin()
                    self.postersCollectionView.reloadData()
                }
                for users in userData {
                    print("Movie liked are \(users.title)")
                    
                }
            case .failure(let err):
                print("Error is \(err)")
                
                
            }
        }
    }
    
    func selectionLogin() {
        
        if selectedOption == 0 {
            
            self.shareTitle.text = "What would you like to share from you list? 🤔"
            if let safeWatchCount = FinalDataModel.fetchWatchList?.count {
                self.iconImage.image = UIImage(systemName: "video.badge.checkmark")
                self.iconImage.tintColor = .systemOrange
                self.mainLabel.textColor = .systemOrange
                self.mainLabel.text = "Watchlist (\(safeWatchCount))"
            }
            
        } else {
            
            self.shareTitle.text = "What would you like to share from you list? 🤔"
            if let safeLikeCount = FinalDataModel.userLikes?.count {
                self.iconImage.image = UIImage(systemName: "hand.thumbsup")
                self.iconImage.tintColor = .systemTeal
                self.mainLabel.textColor = .systemTeal
                self.mainLabel.text = "Likes (\(safeLikeCount))"
            }
           
        }
        
    }
    
    //MARK: - Fetch watchlist
    
    
    func fetchUserWatchlistData() {
        
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/activity/get_user_watch_list/") else {return}
                
        guard let myTOken = defaults.string(forKey: "userToken") else {return}
    
        network.tokenCalls([FetchWatchList].self, url: myUrl, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let userData):
                FinalDataModel.fetchWatchList = userData
                DispatchQueue.main.async {
                    
                   
                        
//                    self.watchlistBtn.setTitle("\(userData.count)", for: .normal)
                    
                    self.selectionLogin()
                    self.postersCollectionView.reloadData()
                }
                for users in userData {
                    print("Movie liked are \(users.title)")
                    
                }
            case .failure(let err):
                print("Error is \(err)")
                
                
            }
        }
    }
    
    func addtoRecommend(showType: String, showID: String, recommendToId: String) {
        //https://api-space-dev.getfleek.app/activity/recommendations/?show_type=20eb3286-1981-41fa-910c-1cd039cec69e&show_id=tv_series&recommended_to_firebase_uid=TBUBN5PTvEPYQb6ZKetxP1B55ms1"
        
        //https://api-space-dev.getfleek.app/activity/recommendations/?show_type=tv_series&show_id=374f846f-e7a6-49ee-85a3-84ec45fccbd8&recommended_to_firebase_uid=TBUBN5PTvEPYQb6ZKetxP1B55ms1
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api-space-dev.getfleek.app"
        urlComponents.path = "/activity/recommendations/"
        urlComponents.queryItems = [
        
            URLQueryItem(name: "show_type", value: showType),
            URLQueryItem(name: "show_id", value: showID),
            URLQueryItem(name: "recommended_to_firebase_uid", value: recommendToId)
        
        ]
        
        print("recommend url is : -")
        print(urlComponents.url?.absoluteString)
        
        guard let myTOken = defaults.string(forKey: "userToken") else {return}
        
        guard let myUrl = urlComponents.url else {return}
        
        
        
        let network = NetworkURL()
        network.tokenCalls(AddRecommend.self, url: myUrl, token: myTOken, methodType: "POST") { myResults, yourMessage in
                
            
            switch myResults {
                
                
                
            case .success(let likes):
                print("Recommended \(likes.recommended) and it is recommended to  \(likes.recommendedTo?.name) \(yourMessage) \(likes)")
//                self.checkLikes()
                
            case .failure(let err):
                print("We have error \(err)")
                
                
                
                
            }
            
            
        }
        
        
    }
    
    
    //MARK: - Setup Collection View
    
    
    func setupCollectionView() {
        
        postersCollectionView.delegate = self
        postersCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        postersCollectionView.setCollectionViewLayout(layout, animated: true)
        
        postersCollectionView.register(UINib(nibName: "PasterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "pasters")

        
        
        
        
    }

}



extension RecommendChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectedOption {
            
        case 0:
           return FinalDataModel.fetchWatchList?.count ?? 0
            
        case 1:
           return FinalDataModel.userLikes?.count ?? 0
            
        case 2:
            return recommendCount.count ?? 0
            
        default:
           return 1
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2.1 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:240)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch selectedOption {
            
            
        case 0:
           
            if let posterURL = FinalDataModel.fetchWatchList?[indexPath.item].postersURL {
                
                if let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)") {
                    print("new Url is \(newURL)")
                   
                   
                    self.dismiss(animated: true) {
                        

                        if let safeTMDBID = FinalDataModel.fetchWatchList?[indexPath.item].showID {
                            
                            print("safe TMDB is \(safeTMDBID)")
                            self.defaults.set(safeTMDBID, forKey: "watchME")
                            
                            if let theShowType = FinalDataModel.fetchWatchList?[indexPath.item].showType {
                                //pass show type here
                                
                                //FIXME: - Pass the movie item here
                                
                                self.addtoRecommend(showType: theShowType, showID: safeTMDBID, recommendToId: self.recommendToUid!)
                                
                                self.movieDelegate?.cellTapped(posterString: "https://image.tmdb.org/t/p/w500/\(posterURL)", showID: safeTMDBID, showType: theShowType)
                            }
                           
                        }
                      
                       
                    }
                }
               
                   
                
            }
            
           
            
        case 1:
            
            if let posterURL = FinalDataModel.userLikes?[indexPath.item].postersURL {
                
                if let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)") {
                    
                    
                    self.dismiss(animated: true) {
                        

                        if let safeTMDBID = FinalDataModel.userLikes?[indexPath.item].showID {
                            
                            if let theShowType = FinalDataModel.userLikes?[indexPath.item].showType {
                                
                                self.addtoRecommend(showType: theShowType, showID: safeTMDBID, recommendToId: self.recommendToUid!)
                                
                                self.movieDelegate?.cellTapped(posterString: "https://image.tmdb.org/t/p/w500/\(posterURL)", showID: safeTMDBID, showType: theShowType)
                                
                            }
                           
                        }
                      
                       
                    }
                    
                    print("new Url is \(newURL)")
                }
               
                
               
                
                
            }
            
          
            
       
            
            
            
        default:
            
            if let posterURL = FinalDataModel.userLikes?[indexPath.item].postersURL {
                
                let newURL = URL(string: "https://image.tmdb.orgg/t/p/w500/\(posterURL)")
               
                
                
            }
            
          
            
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pasters", for: indexPath) as! PasterCollectionViewCell
        
        
        
        switch selectedOption {
            
            
        case 0:
            if let posterURL = FinalDataModel.fetchWatchList?[indexPath.item].postersURL {
                
                let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)")
                cell.posterImage.layer.cornerRadius = 6
                cell.posterImage.sd_setImage(with: newURL)
                
                
            }
            
            return cell
            
        case 1:
            
            if let posterURL = FinalDataModel.userLikes?[indexPath.item].postersURL {
                
                let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)")
                cell.posterImage.layer.cornerRadius = 6
                cell.posterImage.sd_setImage(with: newURL)
                
                
            }
            
            return cell
            
       
            
            
            
        default:
            
            if let posterURL = FinalDataModel.userLikes?[indexPath.item].postersURL {
                
                let newURL = URL(string: "https://image.tmdb.orgg/t/p/w500/\(posterURL)")
                cell.posterImage.layer.cornerRadius = 6
                cell.posterImage.sd_setImage(with: newURL)
                
                
            }
            
            return cell
            
            
        }
        
        //
    }
    
    
    
}
