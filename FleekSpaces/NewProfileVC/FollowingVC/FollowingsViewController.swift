//
//  FollowingsViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 12/03/23.
//

import UIKit

class FollowingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    

    @IBOutlet weak var followingTableView: UITableView!
    var myFollowers : [GetFollower]?
    
    @IBOutlet weak var myFollowersCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        fetchFollowings()
        setupTableView()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchFollowers()
    }
    
    func setupTableView() {
        
        followingTableView.delegate = self
        followingTableView.dataSource = self
        followingTableView.register(UINib(nibName: "FollowersFollowingTableViewCell", bundle: nil), forCellReuseIdentifier: "followersa")
        
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
                    self.myFollowersCount.text = "\(userData.count) Followers"
                    self.followingTableView.reloadData()
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

}
