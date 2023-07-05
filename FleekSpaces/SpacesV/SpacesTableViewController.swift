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
   
    
    @IBOutlet weak var searchBtnTapped: UIBarButtonItem!
    

    
    
    //MARK: - Notifications tap
    @IBAction func notificationBtn(_ sender: Any) {
        
        let detailViewController = NotificationsTable()
        let nav = UINavigationController(rootViewController: detailViewController)
        // 1
        nav.modalPresentationStyle = .pageSheet

        
        // 2
        if let sheet = nav.sheetPresentationController {

            // 3
            sheet.detents = [.medium(), .large()]

        }
        // 4
        present(nav, animated: true, completion: nil)

        
    }
    var sendFollowers: FollowersRequest?
    var users = [ChatUser]()
    var prog = JGProgressHUD(style: .dark)
    var feedData: [SpacesFeedElement]?
    var followMessage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
       checkSignIn()
        self.tableView.isHidden = true
        
        fetchAllUsers()
        let vc = LoadsViewController()
        vc.loadmeText = "Tuning into your Spaces Feed"
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        
       
       
        tableView.register(UINib(nibName: "SpacesTableViewCell", bundle: nil), forCellReuseIdentifier: "spacesCell")

        self.title = "Spaces"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
       
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkSignIn()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func searchTappedBtn(_ sender: Any) {
        
        
        let controller = SearchViewController()
//        self.present(controller, animated: true)
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    @objc
    func refresh(sender:AnyObject)
    {
        // Updating your data here...

        
        fetchSpacesFeed()
        checkCommon()
        self.tableView.reloadWithAnimation()
        self.refreshControl?.endRefreshing()
    }

    //MARK: - Fetch Spaces Feed
    
    func fetchSpacesFeed() {
        
        
        let network = NetworkURL()
        let myURL = URL(string: "https://api-space-dev.getfleek.app/activity/get_feed/")
        
        guard let myToken = UserDefaults.standard.string(forKey: "userToken") else {return}
        
        network.tokenCalls([SpacesFeedElement].self, url: myURL, token: myToken, methodType: "GET") { myResult, yourMessage in
            
            
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
    
    
    
    func checkSignIn() {
        
        if  FirebaseManager.shared.auth.currentUser == nil {
           loginPrompt()
        } else {
            
            fetchSpacesFeed()
        }
    }
    
    
    //MARK: - Login Prompt
    
    func loginPrompt() {
        
        let actionSheet = UIAlertController(title: "Oops 🤔", message: "You must login to view the Spaces Feed!", preferredStyle: .alert)
        
      
        
       
    
        //TODO: - On Cancel try to push to another view
        
        actionSheet.addAction(UIAlertAction(title: "Log In", style: .default, handler: { [weak self] _ in
            
            
            
            let controller = LoginVC()
                
           
            self?.navigationController?.pushViewController(controller, animated: true)
//            self?.present(controller, animated: true)
            
          
            
        }))
        
        
       
        
       
        
    
        
        present(actionSheet, animated: true)
        
        
    }
    
    //mark: Check common
    func checkCommon() {
        
        
        if let safeFollowers = FinalDataModel.spacesFeedElement {
            
            for chatUser in self.users {
                for getFollower in safeFollowers {
                
                }
               
            }
        }
     
       
       
        
        print("finaldata")
 
    }
    
    
    //    MARK: - users fetch firestore
    private func fetchAllUsers() {
        
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                
                if let error = error {
                  
                    print("Failed to fetch users: \(error)")
                    return
                }
                
             
                
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let user = try? snapshot.data(as: ChatUser.self)
                    if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user!)
                        DispatchQueue.main.async {
                                                  
                        }
                        
                    }
                    
                })
            }
        
    }
    
    //MARK: - Send Follow Request
    
    func sendFollowRequest(firebaseUID: String) {
        
        //https://api-space-dev.getfleek.app/users/follow_user?firebase_uid=0HxLkjzkAiSR0OPUzEs3MeoBjw52
        
        
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/follow_user?firebase_uid=\(firebaseUID)") else {return}
        
        guard let myToken = UserDefaults.standard.string(forKey: "userToken") else {return}
        
        
        network.tokenCalls(FollowersRequest.self, url: myUrl, token: myToken, methodType: "POST") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let userData):
                FinalDataModel.followerRequest = userData
                self.sendFollowers = userData
                DispatchQueue.main.async {
                    
                   
//                    self.followMessage = userData.message ?? "You have succesfully followed."
                       //save in variable
//                    self.watchlistBtn.setTitle("\(userData.count)", for: .normal)
//
                    
                    self.tableView.reloadData()
                }
             
            case .failure(let err):
                print("Error is \(err)")
                
                
            }
        }
        
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 900
        } else {
           return 600
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spacesCell", for: indexPath) as! SpacesTableViewCell
        if let spacesData = FinalDataModel.spacesFeedElement?[indexPath.item] {
            
            cell.likeBtnDelegate = self
            cell.followBtnDelegate = self
            cell.watchlistbtnDelegate = self
//            cell.openUserProfileDelegate = self
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
        
//
//        print("this is UID \(FinalDataModel.spacesFeedElement?[indexPath.item].user?.firebaseUid)")
//
//        if let safeModel = FinalDataModel.spacesFeedElement?[indexPath.item].postersURL {
//            print("https://image.tmdb.org/t/p/w500\(safeModel)")
//        }
        
        
        if let types = FinalDataModel.spacesFeedElement?[indexPath.item].showType {
            
            
            switch types {
                
            case .movie :
                print("Selected is movie")
                var selectedController = MovieDetailViewController()
                
                if let movieDataId = FinalDataModel.spacesFeedElement?[indexPath.item].showID {
                    
                    selectedController.movieId = movieDataId
                    selectedController.fetchMovieDetails(movieID: movieDataId)
                    
                  
                    
                }
                
                navigationController?.pushViewController(selectedController, animated: true)
                
            case .tvSeries :
                print("Selected is tv show")
                var selectedController = TVDetailViewController()
                
                
                if let movieDataId = FinalDataModel.spacesFeedElement?[indexPath.item].showID {
                    
                    selectedController.showId = movieDataId
                    selectedController.fetchMovieDetails(movieID: movieDataId)
                    
                  
                    
                }
                
                navigationController?.pushViewController(selectedController, animated: true)
                
            }
            
            
            
        }
       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      
        return FinalDataModel.spacesFeedElement?.count ?? 1
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


extension UITableView {

    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
       
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}





extension UICollectionView {

    func reloadWithAnimation() {
        
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
       
       
        for cell in cells {
            cell.alpha = 0
            UIView.animate(withDuration: 6, delay: 0.9) {
                
                cell.alpha = 1
            }
        }
        
    }
}


