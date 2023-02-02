//
//  NewChatUsersVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 19/09/22.
//

import UIKit
import SDWebImage

class NewChatUsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
 
    public var completion: (([String: String]) -> (Void))?

    @IBOutlet weak var testTable: UITableView!
    
    var users = [ChatUser]()
    
    var errorMessage = ""
//    let didSelectnewUser: (ChatUser) -> ()
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAllUsers()
        testTable.delegate = self
        testTable.dataSource = self
        testTable.register(UINib(nibName: "NewChatsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsuser")

        // Do any additional setup after loading the view.
    }

    
    
    //users fetch
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
                        }
                       
                    }
                    
                })
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
        users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let targetuserData = users[indexPath.row]
        dismiss(animated: true) { [weak self] in
//            self?.completion?(targetuserData)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsuser", for: indexPath) as! NewChatsTableViewCell
        
        cell.userNameLabel.text = users[indexPath.item].email
        
        if let imageURL = URL(string: "\(users[indexPath.item].profileImageUrl)") {
            
            cell.profiles.sd_setImage(with: imageURL)
        }
       
        
        return cell
    }

}
