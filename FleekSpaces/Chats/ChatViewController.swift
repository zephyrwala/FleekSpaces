//
//  ChatViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 06/06/22.
//

import UIKit
import JGProgressHUD

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

class ChatViewController: UIViewController {
    
   

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

        chatView.addSubview(tableView)
        setupTableView()
        fetchConversations()
        btnSetup()
        startListeningForConversation()
      
//        presentModal()
        // Do any additional setup after loading the view.
    }
    
    private func startListeningForConversation() {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {return}
        
        print("Startig conversation fetch...")
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        DatabaseManager.shared.getAllConversations(for: safeEmail) { [weak self] results in
            
            switch results {
                
            case .success(let loadedConversations):
                print("Succesfulyl got conversation")
                guard !loadedConversations.isEmpty else {
                    return
                }
                self?.conversations = loadedConversations
                DispatchQueue.main.async {
                    print("reloading table view")
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("failed to get convos : \(error)")
                
            }
        }
        
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
        
        var selectedController = ChatLayoutViewController(with: email)
        selectedController.isNewConversation = true
        selectedController.title = name
        selectedController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(selectedController, animated: true)
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
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

    private func fetchConversations() {
        
        tableView.isHidden = false
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


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ConversationsTableViewCell
//        cell.textLabel?.text = "Babu Rao"
//        cell.userName.text = "Babu Rao"
//        cell.userConversation.text = "This is my chat conversations"
       
        cell.configure(with: model)
//        cell.userName.text = demoChat[indexPath.item].name
//        cell.userConversation.text = demoChat[indexPath.item].otherUserEmail
        cell.userName.text = model.name
        cell.userConversation.text = model.latestMessage.text
        cell.backgroundColor = UIColor(named: "BGColor")
        cell.selectionStyle = .gray
     
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

          return 72
      }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        let model = conversations[indexPath.row]
        var selectedController = ChatLayoutViewController(with: model.otherUserEmail)
//        navigationController?.pushViewController(selectedController, animated: true)
//        self.present(selectedController, animated: true)
        selectedController.title = model.name
        selectedController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(selectedController, animated: true)
    }
}
