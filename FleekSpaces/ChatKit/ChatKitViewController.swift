//
//  ChatKitViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/07/22.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ChatKitViewController: UIViewController, UICollectionViewDelegate {
    


   
    @IBOutlet weak var newChatButton: UIButton!
    var recentMessages = [RecentMessage]()
    private var firestoreListener: ListenerRegistration?
    let sec1 = "sec1ID"
    @Published var chatUser: ChatUser?
    var userData: VerifyOTP?
    @IBOutlet weak var currentUserImage: UIImageView!
    @IBOutlet weak var currentUserName: UILabel!
    @IBOutlet weak var recentMessagesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RealTimeDatabaseManager.shared.test()
        
        if FirebaseManager.shared.auth.currentUser?.uid != nil {
           
            print("user is logged in")
        } else {
            self.tabBarController?.selectedIndex = 2
//            let loginVC = LoginVC()
//            self.present(loginVC, animated: true)
        }
        setupCollectionView()
        currentUserImage.makeItGolGol()
       
        fetchCurrentUser()
        fetchRecentMessages()
        recentMessagesCollectionView.reloadData()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        handleSignOut()
        if FirebaseManager.shared.auth.currentUser?.uid == nil {
            let loginVC = LoginVC()
            self.present(loginVC, animated: true)
        }
        
    }
    
    
    func handleSignOut() {
      
        try? FirebaseManager.shared.auth.signOut()
       
        
    }
    @IBAction func newChatBtnTapAction(_ sender: Any) {
        
        let vc = NewChatUsersVC()
        vc.completion = {[weak self] result in
            print("\(result)")
            self?.createnewConversation(result: result)
            
        }
        
        self.present(vc, animated: true)
        
        
    }
    
    
    private func createnewConversation(result: [String: String]) {
        
        
        let controllers = ChatsViewController()
//        controllers.modalPresentationStyle = .fullScreen
       
        controllers.title = "Jenny Smith"
        navigationController?.pushViewController(controllers, animated: true)
        
    }
    
    //MARK: - Fetch recent Messages
     func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
         firestoreListener?.remove()
         self.recentMessages.removeAll()
        
       firestoreListener = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                
                if let error = error {
                    print("failed to listen to recent messages \(error)")
                    self.displayUIAlert(yourMessage: "failed to listen to recent messages \(error)")
                    return
                }
                
                
                
                
                querySnapshot?.documentChanges.forEach({ change in
                    

                        let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        
                        return rm.id == docId
                    })
                    {
                        self.recentMessages.remove(at: index)
                    }
                   
                    DispatchQueue.main.async {
                        
                  
                    do {
                        
                        let rm = try change.document.data(as: RecentMessage.self)
                       
                            self.recentMessages.insert(rm, at: 0)
                            if let safeData = MyMovieDataModel.recentChat {
                                self.recentMessages = safeData
                                
                               
                            }
//                        DispatchQueue.main.async {
                            print("This is recent message: \(self.recentMessages)")
                            self.recentMessagesCollectionView.reloadData()
//                        }
                       
                        
                    } catch {
                        
                        print(error)
                    }
                    }
                    
                    
                    
                    
               
                })
            }
        
    }
    
    
    //MARK: - Setup CollectionView
    
    func setupCollectionView() {
        
        //delegates
        
        recentMessagesCollectionView.delegate = self
        recentMessagesCollectionView.dataSource = self
        recentMessagesCollectionView.collectionViewLayout = layoutCells()
        
        
        //register the cells
        
        recentMessagesCollectionView.register(UINib(nibName: "RecentChatViewCell", bundle: nil), forCellWithReuseIdentifier: "recentChatCell")
        
        //headers if any
        
        
        
        
    }
    
    
    //MARK: - Layout cell
    
    func layoutCells() -> UICollectionViewCompositionalLayout {
        
        
     
        //start
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
                
       
                
            case 0:
                
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
//                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(0.99), heightDimension: .absolute(45)), elementKind: self.sec1, alignment: .top)
              
                section.boundarySupplementaryItems = [header]
                
                
                return section
                
            
            
                
                
                
                
            default:
                let myItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                myItem.contentInsets.trailing = 10
                myItem.contentInsets.bottom = 10
                myItem.contentInsets.leading = 10
                myItem.contentInsets.top = 10
                
                
                //group size
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(480)), subitems: [myItem])
                
                //section size
                
                let section = NSCollectionLayoutSection(group: myGroup)
                
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
             
                
                
                return section
                    

            }
            
        }
        //end
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
        
        
    }
    

    
    //MARK: - Fetch Current user
    func fetchCurrentUser() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.displayUIAlert(yourMessage: "Could not find firebase uid")
            return
        }
        
        DispatchQueue.main.async {
            self.currentUserName.text = FirebaseManager.shared.auth.currentUser?.email
//            self.currentUserImage.sd_setImage(with: URL(string: imageURL))
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.displayUIAlert(yourMessage: "Failed to fetch current user: \(error)")
                print("Failed to fetch current user:", error)
                return
            }
            
            self.chatUser = try? snapshot?.data(as: ChatUser.self)
            FirebaseManager.shared.currentUser = self.chatUser
            
            guard let imageURL = self.chatUser?.profileImageUrl else {return}
            guard let userName = self.chatUser?.email else {return}
            
            
            DispatchQueue.main.async {
                self.currentUserName.text = FirebaseManager.shared.auth.currentUser?.uid
                self.currentUserImage.sd_setImage(with: URL(string: imageURL))
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


extension ChatKitViewController: UICollectionViewDataSource {
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controllers = ChatsViewController()
//        controllers.modalPresentationStyle = .fullScreen
       
        controllers.title = "Chato"
        navigationController?.pushViewController(controllers, animated: true)
//        controllers.modalPresentationStyle = .overCurrentContext
//     present(controllers, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return recentMessages.count
        
            
            
        default:
            return 1
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentChatCell", for: indexPath) as! RecentChatViewCell
           
//            if let chatData = recentMessages {
//                cell.setupCell(fromData: chatData[indexPath.item])
//
//            }
            print("Cell loaded")
            
//            cell.userName.text = recentMessages[indexPath.item].username
            
            cell.setupCell(fromData: recentMessages[indexPath.item])
            return cell
            
 
            
        
            
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieInfo", for: indexPath) as! MovieInfoCollectionViewCell
            
            
            return cell
            
            
        }
        
        
    }
    
    
}
