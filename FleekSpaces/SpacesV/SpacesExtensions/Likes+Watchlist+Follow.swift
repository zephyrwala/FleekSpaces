//
//  Likes+Watchlist+Follow.swift
//  FleekSpaces
//
//  Created by Mayur P on 07/03/23.
//

import UIKit

extension SpacesTableViewController: PassLikesData, FollowBtnTap, WatchlistBtnTap, OpenUserProfile {
    func openUserProfile(sender: UIButton, cell: SpacesTableViewCell) {
//        let vc = OtherUserProfileViewController()
//        if let safeIndexPath = self.tableView.indexPath(for: cell) {
//
//            if let safeUserID = FinalDataModel.spacesFeedElement?[safeIndexPath.row].user?.userID {
//
//                vc.setupUserProfile(otherUserID: safeUserID)
//            }
//
//        }
        
        
        //now we can pass the user id and fetch the data
    //TODO: - Uncomment the above
        
        if let safeIndexPath = self.tableView.indexPath(for: cell) {
            
            if let safeUserID = FinalDataModel.spacesFeedElement?[safeIndexPath.row].user?.userID {
                
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "nuProfile") as! NewProfileViewController
                vc.isMyProfile = false
                vc.otherProfileID = safeUserID
             
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
            
            
        }
//        let vc = NewProfileViewController()
   
    }
    
    
    
    
    //watchlist action
    
    func watchlistBtnTap(sender: UIButton, cell: SpacesTableViewCell) {
        if let safeIndexPath = self.tableView.indexPath(for: cell) {
            
            //showType
            //myTitle
            //showID
            //posterURL
            
            guard let safeShowType = FinalDataModel.spacesFeedElement?[safeIndexPath.row].showType else {return}
            
            guard let safeTitle = FinalDataModel.spacesFeedElement?[safeIndexPath.row].title else {return}
            
            guard let safeShowID = FinalDataModel.spacesFeedElement?[safeIndexPath.row].showID else {return}
            
            guard let safePosterURL = FinalDataModel.spacesFeedElement?[safeIndexPath.row].postersURL else {return}
            
            
            print("show type \(safeShowType) - show title \(safeTitle) - show id \(safeShowID) - safe poster \(safePosterURL)")
            
            addWatchlist(showType: safeShowType.rawValue, myTitle: safeTitle, myShowID: safeShowID, myPosterURL: safePosterURL)
        }
        
        cell.watchlistBtn.setImage(UIImage(systemName: "video.fill.badge.checkmark"), for: .normal)
        //add likes func here
       
        cell.watchlistBtn.tintColor = .systemOrange
       
            
        
    }
    
    
    
    
    //MARK: - Add Watchlist
    
    func addWatchlist(showType: String, myTitle: String, myShowID: String, myPosterURL: String) {
        
        
       
      
      
     

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api-space-dev.getfleek.app"
        urlComponents.path = "/activity/add_to_user_watch_list/"
        //api-space-dev.getfleek.app/
        urlComponents.queryItems = [
           URLQueryItem(name: "show_type", value: showType),
           URLQueryItem(name: "show_id", value: myShowID),
           URLQueryItem(name: "posters_url", value: myPosterURL),
           URLQueryItem(name: "title", value: myTitle)
         
        ]

        print(urlComponents.url?.absoluteString)
        print("Clubbed url is ")
        print(urlComponents.url?.absoluteString)
        
        

        
        
        guard let myTOken = UserDefaults.standard.string(forKey: "userToken") else {return}
        print("My token is \(myTOken)")
        guard let myUrl = urlComponents.url else {return}
        
        let network = NetworkURL()
        network.tokenCalls(WatchList.self, url: myUrl, token: myTOken, methodType: "POST") { myResults, yourMessage in
                
            
            switch myResults {
                
                
                
            case .success(let likes):
                print("result of watchlist is \(likes.title) \(yourMessage) \(likes)")
//                self.checkLikes()
                
            case .failure(let err):
                print("We have error \(err)")
                
                
                
                
            }
            
            
        }
        
        
        
        
        
    }
    
    
    
    //MARK: - Add Likes Function
    
    func addLikes(showType: String, myTitle: String, myShowID: String, myPosterURL: String) {
        
     

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api-space-dev.getfleek.app"
        urlComponents.path = "/activity/add_likes_dislikes/"
        //api-space-dev.getfleek.app/
        urlComponents.queryItems = [
           URLQueryItem(name: "show_type", value: showType),
           URLQueryItem(name: "show_id", value: myShowID),
           URLQueryItem(name: "posters_url", value: myPosterURL),
           URLQueryItem(name: "like", value: "1"),
           URLQueryItem(name: "title", value: myTitle),
           URLQueryItem(name: "dislike", value: "0")
        ]

        print(urlComponents.url?.absoluteString)
        print("Clubbed url is ")
        print(urlComponents.url?.absoluteString)
        
        

        
        
        guard let myTOken = UserDefaults.standard.string(forKey: "userToken") else {return}
        print("My token is \(myTOken)")
        guard let myUrl = urlComponents.url else {return}
        
        let network = NetworkURL()
        network.tokenCalls(AddLike.self, url: myUrl, token: myTOken, methodType: "POST") { myResults, yourMessage in
                
            
            switch myResults {
                
                
                
            case .success(let likes):
                print("Movie result is \(likes.title) \(yourMessage) \(likes)")
                
//                self.checkLikes()
                
            case .failure(let err):
                print("We have movie error \(err)")
                
                
                
                
            }
            
            
        }
        
        
        
        
        
    }
    
    
    //MARK: - Like action
    func spacesLikeBtnTap(_ cell: SpacesTableViewCell) {
        
        if let safeIndexPath = self.tableView.indexPath(for: cell) {
            
            //showType
            //myTitle
            //showID
            //posterURL
            
            guard let safeShowType = FinalDataModel.spacesFeedElement?[safeIndexPath.row].showType else {return}
            
            guard let safeTitle = FinalDataModel.spacesFeedElement?[safeIndexPath.row].title else {return}
            
            guard let safeShowID = FinalDataModel.spacesFeedElement?[safeIndexPath.row].showID else {return}
            
            guard let safePosterURL = FinalDataModel.spacesFeedElement?[safeIndexPath.row].postersURL else {return}
            
            
            print("show type \(safeShowType) - show title \(safeTitle) - show id \(safeShowID) - safe poster \(safePosterURL)")
            
            addLikes(showType: safeShowType.rawValue, myTitle: safeTitle, myShowID: safeShowID, myPosterURL: safePosterURL)
        }
        
        cell.likeBtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        //add likes func here
        cell.lottiePlay()
        cell.likeBtn.tintColor = .systemTeal
       
            
        
       
       
        
    }
    
    
    
    
    
    //https://api-space-dev.getfleek.app/activity/get_likes_dislikes_of_show/?show_type=movie&show_id=c7782a37-aa5d-46ee-9690-18cad17d82d0
    //MARK: - Follow Button Tap Action
    
    func followBtnTap(sender: UIButton,  cell: SpacesTableViewCell) {
        
        

        
        if let indexPath = self.tableView.indexPath(for: cell) {
            if let safeFirebaseUID =  FinalDataModel.spacesFeedElement?[indexPath.row].user?.firebaseUid {
                
                sendFollowRequest(firebaseUID: safeFirebaseUID)
                print("\(FinalDataModel.spacesFeedElement?[indexPath.row].user?.firebaseUid)")
            }
            
           
        }
       
       
        
        let alert = UIAlertController(title: "Awesome! 🥹", message: self.followMessage, preferredStyle: .alert)
//        cell.followBtn.isHidden = true
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { alerts in
            
           
            self.navigationController?.popToRootViewController(animated: true)
            
//            self.dismiss(animated: true) {
//                NotificationCenter.default.post(name: NSNotification.Name("startSwiftUI"), object: nil)
//            }
        }))
        present(alert, animated: true)
    }
    
  
    
    
    
}
