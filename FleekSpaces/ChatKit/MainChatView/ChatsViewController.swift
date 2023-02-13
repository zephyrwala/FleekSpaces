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




class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate  {
   
    
    // date formatter returns date string
    public static let dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
        
    }()
    //this is main message
    private var messages = [Message]()
    public let otherUserEmail: String
    private let conversationId: String?
    public var isNewConversation = false
    var defaults = UserDefaults.standard
    let fireDB = Firestore.firestore()
    var thisMessage: RecentMessage?
    
//    var fetchedMe
    
    var swiftChat = ChatDataObject.chatMessagesAreHere
  
    
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Mohan")
    private let otherUser = Sender(photoURL: "", senderId: "2", displayName: "Baba Blackshee")
   
    var myMessages = [MessageType]()
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
        
        
        setupUIStuff()
      
      
        messageInputBar.inputTextView.becomeFirstResponder()
//        if let conversationId = conversationId {
//            listenForMessages(id: conversationId, shouldScrollToBottom: true)
//        }
     
//        print("The transfered IDs are \()")
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupInputButton()
        print("passed message \(thisMessage) and message id \(thisMessage?.id) ")
      setupUIStuff()
//      fetchMessages()
        print("Chat object \(ChatDataObject.chatMessagesAreHere)")
        fireTest()

        
        
//        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("hellow world")))
//
//        messages.append(Message(sender: selfSender, messageId: "2", sentDate: Date(), kind: .text("This is going to be awesome and everyone loves the chat")))
//
//        messages.append(Message(sender: otherUser, messageId: "3", sentDate: Date(), kind: .text("This is cool guys, lets rock")))
     
        
     
       
    }
    
    
    //MARK: - Setup input button
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.tintColor = .darkGray
        button.onTouchUpInside { [weak self] _ in
            self?.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    //MARK: - Present input Action sheet
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Media",
                                            message: "What would you like to attach?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self]  _ in
//            self?.presentVideoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: {  _ in

        }))
        actionSheet.addAction(UIAlertAction(title: "Location", style: .default, handler: { [weak self]  _ in
//            self?.presentLocationPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
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
        
        
        
        
        firestoreListener?.remove()
        chatMessages.removeAll()
        messages.removeAll()
        let docsRef = fireDB.collection("messages").document(fromId).collection(toId).order(by: "timeStamp")
      
        docsRef.addSnapshotListener { snapshotssa, err in
            
            
            
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
            
            
            for eachChatMessage in self.chatMessages {
                if eachChatMessage.fromId == "aw8kTTGiE4gcJMrQXB3sDDMZnn92" {
                    
                    let newMes = Message(sender: self.selfSender, messageId: eachChatMessage.documentId, sentDate: Date(), kind: .text(eachChatMessage.text))
                    
                    self.messages.append(newMes)
                    
                    print("New message is \(newMes)")
                    
//                        self.messagesCollectionView.reloadData()
                } else {
                    
                    let otherMes = Message(sender: self.otherUser, messageId: eachChatMessage.documentId, sentDate: Date(), kind: .text(eachChatMessage.text))
                    
                    self.messages.append(otherMes)
                    
                    print("New message is \(otherMes)")
                    
                  
                }
               
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
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
        
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
                maintainPositionOnKeyboardFrameChanged = true // default false
                showMessageTimestampOnSwipeLeft = true // default false
        messagesCollectionView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 70, right: 0)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
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
    
    
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.systemCyan : UIColor.darkGray
        }

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.black : UIColor.white
    }
}


extension ChatViewController: InputBarAccessoryViewDelegate {
    
    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        
        
        
        
        
        
        self.handleSend(sendThisText: text)
        
        
        
        
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
        
        //        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = conversationId else {return}
        
        let document = FirebaseManager.shared.firestore.collection("messages").document(fromId).collection(toId).document()
        
        let messageData = [
            FirebaseConstants.fromId: fromId, FirebaseConstants.toId: toId, FirebaseConstants.text: sendThisText,
            "timeStamp": Timestamp()] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                print("Failed to save message into Firestore : \(error)")
                return
            }
            
            print("Sucess saved current user sending message")
            
            self.persistRecentMessage(persistThis: sendThisText)
            //clear chat text
            //                text = ""
            //message auto scroll
            //                self.count += 1
            
            DispatchQueue.main.async {
//                self.messagesCollectionView.reloadDataAndKeepOffset()

                self.messagesCollectionView.reloadDataAndKeepOffset()
                self.messagesCollectionView.scrollToBottom()
                
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
        messageInputBar.inputTextView.tintColor = .systemTeal
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
                inputBar.inputTextView.placeholder = "Aa"
                //                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
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

private var conversations = [Conversation]()


struct Message: MessageType {
   public var sender: SenderType
   public var messageId: String
   public var sentDate: Date
   public var kind: MessageKind
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
