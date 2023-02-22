//
//  SpacesTableViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 22/02/23.
//

import UIKit
import SDWebImage
import JGProgressHUD

class SpacesTableViewController: UITableViewController {

    var prog = JGProgressHUD(style: .dark)
    var feedData: [SpacesFeedElement]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        let vc = LoadsViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        
       
       
        tableView.register(UINib(nibName: "SpacesTableViewCell", bundle: nil), forCellReuseIdentifier: "spacesCell")

        self.title = "Spaces"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        fetchSpacesFeed()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc
    func refresh(sender:AnyObject)
    {
        // Updating your data here...

        fetchSpacesFeed()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    //MARK: - Fetch Spaces Feed
    
    func fetchSpacesFeed() {
        
        
        let network = NetworkURL()
        let url = URL(string: "https://api-space-dev.getfleek.app/activity/get_feed/")
        
        network.theBestNetworkCall([SpacesFeedElement].self, url: url) { myResult, yourMessage in
            
            DispatchQueue.main.async {
                switch myResult {
                    
                case .success(let movieData):
                    print("Movie is here \(movieData)")
                   
                    DispatchQueue.main.async {
                        FinalDataModel.spacesFeedElement = movieData
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                  
  
                 
                    
                case .failure(let err):
                    print("Failure in movie fetch")
   
                    
                }
            }
      
            
        }
        
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spacesCell", for: indexPath) as! SpacesTableViewCell
        if let spacesData = FinalDataModel.spacesFeedElement?[indexPath.item] {
            
            cell.setupCell(fromData: spacesData )
            
            
        }
       
//        }
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let safeModel = FinalDataModel.spacesFeedElement?[indexPath.item].postersURL {
            print("https://image.tmdb.org/t/p/w500\(safeModel)")
        }
       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      
        return FinalDataModel.spacesFeedElement?.count ?? 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
