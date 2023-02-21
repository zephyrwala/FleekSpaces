//
//  NewChatUsersVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 19/09/22.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import JGProgressHUD


struct RecentUsersModel {
    var uid: String
    var emailID: String
}

class NewChatUsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("saerch tap")
    }
    
    
    var recentUID = [String]()
    var recentUserspass = [RecentUsersModel]()
    public var completion: ((ChatUser) -> (Void))?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private let spinny = JGProgressHUD(style: .light)
    //store the users from reatime db here
    private var dbUsers = [[String: String]]()
    
//    public var completion: (([String: String]) -> (Void))?
    
    var db = Database.database().reference()
    
    @IBOutlet weak var testTable: UITableView!
    
    var users = [ChatUser]()
    
    var errorMessage = ""
    //    let didSelectnewUser: (ChatUser) -> ()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.title = "New Chat"
        
        //        spinny.show(in: view)
        fetchAllUsers()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        testTable.tableHeaderView = searchController.searchBar
        //        testTable.tableHeaderView?.constraints =
        
        self.navigationController?.navigationBar.isHidden = true
        searchController.searchBar.barStyle = .default
        searchController.searchBar.tintColor = .systemTeal
        searchController.searchBar.searchBarStyle = .minimal
        fetchRecentChatUsers()
        
        //        searchController.searchBar.showsCancelButton = false
        
        
        
        
        
        testTable.delegate = self
        testTable.dataSource = self
        testTable.register(UINib(nibName: "NewChatsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsuser")
        
        // Do any additional setup after loading the view.
    }
    
    
    
    //    MARK: - users fetch firestore
    private func fetchAllUsers() {
        
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                
                if let error = error {
                    
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                self.errorMessage = "Fetched users succesfully"
                
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let user = try? snapshot.data(as: ChatUser.self)
                    if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user!)
                        DispatchQueue.main.async {
                            self.testTable.reloadData()
                            //                            self.spinny.dismiss(animated: true)
                        }
                        
                    }
                    
                })
            }
        
    }
    
    //MARK: - Check if user exists
    
    func ifUserExists(user: ChatUser, completion: @escaping (Bool) -> Bool) {
        
        
        //
        
        users.contains { eachUser in
            
            if eachUser.uid != user.uid {
                
                return false
            } else {
                
                return true
            }
            
            return false
        }
        
        //        let result = users.contains(where: {$0.uid.contains(user.uid)}
        
        //        print("RESULT is \(result)")
    }
    
    
    public enum DatabaseError: Error {
        case failedToFetch
        
        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
    }
    
    func fetchRecentChatUsers() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        FirebaseManager.shared.firestore.collection("recent_messages").document(uid).collection("messages").getDocuments { documentsSnapshot, error in
            
            if let safeDocs = documentsSnapshot?.documents {
                
                for eachDocument in safeDocs {
                    
                    
                    self.recentUID.append(eachDocument.documentID)
                    print("safe doc is \(eachDocument.documentID)")
                    
                    
                    
                }
                
            }
            
            
            
            
        }
    }
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            users.count
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //start conversation
            //        let targetuserData = dbUsers[indexPath.row]
            //        dismiss(animated: true) { [weak self] in
            //        self?.completion?(targetuserData)
            //        }
            
            
            let numbers = recentUID
            let safeUsers = users[indexPath.item]
            let contains = numbers.contains(where: { $0 == safeUsers.uid })
            
//            print("contains \(contains)")
            print("This has been selected email \(safeUsers.email) and id \(safeUsers.uid) - does it exists: \(contains)")
            
            let targetuserData = safeUsers
            self.dismiss(animated: true) {
                self.completion?(targetuserData)
            
            }
            //dismiss and start the conversation
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsuser", for: indexPath) as! NewChatsTableViewCell
            
            cell.userNameLabel.text = users[indexPath.item].email
            
            //        cell.userNameLabel.text = user[indexPath.item]["name"]
            
            
            if let imageURL = URL(string: users[indexPath.item].profileImageUrl) {
                
                print("image url is \(imageURL)")
                cell.profiles.sd_setImage(with: imageURL)
            }
            
            
            return cell
        }
        
    }

