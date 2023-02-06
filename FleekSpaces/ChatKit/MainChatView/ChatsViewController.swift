//
//  ChatsViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 19/07/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView


class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate  {
   
    
    // date formatter returns date string
    public static let dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
        
    }()
    
    public let otherUserEmail: String
    public var isNewConversation = false
    var defaults = UserDefaults.standard
  
    
   
    var myMessages = [MessageType]()
    
    //creating + computing the sender and returning the computed sender
    private var selfSender: Sender? {
        
        guard let email = defaults.string(forKey: "email") else {return nil}
        
       return Sender(photoURL: "",
                     senderId: email,
                     displayName: "")
        
    }
   
    
     init(with email: String) {
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // view did appear for first responder keyboard
    override func viewDidAppear(_ animated: Bool) {
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
      setupUIStuff()
       
    }
    

    //MARK: - Setup view did load stuff
    func setupUIStuff() {
        
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
                maintainPositionOnKeyboardFrameChanged = true // default false
                showMessageTimestampOnSwipeLeft = true // default false
        messagesCollectionView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 70, right: 0)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        // Do any additional setup after loading the view.
       configureMessageInputBar()
    }
    
    
    
    //MARK: - Current user (Left or Right message bubble)
    
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self Sender is nil, email should be cached")
        return Sender(photoURL: "", senderId: "123", displayName: "")
    }
    
    
    //schema
   
    //MARK: - All the messages
        
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return myMessages[indexPath.section]
    }
    
    
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return myMessages.count
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.systemIndigo : UIColor.darkGray
        }

}


extension ChatViewController: InputBarAccessoryViewDelegate {

    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
                let selfSender = self.selfSender,
                let messageID = createMessageID()
                else {
                        return
                     }
        
//        guard let selfSender = self.selfSender else {
//            return
//        }
        
       
        //send message
        
        if isNewConversation {
            //create convo in db
            let message = Message(sender: selfSender,
                                  messageId: messageID,
                                  sentDate: Date(),
                                  kind: .text(text))
            
            
            RealTimeDatabaseManager.shared.createNewConversation(with: otherUserEmail, firstMessage: message) { success in
                if success {
                    print("message sent")
                } else {
                    print("message failed to send")
                }
            }
            
        } else {
            //append to an existing convo in db
        }
        
                
                print("Sending this: \(text)")
    }
    
    
    //MARK: - Message id is created here
    
    private func createMessageID() -> String? {
        //date, otheruseremail, senderemail, randomint
       
        guard let currentUserEmail = defaults.string(forKey: "email") else {return nil}
        
        let safeCurrentEmail = RealTimeDatabaseManager.safeEmail(emailAddress: currentUserEmail)
        
        let dateString = Self.dateFormatter.string(from: Date())
        //FIXME: - Check current user email - has to be safe email
        ///fixed :) 
        
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        
        print("Created message id \(newIdentifier)")
        return newIdentifier
    }
    
    
    
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
