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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setupTableView()
        
        // Do any additional setup after loading the view.
    }


    //setup table view
    func setupTableView() {
        
        followersTableView.delegate = self
        followersTableView.dataSource = self
        followersTableView.register(UINib(nibName: "FollowersFollowingTableViewCell", bundle: nil), forCellReuseIdentifier: "followersa")
        
    }
    
  
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followersa", for: indexPath) as! FollowersFollowingTableViewCell
        
        return cell
    }
    
    

}
