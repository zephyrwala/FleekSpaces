//
//  FollowersViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 04/03/23.
//

import UIKit

class FollowersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  

    //outlets
    
    @IBOutlet weak var followersFollowingSegment: UISegmentedControl!
    @IBOutlet weak var followersTableView: UITableView!
    
    var myFollowers : [GetFollower]?
    var myFollowing : [GetFollower]?
    
    var selectedSegment = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        fetchFollowers()
//        fetchFollowings()
        setupTableView()
        
        // Do any additional setup after loading the view.
    }


    //setup table view
    func setupTableView() {
        
        followersTableView.delegate = self
        followersTableView.dataSource = self
        followersTableView.register(UINib(nibName: "FollowersFollowingTableViewCell", bundle: nil), forCellReuseIdentifier: "followersa")
        
    }
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            selectedSegment = 0
            
            fetchFollowers()
            
        case 1:
            
            selectedSegment = 1
            fetchFollowings()
            
            
        default:
            print("default")
            
            
        }
        
        
    }
    
    
    
    //MARK: - Fetch Followers
    
    func fetchFollowers() {
        
        //https://api-space-dev.getfleek.app/users/get_followers
        
        
        let network = NetworkURL()
        
        guard let myURL = URL(string: "https://api-space-dev.getfleek.app/users/get_followers") else {return}
        
        
        guard let myToken = UserDefaults.standard.string(forKey: "userToken") else {return}
        
        
        network.tokenCalls([GetFollower].self, url: myURL, token: myToken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let userData):
                FinalDataModel.myFollowers = userData
                self.myFollowers = userData
                DispatchQueue.main.async {
                    
                   
                       //save in variable
//                    self.watchlistBtn.setTitle("\(userData.count)", for: .normal)
//
                    
                    self.followersTableView.reloadData()
                }
             
            case .failure(let err):
                print("Error is \(err)")
                
                
            }
        }
        
        
        
    }
    
    
    //MARK: - Get Following
    

    
    func fetchFollowings() {
        
        //https://api-space-dev.getfleek.app/users/get_followers
        
        
        let network = NetworkURL()
        
        guard let myURL = URL(string: "https://api-space-dev.getfleek.app/users/get_followings") else {return}
        
        
        guard let myToken = UserDefaults.standard.string(forKey: "userToken") else {return}
        
        
        network.tokenCalls([GetFollower].self, url: myURL, token: myToken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let userData):
                FinalDataModel.myFollowers = userData
                self.myFollowing = userData
                DispatchQueue.main.async {
                    
                   
                       //save in variable
//                    self.watchlistBtn.setTitle("\(userData.count)", for: .normal)
//
                    
                    self.followersTableView.reloadData()
                }
             
            case .failure(let err):
                print("Error is \(err)")
                
                
            }
        }
        
        
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegment {
        case 0:
            return myFollowers?.count ?? 1
        case 1:
            return myFollowing?.count ?? 1
        default:
            return myFollowers?.count ?? 1
            
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followersa", for: indexPath) as! FollowersFollowingTableViewCell
        
        switch selectedSegment {
            
        case 0:
            
            if let safeIndex = myFollowers?[indexPath.row] {
                cell.setupCell(fromData: safeIndex)
            }
            
            
            return cell
            
        case 1:
            
            if let safeIndex = myFollowing?[indexPath.row] {
                cell.setupCell(fromData: safeIndex)
            }
            
            
            return cell
            
            
        default:
            if let safeIndex = myFollowers?[indexPath.row] {
                cell.setupCell(fromData: safeIndex)
            }
            
            
            return cell
            
            
        }
      
    }
    
    

}
