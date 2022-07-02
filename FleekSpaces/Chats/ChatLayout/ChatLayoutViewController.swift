//
//  ChatLayoutViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 29/06/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatLayoutViewController: MessagesViewController {

    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    public var isNewConversation = false
    public let otherUserEmail : String
    
    private var messages = [Message]()
    private var selfSender: Sender? {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
            
        }
        
        return Sender(photoURL: "",
                      senderId: email,
                      displayName: "Pinak Das")
    }
    
    
    //custom instructor
    
    init(with email: String) {
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
//        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello guys, this is awesome")))
//
//        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("I am getting good at this")))
//
//        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("I play badminton and life is amazing.")))
//
//        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Jhalak dikhlaja - Jhalak dikhla jaa - Jhalak dikhla jaa")))
//
//        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("हर सुबह तेरी जिंदगी खुशियों से भर दे रब तेरे गम को तेरी ख़ुशी कर दे जब भी टूटने लगे तेरी साँसे खुदा तुझमे शामिल मेरी ज़िन्दगी कर दे")))
//
//        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Mornings are refreshing like friendship, it may not stay all day long, but for sure it comes forever every day. Good Morning. Good morning MY DEAR. Do U know what is MY DEAR... M-Myself Y-Yield D-Deeply & E-Emotionally to A-An R-Rare person, that is U.")))

        view.backgroundColor = .red
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
       
        messagesCollectionView.backgroundColor = UIColor(named: "BGColor")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
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

extension ChatLayoutViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty, let selfSender = self.selfSender, let messageId = createMessageID()  else {
            
            
            return
        }
        
        print("Sending \(text)")
        
        // send message
        if isNewConversation {
            let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
            // create convo in dv
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "user", firstMessage: message) { success in
                if success {
                    print("Message sent")
                } else {
                    print("failed to send")
                }
            }
        }
        else {
            // append to existing conversation data
            
        }
    
    }
    
    private func createMessageID() -> String? {
        //date, otheruseremail, senderemail, randomINt
       
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        
        return newIdentifier
        
    }
}

extension ChatLayoutViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        
        if let sender = selfSender {
            return sender
        }
        fatalError("self sender is nil, email should be cached")
        return Sender(photoURL: "", senderId: "12", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(named: "Primary_600")! : UIColor(named: "Neutral_600")!
    }
    
    
}

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
            return "attributed_text"
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
            return "links"
        case .custom(_):
            return "custom"
        }
        
    }
    
}

struct Sender: SenderType {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
        
}
