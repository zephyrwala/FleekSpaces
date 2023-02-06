//
//  ChatViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 06/06/22.
//

import UIKit
import JGProgressHUD
import SwiftUI
import IQKeyboardManagerSwift
//import IQKeyboardManagerSwift

struct Conversation {
    
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
    
}

struct DemoConversation {
    
    let id: String
    let name: String
    let otherUserEmail: String
   
    
}

struct LatestMessage {
    
    let date: String
    let text: String
    let isRead: Bool
}

class ChatUIViewController: UIViewController {
    
   

   
    private var conversations = [Conversation]()
    let demoChat = [DemoConversation(id: "1", name: "mohan", otherUserEmail: " Mohan lal is sick"),
    DemoConversation(id: "2", name: "Baban", otherUserEmail: "Baban is happy with his life")
    ]
    @IBOutlet weak var chatView: UIView!
    private let spinner = JGProgressHUD(style: .dark)
  
    @IBOutlet weak var bannerBgView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    
    @IBOutlet weak var addChatBtn: UIButton!
    @IBOutlet weak var inviteBtn: UIButton!
    
    private let tableView: UITableView = {
        
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(UINib(nibName: "ConversationsTableViewCell", bundle: nil),            forCellReuseIdentifier: "chatCell")
        
        return table
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.backgroundColor = UIColor(named: "BGColor")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        IQKeyboardManager.shared.enable = false
       
        overrideUserInterfaceStyle = .dark
//        chatView.addSubview(tableView)
////        setupTableView()
//
        self.navigationController?.navigationItem.hidesBackButton = true
        
        btnSetup()
//
    }
    

    //TODO: - Need to fix the login pop ups
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
//        IQKeyboardManager.shared.enable = false
       
        overrideUserInterfaceStyle = .dark
//        chatView.addSubview(tableView)
////        setupTableView()
//
        self.navigationController?.navigationItem.hidesBackButton = true
        
        btnSetup()
//        startListeningForConversation()
        
        if FirebaseManager.shared.auth.currentUser?.uid != nil {
           
            print("user is logged in")
            let controllers = UIHostingController(rootView: MainMessagesView())
    //        controllers.modalPresentationStyle = .fullScreen
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(controllers, animated: true)
//            controllers.modalPresentationStyle = .overCurrentContext
//         present(controllers, animated: true)
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("startSwiftUI"), object: nil, queue: nil) { (_) in
                
                print("user is logged in")
                let controllers = UIHostingController(rootView: MainMessagesView())
        //        controllers.modalPresentationStyle = .fullScreen
                self.navigationItem.leftBarButtonItem = nil;
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //        self.navigationController?.pushViewController(controllers, animated: true)
                controllers.modalPresentationStyle = .overCurrentContext
                self.present(controllers, animated: true)
              
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("dismissSwiftUI"), object: nil, queue: nil) { (_) in
                controllers.dismiss(animated: true) {
                    
                    let loginVC = LoginVC()
                    self.present(loginVC, animated: true)
                    
                }
            }
            
            
        } else {
           basicPrompt()
        }
//        if FirebaseManager.shared.currentUser

      
//        presentModal()
        // Do any additional setup after loading the view.
        
        
    }
    
    
    func basicPrompt() {
        
        let actionSheet = UIAlertController(title: "Ooops!", message: "You must login to access this section", preferredStyle: .alert)
        
        
        actionSheet.addAction(UIAlertAction(title: "Log in", style: .default, handler: { [weak self] _ in
            
            if let strongSelf = self {
                
              
                let loginVC = LoginVC()
                self?.navigationController?.pushViewController(loginVC, animated: true)
                
                print("strong self and like generatoed for movies")
            }
     
           
            
          
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        
    
        
        present(actionSheet, animated: true)
        
        
    }
    
    
    
    @IBAction func chatBtnTap(_ sender: Any) {
        
//        self.displayUIAlert(yourMessage: "Chat Module will be coming soon!")
        let newController = NewConversationViewController()
        newController.completion = {[weak self] result in
            print("\(result)")
            self?.createNewConversation(result: result)
            
        }
        let navVC = UINavigationController(rootViewController: newController)
        present(navVC, animated: true)
    }
    
    
    
    
    private func createNewConversation(result: [String: String]) {
        
       

        guard let name = result["name"], let email = result["email"] else {
            return
        }
        
////        let selectedController = ChatLayoutViewController(with: email, id: nil)
//        selectedController.isNewConversation = true
//        selectedController.title = name
//        selectedController.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(selectedController, animated: true)
    }
    
   
    
    func btnSetup() {
        inviteBtn.layer.cornerRadius = 8
        addChatBtn.layer.borderWidth = 1
        addChatBtn.layer.masksToBounds = true
        addChatBtn.layer.borderColor = UIColor.systemGray.cgColor
         
        addChatBtn.layer.cornerRadius = addChatBtn.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        addChatBtn.clipsToBounds = true
        
    }

    @IBAction func inviteFriendstap(_ sender: Any) {
        
        let shareText = "👋🏻 Hey Bro! I'm inviting you to chat 💬 with me on Fleek Spaces 🍿 on https://getfleek.app/"
        let textShare = [shareText]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func presentModal() {
        let detailViewController = SignInViewController()
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

 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


