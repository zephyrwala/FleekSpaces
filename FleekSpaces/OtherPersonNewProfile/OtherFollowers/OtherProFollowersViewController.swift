//
//  OtherProFollowersViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/03/23.
//

import UIKit

class OtherProFollowersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var myFollowers : [GetFollower]?
    var myFollowing : [GetFollower]?
    @IBOutlet weak var otherFollowinCount: UILabel!
    @IBOutlet weak var otherFollowersTableVIew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        fetchFollowers()
//          fetchFollowings()
  //        fetchFollowings()
          setupTableView()
        guard let otherUserID = UserDefaults.standard.string(forKey: "otherUserID") else {return}
        fetchFollowers(otherUserID: otherUserID)
        // Do any additional setup after loading the view.
    }


    
    //setup table view
    func setupTableView() {
        
        otherFollowersTableVIew.delegate = self
        otherFollowersTableVIew.dataSource = self
        otherFollowersTableVIew.register(UINib(nibName: "FollowersFollowingTableViewCell", bundle: nil), forCellReuseIdentifier: "followersa")
        
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
                    self.otherFollowinCount.text = "\(userData.count)"
                    
                    self.otherFollowersTableVIew.reloadData()
                }
             
            case .failure(let err):
                print("Error is \(err)")
                
                
            }
        }
        
        
        
    }
    
    //MARK: - Fetch Followers
    
    func fetchFollowers(otherUserID: String) {
        
        //https://api-space-dev.getfleek.app/users/get_followings?user_id=f18101e2-7247-4749-8a30-eacdec133076
        
        //https://api-space-dev.getfleek.app/users/get_followers
        
        
        let network = NetworkURL()
        
        guard let myURL = URL(string: "https://api-space-dev.getfleek.app/users/get_followers?user_id=\(otherUserID)") else {return}
        
        
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
                    self.otherFollowinCount.text = "Followers \(userData.count)"
                    self.otherFollowersTableVIew.reloadData()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return myFollowers?.count ?? 1
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followersa", for: indexPath) as! FollowersFollowingTableViewCell
        
   
        if let safeIndex = myFollowers?[indexPath.row] {
            cell.setupCell(fromData: safeIndex)
        }
        
        
        return cell
      
    }

}
