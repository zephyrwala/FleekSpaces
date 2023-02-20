//
//  ChatKitViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/07/22.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class RecentChatKitViewController: UIViewController, UICollectionViewDelegate {
    


    private var dbUsers = [[String: String]]()
    @IBOutlet weak var newChatButton: UIButton!
    var recentMessages = [RecentMessage]()
    private var firestoreListener: ListenerRegistration?
    let sec1 = "sec1ID"
    @Published var chatUser: ChatUser?
    var userData: VerifyOTP?
    @IBOutlet weak var currentUserImage: UIImageView!
    @IBOutlet weak var currentUserName: UILabel!
    @IBOutlet weak var recentMessagesCollectionView: UICollectionView!
    var defautls = UserDefaults.standard
    private var conversations = [Conversation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
//        RealTimeDatabaseManager.shared.test()
        
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
//        startListeningForConversations()
       
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
    
    
    
    @IBAction func addChatBtnTap(_ sender: Any) {
        
     
        
        newChatUserPop()
        
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true)
    }
    
    func newChatUserPop() {
        
        let vc = NewChatUsersVC()
        vc.completion = {[weak self] result in
            print("\(result)")
            self?.createnewConversation(result: result)
            
        }
      
        vc.modalPresentationStyle = .pageSheet
        
//        let navs =
//        let nav = UINavigationController(rootViewController: vc)
//
       
        // 1
//        nav.modalPresentationStyle = .pageSheet

        
        // 2
        if let sheet = vc.sheetPresentationController {

            // 3
            sheet.detents = [.medium(), .large()]

        }
        // 4
//        present(nav, animated: true, completion: nil)
     
        present(vc, animated: true)

    }
    
    
    @IBAction func newChatBtnTapAction(_ sender: Any) {
        
        let vc = NewChatUsersVC()
        vc.completion = {[weak self] result in
            print("\(result)")
            self?.createnewConversation(result: result)
            
        }
        
        self.present(vc, animated: true)
        
        
    }
    
    
    
    
    //MARK: - New conversation is created here
    private func createnewConversation(result: [String: String]) {
        
        guard let name = result["name"],
                let email = result["email"] else {
            return
            
        }
        
        defautls.set(email, forKey: "otherUserEmail")
        
        let vc = ChatViewController(with: email, id: nil)
        
        //FIXME: - Id is nil over here???
//        controllers.modalPresentationStyle = .fullScreen
        vc.isNewConversation = true
        vc.title = name
        navigationController?.pushViewController(vc, animated: true)
        
    }
//
//    private func startListeningForConversations() {
//
//        guard let email = defautls.string(forKey: "email") else {return}
//
//        let safeEmail = RealTimeDatabaseManager.safeEmail(emailAddress: email)
//        RealTimeDatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
//            switch result {
//            case .success(let conversations):
//                print("successfully got conversation models")
//                guard !conversations.isEmpty else {
//                    self?.recentMessagesCollectionView.isHidden = true
////                    self?.noConversationsLabel.isHidden = false
//                    return
//                }
////                self?.noConversationsLabel.isHidden = true
//                self?.recentMessagesCollectionView.isHidden = false
//                self?.conversations = conversations
//
//                DispatchQueue.main.async {
//                    self?.recentMessagesCollectionView.reloadData()
//                }
//            case .failure(let error):
//                self?.recentMessagesCollectionView.isHidden = true
////                self?.noConversationsLabel.isHidden = false
////                print("failed to get convos: \(error)")
//            }
//        })
//    }
    
    
    
    
 
    
    
    
    
    
    
    
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
                let myGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(680)), subitems: [myItem])
                
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
            
            self.defautls.set(userName, forKey: "email")
            self.defautls.set(imageURL, forKey: "photu")
            DispatchQueue.main.async {
                self.currentUserName.text = FirebaseManager.shared.auth.currentUser?.email
                
               print("username email is \(userName)")
                self.currentUserImage.sd_setImage(with: URL(string: imageURL))
            }
            
        }
        
    }
 

}


extension RecentChatKitViewController: UICollectionViewDataSource {
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        recentMessagesCollectionView.deselectItem(at: indexPath, animated: true)
        let model = recentMessages[indexPath.row]
        let vc = ChatViewController(with: model.email, id: model.id)
        
        vc.thisMessage = model
        vc.title = model.username
        print("\(model.email) and from id \(model.fromId)")
        navigationController?.pushViewController(vc, animated: true)

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
           
//            let model = conversations[indexPath.row]
            let chatData = recentMessages
              

         
            cell.setupCell(fromData: chatData[indexPath.item])
            
         
            print("Cell loaded")
            
            cell.userName.text = recentMessages[indexPath.item].username
            
//            cell.setupCell(fromData: model)
//
            
            
            
            return cell
            
 
            
        
            
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieInfo", for: indexPath) as! MovieInfoCollectionViewCell
            
            
            return cell
            
            
        }
        
        
    }
    
    
}
