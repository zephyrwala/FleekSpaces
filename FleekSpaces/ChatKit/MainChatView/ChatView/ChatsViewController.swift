//
//  ChatsViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 19/07/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import SDWebImageSwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore





class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, UIColorPickerViewControllerDelegate  {
   
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.bubbleColor = viewController.selectedColor
        
        self.messagesCollectionView.reloadData()
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.bubbleColor = viewController.selectedColor
        
        self.messagesCollectionView.reloadData()
    }
    // date formatter returns date string
    public static let dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
        
    }()
    //this is main message
    var fcmTokenofUser = ""
    var currentUser = ""
    let sender = PushNotificationSender()
    
    private var messages = [Message]()
    public let otherUserEmail: String
    private let conversationId: String?
    public var isNewConversation = false
    var defaults = UserDefaults.standard
    let fireDB = Firestore.firestore()
    var newChatThisMessage: ChatUser?
    var thisMessage: RecentMessage?
    let secondChild = RecommendChatViewController()
    var bubbleColor = UIColor.systemTeal
    let picker = UIColorPickerViewController()
//    var fetchedMef
    
    var swiftChat = ChatDataObject.chatMessagesAreHere
  
    var reference: CollectionReference?
    var messageListener: ListenerRegistration?
    
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Mohan")
    private let otherUser = Sender(photoURL: "", senderId: "2", displayName: "Baba Blackshee")
   
    var myMessages = [MessageType]()
    var chatUser: ChatUser?
    var chatMessages = [ChatMessage]()
    var firestoreListener: ListenerRegistration?
    
    
    
    //creating + computing the sender and returning the computed sender
//    private var selfSender: Sender? {
//
//        guard let email = defaults.string(forKey: "email") else {return nil}
//        let safeEmail = RealTimeDatabaseManager.safeEmail(emailAddress: email)
//
//       return Sender(photoURL: "",
//                     senderId: safeEmail,
//                     displayName: "Me")
//
//    }
   
    
    //MARK: - Class Initialiser
    init(with email: String, id: String?) {
        self.conversationId = id
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
        print("Initializer working as ID \(conversationId) and email \(otherUserEmail) ")
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View did appear / view did load
    // view did appear for first responder keyboard
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        fetchMessages()
        
        
        configureMessageInputBar()
//        messageInputBar.inputTextView.becomeFirstResponder()
        let secondVC = RecommendChatViewController()
              secondVC.movieDelegate = self
        
        setupInputButton()
        setupUIStuff()
//        fireTest()
       
     
      
      

        
    }
    
    deinit {
        messageListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        print("current user is \(currentUser)")
//        fetchFCM(userEmail: self.currentUser)
        fetchFCM(userEmail: otherUserEmail)
        picker.delegate = self
        let secondVC = RecommendChatViewController()
        secondVC.movieDelegate = self
        fireTest()
        setupInputButton()
        setupUIStuff()
      
        let bgImage = UIImageView();
            bgImage.image = UIImage(named: "spa_patt");
        bgImage.contentMode = .scaleToFill


        setupProfileImage()
        self.messagesCollectionView.backgroundView = bgImage

     
       
    }
    
    
    //MARK: - Setup Profile Image
    func setupProfileImage() {
        
        //create a new button
               let button = UIButton(type: .custom)
               //set image for button
       
        let profileImage = UIImage(named: "a1")
       
        let avatarImage = UIImageView()
                avatarImage.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        avatarImage.layer.cornerRadius = 10
        
        avatarImage.makeItGolGol()
        
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clipsToBounds = true
        if let photoUrl =  thisMessage?.profileImageUrl {
            if let safeURL = URL(string: photoUrl) {
            print("safe photo url \(safeURL)")
            avatarImage.sd_setImage(with: safeURL, placeholderImage: UIImage(named: "a1"), options: [.refreshCached, .retryFailed]) { (image, error, type, url) in
                if let image = image {
                   
                    button.setImage(image, for: .normal)
                }
            }
        }
        }
      
        
//        button.imageView?.layer.cornerRadius = 20
//        button.setImage(profileImage, for: .normal)
      
        button.imageView?.contentMode = .scaleAspectFill
            button.imageView?.layer.cornerRadius = 9
        button.imageView?.layer.borderWidth = 1.5
        button.imageView?.layer.borderColor = UIColor.black.cgColor
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
//        button.translatesAutoresizingMaskIntoConstraints = false
               //add function for button
               button.addTarget(self, action: #selector(fbButtonPressed), for: .touchUpInside)
               //set frame
               button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)

               let barButton = UIBarButtonItem(customView: button)
               //assign button to navigationbar
               self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    //This method will call when you press profile button.
        @objc func fbButtonPressed() {

            print("Share to fb")
            let vc = ChatDetailProfileViewController()
            if let safeURL = thisMessage?.profileImageUrl {
                vc.profileImageUrls = safeURL
            }
           
            if let safeID = conversationId {
                vc.otherUserIDis = safeID
            }
           
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    
    
    //MARK: - Recommend pop up
    func addSecondChild() {
        
        let vc = RecommendChatViewController()
        
        self.present(vc, animated: true)
    }
    
    
    
    //MARK: - Picker Config
    
    func pickerControl() {
        picker.selectedColor = self.bubbleColor
       
       
        // 1
        picker.title = "Choose Chat Bubble Color!"
        picker.modalPresentationStyle = .pageSheet

        
        // 2
        if let sheet = picker.sheetPresentationController {

            // 3
            sheet.detents = [.medium(), .large()]

        }
        // 4
        self.present(picker, animated: true, completion: nil)

//        self.present(picker, animated: true)
    }
    
    
    //MARK: - Watchlist
    
    private func presentWatchlist() {
        let detailViewController = RecommendChatViewController()
        detailViewController.recommendToUid = conversationId
        detailViewController.movieDelegate = self
        detailViewController.selectedOption = 0
        let nav = UINavigationController(rootViewController: detailViewController)
        // 1
        nav.modalPresentationStyle = .pageSheet

        
        // 2
        if let sheet = nav.sheetPresentationController {

            // 3
            sheet.detents = [.medium()]

        }
        // 4
        present(nav, animated: true, completion: nil)

    }
    
    
    //MARK: - Like List
    private func presentLikeList() {
        let detailViewController = RecommendChatViewController()
        detailViewController.movieDelegate = self
        detailViewController.selectedOption = 1
        let nav = UINavigationController(rootViewController: detailViewController)
        // 1
        nav.modalPresentationStyle = .pageSheet

        
        // 2
        if let sheet = nav.sheetPresentationController {

            // 3
            sheet.detents = [.medium()]

        }
        // 4
        present(nav, animated: true, completion: nil)

    }
    
    //MARK: - Fetch FCM for the other user
    
    func fetchFCM(userEmail: String) {
        
        let network = NetworkURL()
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/users/get_firebase_token?email=\(userEmail)") else {
            print("Bad url https://api-space-dev.getfleek.app/users/get_firebase_token?email=\(userEmail)")
            return}
        
                network.loginCalls(FCMToken.self, url: myUrl) { myResult, yourMessage in
                    
                    
                    switch myResult {
                        
                    case .success(let fcm):
                        print("Here is the token of this user \(fcm.fcmToken) and \(fcm)")
                        guard let safeFCMtoken = fcm.fcmToken else {return}
                       
                        self.fcmTokenofUser = safeFCMtoken
                        
                        print("user fcm \(self.fcmTokenofUser)")
                        
                    case .failure(let err):
                        print("Failure coz of fcm tok \(err)")
                        
                    }
                    
                    
                    
                }
        
    }
    
    
    //MARK: - Input action sheet
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Options",
                                            message: "What would you like to share?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "📺 Watchlist", style: .default, handler: { [weak self] _ in
            self?.presentWatchlist()
        }))
        actionSheet.addAction(UIAlertAction(title: "👍🏼 Likes", style: .default, handler: { [weak self]  _ in
            self?.presentLikeList()
        }))
        actionSheet.addAction(UIAlertAction(title: "🎨 Customise", style: .default, handler: {  _ in

            self.pickerControl()
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
       
        present(actionSheet, animated: true)
    }
    
    //MARK: - Setup input button
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemTeal
        button.onTouchUpInside { [weak self] _ in
//            self?.presentInputActionSheet()
            
//            self?.addSecondChild()
            
            //FIXME: - uncomment this if things go wrong
//            self?.presentModal()
            
            self?.presentInputActionSheet()
            
            
            
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    

    
    func testPhoto() {
        
//        self.messages.append(Message(sender: self.selfSender, messageId: "1", sentDate: Date(), kind: .photo(Media(placeholderImage: UIImage(named: "a2")!, size: CGSize(width: 200, height: 200)))))
        
        if let safeURL = URL(string: "https://image.tmdb.org/t/p/w500/vDGr1YdrlfbU9wxTOdpf3zChmv9.jpg") {
           
            self.messages.append(Message(sender: selfSender, messageId: "3", sentDate: Date(), kind: .photo(Media(url:safeURL, placeholderImage: UIImage(named: "a1")!, size: CGSize(width: 200, height: 300)))))
            
            print("test photo 1")
        }
        print("test photo 2")
        
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadDataAndKeepOffset()
            print("test photo 3")
        }
       
       
    }
    
    //MARK: - Present Photo input
    private func presentPhotoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Attach Photo",
                                            message: "Where would you like to attach a photo from",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in

            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)

        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in

            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
    //MARK: - Firebase messages fetch
    func fireTest() {
        
        guard let toId = conversationId else {return}
    
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        
        messageListener?.remove()
        
        
        chatMessages.removeAll()
        
        
        messages.removeAll()
        
        
        
        //let docsRef =
        let docsRef = fireDB.collection("messages").document(fromId).collection(toId).order(by: "timeStamp")
       
      
      messageListener = docsRef.addSnapshotListener { snapshotssa, err in
            
            
            
            guard let data = snapshotssa, err == nil else {return}
            
            data.documentChanges.forEach { docChange in
                
                
                let datas = docChange.document.data()
                if docChange.type == .added {
                    let changeData = docChange.document.data()
                    print("Change data = \(changeData)")
                    
                    self.chatMessages.append(.init(documentId: docChange.document.documentID, data: changeData))
                    
                    
                    print("snapy data is \(data)")
                   
                }
                print("Inside docs are here \(datas)")
                
                print("chat messages \(self.chatMessages)")
     
                
            }
            
            
        
            
            
            print("data is here yo \(data)")
            
          guard let myUID = FirebaseManager.shared.auth.currentUser?.uid else {return}
            for eachChatMessage in self.chatMessages {
                //this is the main UID check logic
                if eachChatMessage.fromId == myUID {
                    //this is the poster check logic
                    if eachChatMessage.posterURL == "" {
                        let newMes = Message(sender: self.selfSender, messageId: eachChatMessage.documentId, sentDate: eachChatMessage.timestamps, kind: .text(eachChatMessage.text))
                        
                       
                        
                        let servdate = eachChatMessage.timestamps
                        
                       print("serv date is \(servdate)")
                        let dateFormatter = DateFormatter()
                         
                        dateFormatter.dateFormat = "HH:mm:ss"
                         
                        let result = dateFormatter.string(from: servdate)
                        
                        print("Date time is \(result)")
                       
                 
                         if self.messages.contains(where: { $0.messageId == eachChatMessage.documentId }) {
                            
                         } else {
                             self.messages.append(newMes)
                         }
                    } else {
                        guard let safeURL = URL(string: eachChatMessage.posterURL) else {return}
                        let newMes = Message(sender: self.selfSender, messageId: eachChatMessage.documentId, sentDate: eachChatMessage.timestamps, kind: .photo(Media(url:safeURL, placeholderImage: UIImage(named: "a1")!, size: CGSize(width: 200, height: 300))), showID: eachChatMessage.showId, showType: eachChatMessage.showType)
                        
                     
                        
                     
                        
                       
                         if self.messages.contains(where: { $0.messageId == eachChatMessage.documentId }) {
                            
                         } else {
                             self.messages.append(newMes)
                         }
                    }
                  
                
                  
                    
                    
//                    print("New message is \(newMes)")
                    //uid logic ends here
//                        self.messagesCollectionView.reloadData()
                } else {
                    
                    if eachChatMessage.posterURL == "" {
                        
                        let otherMes = Message(sender: self.otherUser, messageId: eachChatMessage.documentId, sentDate: Date(), kind: .text(eachChatMessage.text))
                        
                        if self.messages.contains(where: { $0.messageId == eachChatMessage.documentId }) {
                           
                        } else {
                            self.messages.append(otherMes)
                        }
                        
                    } else {
                        
                        guard let safeURL = URL(string: eachChatMessage.posterURL) else {return}
                        
                        let otherMes = Message(sender: self.otherUser, messageId: eachChatMessage.documentId, sentDate: Date(), kind: .photo(Media(url:safeURL, placeholderImage: UIImage(named: "a1")!, size: CGSize(width: 200, height: 300), showID: eachChatMessage.showId, showType: eachChatMessage.showType)))
                        
                        if self.messages.contains(where: { $0.messageId == eachChatMessage.documentId }) {
                           
                        } else {
                            self.messages.append(otherMes)
                        }
                        
                    }
                    
                 
                   
//                    print("New message is \(otherMes)")
                    
                }
               
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem()
                }
            }
            
        }
        
        
        
    }
    
    //MARK: - Fetch messages
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        
        guard let toId = UserDefaults.standard.string(forKey: "testId") else {return}
        //other user
        
        
        firestoreListener?.remove()
        chatMessages.removeAll()
        //remove the listener
        
        firestoreListener = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timeStamp")
            .addSnapshotListener { querySnapshot, err in
            if let error = err {
//                self.errorMessage = "Failed to listen for messages"
                print("Snapshot Error is here : \(error)")
                
                
                return
            }
            //message is recieved here
                
             
            
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    
                    
                    print("snapy data is \(data)")
                   
                }
                
            })
               
            
                DispatchQueue.main.async {
//                    if let safeChat = ChatDataObject.chatMessagesAreHere {
//                        self.chatMessages = safeChat
//
//                        print(" swift ui safe chat \(safeChat)")
//                    }
//                    self.count += 1
                }
               

        }
    }
    
    
    

    
    

    //MARK: - Setup view did load stuff
    func setupUIStuff() {
        
        print("current user \(currentUser)")
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
                maintainPositionOnKeyboardFrameChanged = true // default false
                showMessageTimestampOnSwipeLeft = true // default false
        messagesCollectionView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 70, right: 0)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.showsVerticalScrollIndicator = false
       
        // Do any additional setup after loading the view.
       configureMessageInputBar()
    }
    
    
    
    //MARK: - Current user (Left or Right message bubble)
    
    func currentSender() -> SenderType {
//        if let sender = selfSender {
//            return sender
//        }
        
        
        return selfSender
        fatalError("Self Sender is nil, email should be cached")
//        return Sender(photoURL: "", senderId: "123", displayName: "")
    }
    
    
    //schema
    
    
   
    //MARK: - All the messages
        
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if  isFromCurrentSender(message: message){
            
            let servdate = chatMessages[indexPath.item].timestamps
            
           print("serv date is \(servdate)")
            let dateFormatter = DateFormatter()
             
            dateFormatter.dateFormat = "HH:mm:ss"
             
            let result = dateFormatter.string(from: servdate)
            
//            let message = chatMessages[indexPath.item].
            return NSAttributedString(string: result, attributes: [.font: UIFont.boldSystemFont(ofSize: 10), .foregroundColor: UIColor.darkGray])
        }
       return nil
    }
    
    
//
//    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//
//        if  isFromCurrentSender(message: message) {
//
//            let message = mkMessages[indexPath.section]
//            let status = indexPath.section == mkMessages.count - 1 ? message.status + " " +
//            message.readDate.time() : ""
//
//            return NSAttributedString(string: status, attributes: [.font : UIFont.boldSystemFont(ofSize: 10), .foregroundColor : UIColor.darkGray] )
//        }
//
//        return nil
//    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return isFromCurrentSender(message: message) ? 17 : 0
    }
    
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return indexPath.section != messages.count - 1 ? 10 : 0
    }
    
    
    //MARK: - Chat Bubble Color
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? self.bubbleColor : UIColor.darkGray
        }

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.black : UIColor.white
    }
}


extension ChatViewController: InputBarAccessoryViewDelegate {
    
    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        
        print("chat user \(chatUser?.email)")
       
        if let safeName = defaults.string(forKey: "userName")?.components(separatedBy: "@").first {
            sender.sendPushNotification(to: self.fcmTokenofUser, title: "\(safeName) 💬" , body: text)
        }
      
        
        self.handleSend(sendThisText: text)
       
//        guard let safeUserName = vm.chatUser?.email.components(separatedBy: "@").first else {return}
       
        print("user token is \(fcmTokenofUser)")
        
        
        inputBar.inputTextView.text = ""
        
        
        //        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
        //                let selfSender = self.selfSender,
        //                let messageID = createMessageID()
        //                else {
        //                        return
        //                     }
        //
        ////        guard let selfSender = self.selfSender else {
        ////            return
        ////        }
        //
        //        let message = Message(sender: selfSender,
        //                              messageId: messageID,
        //                              sentDate: Date(),
        //                              kind: .text(text))
        //
        //        //send message
        //
        //        if isNewConversation {
        //            //create convo in db
        //
        //
        //
        //            RealTimeDatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "user", firstMessage: message) { success in
        //                if success {
        //                    print("message sent")
        //                } else {
        //                    print("message failed to send")
        //                }
        //            }
        //
        //        } else {
        //            guard let conversationId = conversationId, let name = self.title else {
        //                return
        //            }
        //
        //            // append to existing conversation data
        ////            RealTimeDatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: message, completion: { [weak self] success in
        ////                if success {
        ////                    self?.messageInputBar.inputTextView.text = nil
        ////                    print("message sent appended")
        ////                }
        ////                else {
        ////                    print("failed to send")
        ////                }
        ////            })
        //        }
        //
        //
        //                print("Sending this: \(text)")
    }
    
    
    
    //MARK: - Send Button
    func handleSend(sendThisText: String) {
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = conversationId else {return}
        
        let document = FirebaseManager.shared.firestore.collection("messages").document(fromId).collection(toId).document()
        
        let messageData = [
            FirebaseConstants.fromId: fromId, FirebaseConstants.toId: toId, FirebaseConstants.text: sendThisText, "posterURL":"",
            "timeStamp": Timestamp()] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                print("Failed to save message into Firestore : \(error)")
                return
            }
            print("Sucess saved current user sending message")
            
            if self.thisMessage != nil {
                
                self.persistRecentMessage(persistThis: sendThisText)
            } else if self.newChatThisMessage != nil {
                self.persistRecentNewChatMessage(persistThis: sendThisText)
            }

        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages").document(toId).collection(fromId).document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print("Failed to save message into Firestore : \(error)")
                return
            }
            
            print("Sucess saved recipient user receiving message")
            
            
        }
    }
    
    
    
    //MARK: - Persist Recent Messages
    private func persistRecentMessage(persistThis: String) {
        
        guard let chatUser = thisMessage else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser.id else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: persistThis,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]
        
        // you'll need to save another very similar dictionary for the recipient of this message...how?
        
        document.setData(data) { error in
            if let error = error {
                //               print("Failed to save recent message: \(error)")
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: persistThis,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
            FirebaseConstants.email: currentUser.email
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(toId)
            .collection(FirebaseConstants.messages)
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    
    
    
    //MARK: - Persist Recent Messages
    private func persistRecentNewChatMessage(persistThis: String) {
        
        guard let chatUser = newChatThisMessage else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser.id else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: persistThis,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]
        
        // you'll need to save another very similar dictionary for the recipient of this message...how?
        
        document.setData(data) { error in
            if let error = error {
                //               print("Failed to save recent message: \(error)")
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: persistThis,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
            FirebaseConstants.email: currentUser.email
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(toId)
            .collection(FirebaseConstants.messages)
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    
    
    
    
    //MARK: - Message id is created here
    
    //    private func createMessageID() -> String? {
    //        //date, otheruseremail, senderemail, randomint
    //
    //        guard let currentUserEmail = defaults.string(forKey: "email") else {return nil}
    //
    //        let safeCurrentEmail = RealTimeDatabaseManager.safeEmail(emailAddress: currentUserEmail)
    //
    //        let dateString = Self.dateFormatter.string(from: Date())
    //        //FIXME: - Check current user email - has to be safe email
    //        ///fixed :)
    //
    //        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
    //
    //        print("Created message id \(newIdentifier)")
    //        return newIdentifier
    //    }
    
    
    
    
    
    //MARK: - configure input bar
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.backgroundView.backgroundColor = UIColor(named: "Neutral_800")?.withAlphaComponent(0)
        messageInputBar.inputTextView.tintColor = .systemTeal
        messageInputBar.backgroundView.alpha = 0.1
        messageInputBar.sendButton.setTitleColor(.systemTeal, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.systemTeal.withAlphaComponent(0.3),
            for: .highlighted
        )
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Type something"
                //                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem()
               
            }
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
      let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .pointedEdge)
    }
  
    
    func didSelectMessage(in cell: MessageCollectionViewCell) {
       let indexPath = messagesCollectionView.indexPath(for: cell)
      let messageData = String(describing: messages[(indexPath?.section)!].showID)
    print("message tap \(messageData)")
    }
    
   
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            print("dismiss here")
            return
        }
        print("dismiss not here")
        let message = messages[indexPath.section]
        print(messages[indexPath.section].sender.displayName)
        print("Show id \(messages[indexPath.section].showID)")

        if message.sender.senderId == "1" {
            
            switch message.kind {
            case .photo(let media):
                
                print("this comes \(media.showID)")
                print("this also comes \(media.showType)")
                guard let imageUrl = media.url else {
                    print("dismiss in here")
                    return
                }
                print("dismiss over here - sender 1 loop")
                
                //FIXME: - Uncomment this once done
    //            let vc = MovieDetailViewController()
                
                //TODO: - Pass the show ID BELOW!!!
              
                    guard let safeIndexID = messages[indexPath.section].showID else {return}
                print("showtype is \(messages[indexPath.section].showType)")
                guard let showType = messages[indexPath.section].showType else {return}
                
                if showType == "movie" {
                    
                    print("THis is taped \(safeIndexID) and show type \(showType)")
                    let detailViewController = MoPopUpViewController()
                    detailViewController.showType = showType
                    
                    detailViewController.movieId = safeIndexID
                  detailViewController.fetchMovieDetails(movieID: safeIndexID)
  //                vc.movieId = movieIDS

              print("safe in")
            //        detailViewController.movieDelegate = self
                    let nav = UINavigationController(rootViewController: detailViewController)
                    // 1
                    nav.modalPresentationStyle = .pageSheet

                    
                    // 2
                    if let sheet = nav.sheetPresentationController {

                        // 3
                        sheet.detents = [.medium()]

                    }
                    // 4
                    present(nav, animated: true, completion: nil)
                    
                } else {
                    
                    
                    let detailViewController = MoPopUpViewController()
                    detailViewController.movieId = safeIndexID
                    detailViewController.showType = showType
                  detailViewController.fetchTVDetails(movieID: safeIndexID)
                    
                  
  //                vc.movieId = movieIDS

              print("safe in")
            //        detailViewController.movieDelegate = self
                    let nav = UINavigationController(rootViewController: detailViewController)
                    // 1
                    nav.modalPresentationStyle = .pageSheet

                    
                    // 2
                    if let sheet = nav.sheetPresentationController {

                        // 3
                        sheet.detents = [.medium()]

                    }
                    // 4
                    present(nav, animated: true, completion: nil)
                  
                    
                }
                     
    ////                vc.fetchMovieDetailswithTMDBid(tmdbID: movieIDS)
                
                
                
              
                
               
              
                
                
              
            default:
                break
            }
            
        } else {
            
            
            switch message.kind {
            case .photo(let media):
                
                print("Other user tapped \(message.showID)")
                print("this comes \(media.showID)")
                print("This comes is other user \(media.showType)")
                guard let imageUrl = media.url else {
                    print("dismiss in here")
                    return
                }
                print("other user tapped again \(messages[indexPath.section].showID)")
                
                //FIXME: - Uncomment this once done
    //            let vc = MovieDetailViewController()
                
                guard let safeMediaShowID = media.showID else {return}
                //TODO: - Pass the show ID BELOW!!!
               
                guard let safeShowType = media.showType else {return}
              
                print("Safe media show id \(safeMediaShowID)")
//                    guard let safeIndexID = messages[indexPath.section].showID else {return}
                
                if media.showType == "movie" {
                    
                    let detailViewController = MoPopUpViewController()
                    detailViewController.movieId = safeMediaShowID
                    detailViewController.showType = media.showType
                  detailViewController.fetchMovieDetails(movieID: safeMediaShowID)
  //                vc.movieId = movieIDS

            //        detailViewController.movieDelegate = self
                    let nav = UINavigationController(rootViewController: detailViewController)
                    // 1
                    nav.modalPresentationStyle = .pageSheet

                    
                    // 2
                    if let sheet = nav.sheetPresentationController {

                        // 3
                        sheet.detents = [.medium()]

                    }
                    // 4
                    present(nav, animated: true, completion: nil)
                    
                    
                    
                } else {
                    
                    //tv stuff
                    let detailViewController = MoPopUpViewController()
//                    detailViewController.showType = media.showType
                    detailViewController.movieId = safeMediaShowID
                    detailViewController.showType = media.showType
                  detailViewController.fetchTVDetails(movieID: safeMediaShowID)
  //                vc.movieId = movieIDS

            //        detailViewController.movieDelegate = self
                    let nav = UINavigationController(rootViewController: detailViewController)
                    // 1
                    nav.modalPresentationStyle = .pageSheet

                    
                    // 2
                    if let sheet = nav.sheetPresentationController {

                        // 3
                        sheet.detents = [.medium()]

                    }
                    // 4
                    present(nav, animated: true, completion: nil)
                    
                }
                 
                    
    ////                vc.fetchMovieDetailswithTMDBid(tmdbID: movieIDS)
                
                
                
              
                
               
              
                
                
              
            default:
                break
            }
            
        }
    
    }
    
    


//MARK: - Present mopop
    private func presentMoPop() {
        let detailViewController = MoPopUpViewController()
//        detailViewController.movieDelegate = self
        let nav = UINavigationController(rootViewController: detailViewController)
        // 1
        nav.modalPresentationStyle = .pageSheet

        
        // 2
        if let sheet = nav.sheetPresentationController {

            // 3
            sheet.detents = [.medium()]

        }
        // 4
        present(nav, animated: true, completion: nil)

    }
    
    
    
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        
        let sender = message.sender
        if sender.senderId == "1" {
        
           
            
            if let photoUrl =  UserDefaults.standard.string(forKey: "photu") {
               let safeURL = URL(string: photoUrl)
                avatarView.sd_setImage(with: safeURL)
            }
            
        } else {
            
            if let photoUrl =  thisMessage?.profileImageUrl {
               let safeURL = URL(string: photoUrl)
                avatarView.sd_setImage(with: safeURL)
            }
            
            
        }
        
       
        
        
    }
    
}

struct Sender: SenderType{
   public var photoURL: String
   public var senderId: String
    var displayName: String
    
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    var showID: String?
    var showType: String?
}


private var conversations = [Conversation]()


struct Message: MessageType {
   public var sender: SenderType
   public var messageId: String
   public var sentDate: Date
   public var kind: MessageKind
    public var showID: String?
    public var showType: String?
}


extension MessageKind {
    
    var messageKindString: String {
        switch self {
            
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributedText"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "linkPreview"
        case .custom(_):
            return "custom"
        }
    }
    
}


extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        
        print("Did finish picking")
    }
    
}


extension ChatViewController: PassMovieDelegate {
  
    
    
   
    
    
  
    func cellTapped(posterString: String, showID: String, showType: String) {
        
//                self.messages.append(Message(sender: self.selfSender, messageId: "1", sentDate: Date(), kind: .photo(Media(placeholderImage: UIImage(named: "a2")!, size: CGSize(width: 200, height: 200)))))
////
        ///
                if let safeURL = URL(string: posterString) {

//                    self.messages.append(Message(sender: selfSender, messageId: "3", sentDate: Date(), kind: .photo(Media(url:safeURL, placeholderImage: UIImage(named: "a1")!, size: CGSize(width: 200, height: 300)))))

                    print("test photo 1")
                }
                print("test photo 2")
                
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    print("test photo 3")
                }
        
        handlePhotoSend(posterURL: posterString, showID: showID, showType: showType)
        
        //need a function to save this
    }
    
    func handlePhotoSend(posterURL: String, showID: String, showType: String) {
        
        
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = conversationId else {return}
//        guard let showID = defaults.string(forKey: "watchME") else { return}
        
        let document = FirebaseManager.shared.firestore.collection("messages").document(fromId).collection(toId).document()
        
        let messageData = [
            FirebaseConstants.fromId: fromId, FirebaseConstants.toId: toId, FirebaseConstants.text: "Check this out", "posterURL":posterURL,
            "timeStamp": Timestamp(), "showID": showID, "showType": showType] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                print("Failed to save message into Firestore : \(error)")
                return
            }
            print("Sucess saved current user sending message")
            
            self.persistRecentMessage(persistThis: "Poster 📷")

        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages").document(toId).collection(fromId).document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print("Failed to save message into Firestore : \(error)")
                return
            }
            
            print("Sucess saved recipient user receiving message")
            
            
        }
        
    }
    
    
    
}


extension ChatViewController: MessageCellDelegate {
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            print("no path detect")
            return
        }
        print("test tap mess \(messages[indexPath.section].showID)")
        
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }

        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                
                return
            }
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
    }
    
    
}


extension MediaItem {
    public var classTag: String {
        return String(describing: type(of: self))
    }
}
