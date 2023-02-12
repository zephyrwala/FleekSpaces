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



class NewChatUsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let spinny = JGProgressHUD(style: .light)
    //store the users from reatime db here
    private var dbUsers = [[String: String]]()
 
    public var completion: (([String: String]) -> (Void))?
    
   var db = Database.database().reference()

    @IBOutlet weak var testTable: UITableView!
    
    var users = [ChatUser]()
    
    var errorMessage = ""
//    let didSelectnewUser: (ChatUser) -> ()
    override func viewDidLoad() {
        super.viewDidLoad()

//        spinny.show(in: view)
        fetchAllUsers()
     
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
    
    //MARK: - users fetch from Realtime db



//    func getAllDBUsers() {
//
//        RealTimeDatabaseManager.shared.getAllUsers { [weak self] result in
//
//            switch result {
//
//            case .success(let usersColl):
//                self?.dbUsers = usersColl
//                DispatchQueue.main.async {
//
//                    self?.spinny.dismiss()
//                    self?.testTable.reloadData()
//                }
//
//            case .failure(let err):
//                print("Failed to get users \(err)")
//
//
//            }
//
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //start conversation
        let targetuserData = dbUsers[indexPath.row]
        dismiss(animated: true) { [weak self] in
        self?.completion?(targetuserData)
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
