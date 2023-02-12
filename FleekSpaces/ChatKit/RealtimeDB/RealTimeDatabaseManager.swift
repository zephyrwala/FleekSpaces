////
////  RealTimeDatabaseManager.swift
////  FleekSpaces
////
////  Created by Mayur P on 22/01/23.
////
//
//import Foundation
//import FirebaseDatabase
//import MessageKit
//import CoreLocation
//
//final class RealTimeDatabaseManager {
//
//
//    static let shared = RealTimeDatabaseManager()
//
//    private let database = Database.database().reference()
//
//    static func safeEmail(emailAddress: String) -> String {
//        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//        return safeEmail
//    }
//
//
//
//}
//
////MARK: - Check user + Create user
//
//extension RealTimeDatabaseManager {
//
//
//    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
//
//
//        var safeEmails = email.replacingOccurrences(of: ".", with: "-")
//        safeEmails = safeEmails.replacingOccurrences(of: "@", with: "-")
//
//
//        database.child(safeEmails).observeSingleEvent(of: .value) { snapshot in
//
//
//
//
//            guard let foundEmail = snapshot.value as? String else {
//                completion(false)
//                return
//
//            }
//
//            completion(true)
//        }
//
//    }
//
//
//    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
//
//        database.child("users").observeSingleEvent(of: .value) { snapshot  in
//
//
//            guard let value = snapshot.value as? [[String: String]] else {
//
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//
//            completion(.success(value))
//        }
//    }
//
//
//
//    //MARK: - Fetch New DB users
//
//    public func fetchDBUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
//
//
//        self.database.child("users").observeSingleEvent(of: .value) { snapshot in
//
//            guard let value = snapshot.value as? [[String: String]] else {
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//
//            completion(.success(value))
//        }
//
//
//
//    }
//
//
//    //MARK: - Insert New User
//
//    public func insertUser(with user: ChatAppUser, completion: @escaping(Bool) -> Void) {
//
//        //FIXME: - create the child with number after this!
//
//        //FIXME: - This is making duplicate users collection
//
//        database.child(user.safeEmail).setValue([
//            "name": user.name,
//            "uid": user.uid,
//            "profileImageUrl": user.profileImageUrl
//
//        ]) { error, _ in
//
//            //check error
//            guard error == nil else {
//                print("failed to write to database")
//                completion(false)
//                return
//            }
//
//
//
//            //MARK: - This is making users > collection
//            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
//
//                if var usersCollection = snapshot.value as? [[String: String]] {
//                    let newElement =  [
//                        "name": user.name,
//                        "email": user.safeEmail,
//                        "profileImageUrl": user.profileImageUrl
//                    ]
//
//
//                    //apepnd to user dictionary
//                    usersCollection.append(newElement)
//
//                    self.database.child("users").setValue(usersCollection) { error, _ in
//
//                        guard error == nil else {
//                            completion(false)
//                            return
//                        }
//
//                        completion(true)
//                    }
//
//
//                } else {
//                    // create that array
//                    let newCollection: [[String: String]] = [
//                        [
//                            "name": user.name,
//                            "email": user.safeEmail,
//                            "profileImageUrl": user.profileImageUrl
//
//
//                        ]
//
//                    ]
//
//                    self.database.child("users").setValue(newCollection) { error, _ in
//
//                        guard error == nil else {
//                            completion(false)
//                            return
//                        }
//
//                        completion(true)
//                    }
//                }
//
//            }
//            //Pass true if no error
//            completion(true)
//
//
//        }
//
//    }
//
//}
//
////MARK: - Sending messages / conversations
//
////schema
//
///*
//
// conversation => [
//    "asdasd" {
//    "messages": [
//
//        "id": String,
//        "type": text, photo, video
//        "content": String,
//        "date": Date(),
//        "sender_email": String,
//        "isRead": true/false
//
//
// ]
//
// }
//
//
//    [
//        "conversation_id": "aksjdhkajshd"
//        "other_user_email":
//        "latest_message" => {
//
//            "date": Date()
//            "latest_message": "message"
//            "is_read": true/false
//
//            }
//    ],
// ]
//
// */
//
//extension RealTimeDatabaseManager {
//
//    /// Creates a new conversation with target user email and first message sent
//    public func createNewConversation(with otherUserEmail: String,name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
//
//
//        guard let currentEmail = UserDefaults.standard.string(forKey: "email") else {return}
//
//        //TODO: - Safe email for current email
//        //FIXME: - safe email for other user email is needed
//        let safeEmail = RealTimeDatabaseManager.safeEmail(emailAddress: currentEmail)
//
//        let ref = database.child("\(safeEmail)")
//
//        ///we go into the node of the email ID - to create conversation
//        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
//            guard var userNode = snapshot.value as? [String: Any] else {
//                completion(false)
//                print("user not found")
//                return
//            }
//
//            let messageDate = firstMessage.sentDate
//            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
//
//
//            //we get the content out of this
//            var message = ""
//            switch firstMessage.kind {
//
//            //handling text type kind over here
//            case .text(let messageText):
//                message = messageText
//                //this message is used below in the newconvo json
//            case .attributedText(_):
//                break
//            case .photo(_):
//                break
//            case .video(_):
//                break
//            case .location(_):
//                break
//            case .emoji(_):
//                break
//            case .audio(_):
//                break
//            case .contact(_):
//                break
//            case .linkPreview(_):
//                break
//            case .custom(_):
//                break
//            }
//
//            ///this is the new conversation block that we are checking if exists or else append the existing one.
//            ///
//            //MARK: - New Conversation Data is created here!
//            let conversationId = "conversation_\(firstMessage.messageId)"
//            //just making conversation id as a constant
//            let newConversationData: [String: Any] = [
//                "id": conversationId,
//                    "other_user_email": otherUserEmail,
//                                "name": name,
//                      "latest_message": [
//                                "date": dateString,
//                             "message": message,
//                             "is_read": false
//
//                    ]
//            ]
//
//
//            let recipient_newConversationData: [String: Any] = [
//                "id": conversationId,
//                    "other_user_email": safeEmail,
//                                "name": "self",
//                      "latest_message": [
//                                "date": dateString,
//                             "message": message,
//                             "is_read": false
//
//                    ]
//            ]
//
//            ///this goes in ---
//            ///
//            // Update recipient conversaiton entry
//
//            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot in
//                if var conversatoins = snapshot.value as? [[String: Any]] {
//                    // append
//                    conversatoins.append(recipient_newConversationData)
//                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversatoins)
//                }
//                else {
//                    // create if no conversation exists
//                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipient_newConversationData])
//                }
//            })
//            //update current user convo entry
//
//            if var conversations = userNode["conversations"] as? [[String: Any]] {
//                // conversation array exists for current user
//                // you should append
//
//                conversations.append(newConversationData)
//                userNode["conversations"] = conversations
//                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//                    self?.finishCreatingConversation(name: name,
//                                                     conversationID: conversationId,
//                                                     firstMessage: firstMessage,
//                                                     completion: completion)
//                })
//            }   else {
//                // conversation array does NOT exist
//                // create it
//                userNode["conversations"] = [
//                    newConversationData
//                ]
//
//                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//
//                    self?.finishCreatingConversation(name: name,
//                                                     conversationID: conversationId,
//                                                     firstMessage: firstMessage,
//                                                     completion: completion)
//                })
//            }
//
//        }
//
//    )}
//
//
//    //MARK: - Finish creating conversations
//    /// this helps in tracking real time conversations - so that we dont have to query the thread every single time.
//    private func finishCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
//
//        /*
//
//         {
//
//            "id": String,
//            "type": text, photo, video,
//            "content": String,
//            "date": Date(),
//            "sender_email": String
//
//
//         }
//
//         */
//
//        ///creating date params here
//        let messageDate = firstMessage.sentDate
//        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
//
//        //we get the content out of this
//        var message = ""
//        switch firstMessage.kind {
//
//        //handling text type kind over here
//        case .text(let messageText):
//            message = messageText
//            //this message is used below in the newconvo json
//        case .attributedText(_):
//            break
//        case .photo(_):
//            break
//        case .video(_):
//            break
//        case .location(_):
//            break
//        case .emoji(_):
//            break
//        case .audio(_):
//            break
//        case .contact(_):
//            break
//        case .linkPreview(_):
//            break
//        case .custom(_):
//            break
//        }
//
//        guard let myEmail = UserDefaults.standard.string(forKey: "email") else {
//
//            completion(false)
//            return
//        }
//
//        //safe email
//        let currentUserEmail = RealTimeDatabaseManager.safeEmail(emailAddress: myEmail)
//
//        ///new collection message
//
//        let collectionMessage: [String: Any] = [
//
//                "id": firstMessage.messageId,
//              "type": firstMessage.kind.messageKindString,
//           "content": message,
//              "date": dateString,
//      "sender_email": currentUserEmail,
//           "is_read": false,
//              "name": name
//
//        ]
//
//        ///pass this value
//        let value: [String: Any] = [
//
//            "messages": [
//
//                collectionMessage
//
//            ]
//        ]
//
//        print("adding convo: \(conversationID)")
//
//
//        ///value passed in conversations - with above value
//        database.child("\(conversationID)").setValue(value, withCompletionBlock: { error, _ in
//            guard error == nil else {
//                completion(false)
//                return
//            }
//            completion(true)
//        })
//
//    }
//
//
//    //MARK: - Get All Conversations
//
//    /// Fetches and returns all conversation for the user with passed in email
//    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
//
//        database.child("\(email)/conversations").observe(.value) { snapshot in
//
//            guard let value = snapshot.value as? [[String: Any]] else {
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//
//
//            let conversations: [Conversation] = value.compactMap { dictionary in
//
//                guard let conversationId = dictionary["id"] as? String,
//                      let name = dictionary["name"] as? String,
//                      let otherUserEmail = dictionary["other_user_email"] as? String,
//                      let latestMessage = dictionary["latest_message"] as? [String: Any],
//                      let date = latestMessage["date"] as? String,
//                      let message = latestMessage["message"] as? String,
//                      let isRead = latestMessage["is_read"] as? Bool else {
//                    return nil
//
//                }
//
//                let latestMessageObject = LatestMessage(date: date, text: message, isRead: isRead)
//
//                return Conversation(id: conversationId, name: name, otherUserEmail: otherUserEmail, latestMessage: latestMessageObject)
//            }
//
//            completion(.success(conversations))
//        }
//
//    }
//
//    /// Gets all messages for a given conversation
//    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
//        database.child("\(id)/messages").observe(.value, with: { snapshot in
//            guard let value = snapshot.value as? [[String: Any]] else{
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//
//            let messages: [Message] = value.compactMap({ dictionary in
//                guard let name = dictionary["name"] as? String,
//                    let isRead = dictionary["is_read"] as? Bool,
//                    let messageID = dictionary["id"] as? String,
//                    let content = dictionary["content"] as? String,
//                    let senderEmail = dictionary["sender_email"] as? String,
//                    let type = dictionary["type"] as? String,
//                    let dateString = dictionary["date"] as? String,
//                    let date = ChatViewController.dateFormatter.date(from: dateString)else {
//                        return nil
//                }
//
//
//
//                let sender = Sender(photoURL: "",
//                                    senderId: senderEmail,
//                                    displayName: name)
//
//                return Message(sender: sender,
//                               messageId: messageID,
//                               sentDate: date,
//                               kind: .text(content))
//            })
//
//            completion(.success(messages))
//        })
//    }
//
//    /// Sends a message with target conversation and message
//    public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
//        // add new message to messages
//        // update sender latest message
//        // update recipient latest message
//
//        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//            completion(false)
//            return
//        }
//
//        let currentEmail = RealTimeDatabaseManager.safeEmail(emailAddress: myEmail)
//
//        database.child("\(conversation)/messages").observeSingleEvent(of: .value, with: { [weak self] snapshot in
//            guard let strongSelf = self else {
//                return
//            }
//
//            guard var currentMessages = snapshot.value as? [[String: Any]] else {
//                completion(false)
//                return
//            }
//
//            let messageDate = newMessage.sentDate
//            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
//
//            var message = ""
//            switch newMessage.kind {
//            case .text(let messageText):
//                message = messageText
//            case .attributedText(_):
//                break
//            case .photo(let mediaItem):
//                if let targetUrlString = mediaItem.url?.absoluteString {
//                    message = targetUrlString
//                }
//                break
//            case .video(let mediaItem):
//                if let targetUrlString = mediaItem.url?.absoluteString {
//                    message = targetUrlString
//                }
//                break
//            case .location(let locationData):
//                let location = locationData.location
//                message = "\(location.coordinate.longitude),\(location.coordinate.latitude)"
//                break
//            case .emoji(_):
//                break
//            case .audio(_):
//                break
//            case .contact(_):
//                break
//            case .custom(_), .linkPreview(_):
//                break
//            }
//
//            guard let myEmmail = UserDefaults.standard.value(forKey: "email") as? String else {
//                completion(false)
//                return
//            }
//
//            let currentUserEmail = RealTimeDatabaseManager.safeEmail(emailAddress: myEmmail)
//
//            let newMessageEntry: [String: Any] = [
//                "id": newMessage.messageId,
//                "type": newMessage.kind.messageKindString,
//                "content": message,
//                "date": dateString,
//                "sender_email": currentUserEmail,
//                "is_read": false,
//                "name": name
//            ]
//
//            currentMessages.append(newMessageEntry)
//
//            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) { error, _ in
//                guard error == nil else {
//                    completion(false)
//                    return
//                }
//
//                strongSelf.database.child("\(currentEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
//                    var databaseEntryConversations = [[String: Any]]()
//                    let updatedValue: [String: Any] = [
//                        "date": dateString,
//                        "is_read": false,
//                        "message": message
//                    ]
//
//                    if var currentUserConversations = snapshot.value as? [[String: Any]] {
//                        var targetConversation: [String: Any]?
//                        var position = 0
//
//                        for conversationDictionary in currentUserConversations {
//                            if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
//                                targetConversation = conversationDictionary
//                                break
//                            }
//                            position += 1
//                        }
//
//                        if var targetConversation = targetConversation {
//                            targetConversation["latest_message"] = updatedValue
//                            currentUserConversations[position] = targetConversation
//                            databaseEntryConversations = currentUserConversations
//                        }
//                        else {
//                            let newConversationData: [String: Any] = [
//                                "id": conversation,
//                                "other_user_email": RealTimeDatabaseManager.safeEmail(emailAddress: otherUserEmail),
//                                "name": name,
//                                "latest_message": updatedValue
//                            ]
//                            currentUserConversations.append(newConversationData)
//                            databaseEntryConversations = currentUserConversations
//                        }
//                    }
//                    else {
//                        let newConversationData: [String: Any] = [
//                            "id": conversation,
//                            "other_user_email": RealTimeDatabaseManager.safeEmail(emailAddress: otherUserEmail),
//                            "name": name,
//                            "latest_message": updatedValue
//                        ]
//                        databaseEntryConversations = [
//                            newConversationData
//                        ]
//                    }
//
//                    strongSelf.database.child("\(currentEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
//                        guard error == nil else {
//                            completion(false)
//                            return
//                        }
//
//
//                        // Update latest message for recipient user
//
//                        strongSelf.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
//                            let updatedValue: [String: Any] = [
//                                "date": dateString,
//                                "is_read": false,
//                                "message": message
//                            ]
//                            var databaseEntryConversations = [[String: Any]]()
//
//                            guard let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
//                                return
//                            }
//
//                            if var otherUserConversations = snapshot.value as? [[String: Any]] {
//                                var targetConversation: [String: Any]?
//                                var position = 0
//
//                                for conversationDictionary in otherUserConversations {
//                                    if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
//                                        targetConversation = conversationDictionary
//                                        break
//                                    }
//                                    position += 1
//                                }
//
//                                if var targetConversation = targetConversation {
//                                    targetConversation["latest_message"] = updatedValue
//                                    otherUserConversations[position] = targetConversation
//                                    databaseEntryConversations = otherUserConversations
//                                }
//                                else {
//                                    // failed to find in current colleciton
//                                    let newConversationData: [String: Any] = [
//                                        "id": conversation,
//                                        "other_user_email": RealTimeDatabaseManager.safeEmail(emailAddress: currentEmail),
//                                        "name": currentName,
//                                        "latest_message": updatedValue
//                                    ]
//                                    otherUserConversations.append(newConversationData)
//                                    databaseEntryConversations = otherUserConversations
//                                }
//                            }
//                            else {
//                                // current collection does not exist
//                                let newConversationData: [String: Any] = [
//                                    "id": conversation,
//                                    "other_user_email": RealTimeDatabaseManager.safeEmail(emailAddress: currentEmail),
//                                    "name": currentName,
//                                    "latest_message": updatedValue
//                                ]
//                                databaseEntryConversations = [
//                                    newConversationData
//                                ]
//                            }
//
//                            strongSelf.database.child("\(otherUserEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
//                                guard error == nil else {
//                                    completion(false)
//                                    return
//                                }
//
//                                completion(true)
//                            })
//                        })
//                    })
//                })
//            }
//        })
//    }
//
//
//
//}
//
//struct ChatAppUser {
//
//    let name: String
//    let email: String
//    let uid: String
//    let profileImageUrl: String
//
//
//    //computed property to get the safe email
//
//    var safeEmail: String {
//
//
//        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//
//        return safeEmail
//
//    }
//}
//
//
//public enum DatabaseError: Error {
//    case failedToFetch
//}
//
//struct Media: MediaItem {
//    var url: URL?
//    var image: UIImage?
//    var placeholderImage: UIImage
//    var size: CGSize
//}
//
//struct Location: LocationItem {
//    var location: CLLocation
//    var size: CGSize
//}
