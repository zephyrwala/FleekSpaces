//
//  OtherproFollowingsaViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/03/23.
//

import UIKit

class OtherproFollowingsaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var otherFollowingLabel: UILabel!
    var myFollowers : [GetFollower]?
    var myFollowing : [GetFollower]?
    @IBOutlet weak var otherFollowingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        guard let otherUserID = UserDefaults.standard.string(forKey: "otherUserID") else {return}
        fetchFollowings(otherUserID: otherUserID)
        // Do any additional setup after loading the view.
    }

    
    //setup table view
    func setupTableView() {
        
        otherFollowingTableView.delegate = self
        otherFollowingTableView.dataSource = self
        otherFollowingTableView.register(UINib(nibName: "FollowersFollowingTableViewCell", bundle: nil), forCellReuseIdentifier: "followersa")
        
    }
    

    
    //MARK: - Get Following
    

    
    func fetchFollowings(otherUserID: String) {
        
        //https://api-space-dev.getfleek.app/users/get_followers
        
        
        let network = NetworkURL()
        
        guard let myURL = URL(string: "https://api-space-dev.getfleek.app/users/get_followings?user_id=\(otherUserID)") else {return}
        
        
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
                    self.otherFollowingLabel.text = "\(userData.count) Following"
                    
                    self.otherFollowingTableView.reloadData()
                }
             
            case .failure(let err):
                print("Error is \(err)")
                
                
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return myFollowing?.count ?? 1
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followersa", for: indexPath) as! FollowersFollowingTableViewCell
        
   
        if let safeIndex = myFollowing?[indexPath.row] {
            cell.setupCell(fromData: safeIndex)
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
