//
//  RecommendChatViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/02/23.
//

import UIKit

protocol PassMovieDelegate:AnyObject {
    func cellTapped(posterString: String)
}

class RecommendChatViewController: UIViewController {

    @IBOutlet weak var segmentButtons: UISegmentedControl!
    var selectedOption = 0
    var movieDelegate: PassMovieDelegate?
    var recommendCount = [Int]()
    let defaults = UserDefaults.standard
    @IBOutlet weak var postersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                        
//                        if let safeEmail =  self.defaults.string(forKey: "otherUserEmail") {
//
//
//
//                            let vc = ChatViewController(with: safeEmail, id: nil)
//
//                            vc.testPhoto()
//
//
//
//
//                        }
                        
                      
                        self.movieDelegate?.cellTapped(posterString: "https://image.tmdb.org/t/p/w500/\(posterURL)")
                    }
                }
               
                
                
                
                
            }
            
           
            
        case 1:
            
            if let posterURL = FinalDataModel.userLikes?[indexPath.item].postersURL {
                
                let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)")
               
                
                print("new Url is \(newURL)")
                
                
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
