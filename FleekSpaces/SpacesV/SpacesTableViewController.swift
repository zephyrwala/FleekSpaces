//
//  SpacesTableViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 22/02/23.
//

import UIKit
import SDWebImage
import JGProgressHUD

class SpacesTableViewController: UITableViewController, PassLikesData, FollowBtnTap {
    func followBtnTap(sender: UIButton) {
        let alert = UIAlertController(title: "Oops! 🥹", message: "I'm still working on this feature, please be patient.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { alerts in
            
           
            self.navigationController?.popToRootViewController(animated: true)
            
//            self.dismiss(animated: true) {
//                NotificationCenter.default.post(name: NSNotification.Name("startSwiftUI"), object: nil)
//            }
        }))
        present(alert, animated: true)
    }
    
  
    func spacesLikeBtnTap(_ cell: SpacesTableViewCell) {
        cell.likeBtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        cell.lottiePlay()
        cell.likeBtn.tintColor = .systemTeal
       
            
        
       
       
        
    }
    

    var users = [ChatUser]()
    var prog = JGProgressHUD(style: .dark)
    var feedData: [SpacesFeedElement]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.isHidden = true
        
        
        let vc = LoadsViewController()
        vc.loadmeText = "Spaces (alpha) is loading . . .                               This is an alpha build and work in progress, stay tuned for further updates"
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
                  
  
                    for eachMovie in movieData {
                        
                       print("testing user relate")
                    }
                 
                    
                case .failure(let err):
                    print("Failure in movie fetch")
   
                    
                }
            }
      
            
        }
        
        
    }
    
    
    
    //    MARK: - users fetch firestore
    private func fetchAllUsers() {
        
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                
                if let error = error {
                    
//                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
//                self.errorMessage = "Fetched users succesfully"
                
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let user = try? snapshot.data(as: ChatUser.self)
                    if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user!)
                        DispatchQueue.main.async {
//                            self.testTable.reloadData()
                          
                            //                            self.spinny.dismiss(animated: true)
                        }
                        
                    }
                    
                })
            }
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spacesCell", for: indexPath) as! SpacesTableViewCell
        if let spacesData = FinalDataModel.spacesFeedElement?[indexPath.item] {
            
            cell.likeBtnDelegate = self
            cell.followBtnDelegate = self
            cell.setupCell(fromData: spacesData )
            cell.selectionStyle = .none
            cell.selectedBackgroundView?.backgroundColor = .black
            
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
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // ...
        
        let action = UIContextualAction(style: .normal,
                                        title: "Like 👍🏼") { [weak self] (action, view, completionHandler) in
                                            self?.handleMarkAsFavourite()
                                            completionHandler(true)
        }
        action.backgroundColor = .black
        
        return UISwipeActionsConfiguration(actions: [action])
    }

    
    override func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        // ...
        
        
        let action = UIContextualAction(style: .normal,
                                        title: "Watchlist 📺") { [weak self] (action, view, completionHandler) in
                                            self?.handleMarkAsFavourite()
                                            completionHandler(true)
        }
        action.backgroundColor = .black
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    private func handleMarkAsFavourite() {
        print("Marked as favourite")
    }

    private func handleMarkAsUnread() {
        print("Marked as unread")
    }

    private func handleMoveToTrash() {
        print("Moved to trash")
    }

    private func handleMoveToArchive() {
        print("Moved to archive")
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
