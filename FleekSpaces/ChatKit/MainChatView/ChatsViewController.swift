//
//  ChatsViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 19/07/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType{
    var photoURL: String
    var senderId: String
    var displayName: String
    
}

private var conversations = [Conversation]()

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
        case .custom(_):
            return "customc"
        case .linkPreview(_):
            return "link"
        }
    }
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class ChatsViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate  {
   
   
    
    
  
    
    let currentUser = Sender(photoURL: "", senderId: "self", displayName: "Chagan")

    var myMessages = [MessageType]()
    
    var otherUser = Sender(photoURL: "", senderId: "other", displayName: "Gagan")
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
                maintainPositionOnKeyboardFrameChanged = true // default false
                showMessageTimestampOnSwipeLeft = true // default false
        messagesCollectionView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 70, right: 0)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        // Do any additional setup after loading the view.
       configureMessageInputBar()
        myMessages.append(Message(sender: currentUser,
                                  messageId: "1",
                                  sentDate: Date().addingTimeInterval(-86400),
                                  kind: .text("Hello Bro")))
        
        myMessages.append(Message(sender: otherUser,
                                  messageId: "2",
                                  sentDate: Date().addingTimeInterval(-70000),
                                  kind: .text("Hello hello hello")))
        
        myMessages.append(Message(sender: currentUser,
                                  messageId: "3",
                                  sentDate: Date().addingTimeInterval(-60000),
                                  kind: .text("how are you? It has been a while since we messaged each other. Life is tough.")))
        
        myMessages.append(Message(sender: otherUser,
                                  messageId: "4",
                                  sentDate: Date().addingTimeInterval(-50000),
                                  kind: .text("I am fine. Life has been tough but we are getting through it every single day and managing")))
        
        myMessages.append(Message(sender: currentUser,
                                  messageId: "5",
                                  sentDate: Date().addingTimeInterval(-40000),
                                  kind: .text("That is awesome")))
        
        myMessages.append(Message(sender: otherUser,
                                  messageId: "6",
                                  sentDate: Date().addingTimeInterval(-30000),
                                  kind: .text("let's have wine?")))
        myMessages.append(Message(sender: currentUser,
                                  messageId: "7",
                                  sentDate: Date().addingTimeInterval(-40000),
                                  kind: .text("That is awesome. Life has been tough but we are getting through it every single day and managing")))
        
        myMessages.append(Message(sender: otherUser,
                                  messageId: "8",
                                  sentDate: Date().addingTimeInterval(-30000),
                                  kind: .text("let's have wine?. Life has been tough but we are getting through it every single day and managing. Life has been tough but we are getting through it every single day and managing. Life has been tough but we are getting through it every single day and managing")))
    }
    

    
    //MARK: - Current user (Left or Right message bubble)
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
   
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
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ChatsViewController: InputBarAccessoryViewDelegate {

    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
       
        
        
                
                print("Sending this: \(text)")
    }
    
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

//    private func insertMessages(_ data: [Any]) {
//        for component in data {
//            let user = SampleData.shared.currentSender
//            if let str = component as? String {
//                let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
//                insertMessage(message)
//            } else if let img = component as? UIImage {
//                let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
//                insertMessage(message)
//            }
//        }
//    }
}
