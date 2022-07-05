////
////  DatabaseManager.swift
////  FleekSpaces
////
////  Created by Mayur P on 29/06/22.
////
//
//import Foundation
//import FirebaseDatabase
//import AVFoundation
//
//
////MARK: - Database manager
//
//final class DatabaseManager {
//
//
//    static let shared = DatabaseManager()
//
//    private let database = Database.database().reference()
//
//
//    static func safeEmail(emailAddress: String) -> String {
//
//        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//        return safeEmail
//    }
//
//
//
//}
//
////MARK: - Account management
//
//
//extension DatabaseManager {
//
//
//    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
//
//        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
//
//            guard let value = snapshot.value as? [[String: String]] else {
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//
//            completion(.success(value))
//
//        })
//    }
//
//    public enum DatabaseError: Error {
//        case failedToFetch
//    }
//
//    //MARK: - check if user exists
//
//    ///check if email id exists
//    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
//
//
//        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
//            guard snapshot.value as? String != nil else {
//                completion(false)
//                return
//            }
//
//            completion(true)
//        }
//
//
//    }
//
//    ///Insert a user to database
//    //MARK: - insert user
//    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
//
//        database.child(user.safeEmail).setValue([
//
//            "first_name": user.firstname,
//            "last_name": user.lastName
//
//
//        ], withCompletionBlock: { error, _ in
//            guard error == nil else {
//
//                print("failed to write to databse")
//                completion(false)
//                return
//            }
//
//
//            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
//
//                if var userCollection = snapshot.value as? [[String: String]] {
//
//                    //apend to dictionary
//                    let newElement = [
//
//
//                            "name": user.firstname + "" + user.lastName,
//                            "email": user.safeEmail
//
//                    ]
//                    userCollection.append(newElement)
//
//                    self.database.child("users").setValue(userCollection, withCompletionBlock: {error, _ in
//                        guard error == nil else {
//                            completion(false)
//                            return
//                        }
//
//                        completion(true)
//
//                    })
//
//                } else {
//
//                    //create an array
//                    let newCollection: [[String: String]] = [
//
//                        [
//                            "name": user.firstname + "" + user.lastName,
//                            "email": user.safeEmail
//                        ]
//                    ]
//
//                    self.database.child("users").setValue(newCollection, withCompletionBlock: {error, _ in
//                        guard error == nil else {
//                            return
//                        }
//
//                        completion(true)
//
//                    })
//                }
//
//            })
//
//        })
//
//    }
//
//}
//
////MARK: - Sending messages / conversation
//
//
//extension DatabaseManager {
//
//    ///Creates a new conversation with target user  email and first message sent
//    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
//
//        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
//        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
//
//        let ref = database.child("\(safeEmail)")
//        ref.observeSingleEvent(of: .value) { snapshot in
//            guard var userNode = snapshot.value as? [String: Any] else {
//                completion(false)
//                print("user not found")
//                return
//            }
//
//            let messageDate = firstMessage.sentDate
//            let dateString = ChatLayoutViewController.dateFormatter.string(from: messageDate)
//            var message = ""
//            switch firstMessage.kind {
//
//            case .text(let messageText):
//                message = messageText
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
//            let conversationID = "conversation_\(firstMessage.messageId)"
//            let newConversationdata: [String: Any] = [
//
//                "id": conversationID,
//                "other_user_email": otherUserEmail,
//                "name": name,
//                "latest_message": [
//                    "date": dateString,
//                    "message": message,
//                    "is_read": false
//                ]
//
//            ]
//
//            if var conversations = userNode["conversations"] as? [[String: Any]] {
//                //conversation array exists for current user
//                //you should append
//
//                conversations.append(newConversationdata)
//                userNode["conversations"] = conversations
//                ref.setValue(userNode) { [weak self] error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//                    self?.finsihCreatingConversation(name: name, conversationID: conversationID, firstMessage: firstMessage, completion: completion)
//
//                }
//
//            } else {
//              //conversation array doesn not exist
//                //create it
//                userNode["conversations"] = [
//                newConversationdata
//
//                ]
//
//                ref.setValue(userNode) { [weak self] error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//
//                    self?.finsihCreatingConversation(name: name, conversationID: conversationID, firstMessage: firstMessage, completion: completion)
//
//
//                }
//
//            }
//        }
//    }
//
//
//    private func finsihCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
//
//        let messageDate = firstMessage.sentDate
//        let dateString = ChatLayoutViewController.dateFormatter.string(from: messageDate)
//        var message = ""
//        switch firstMessage.kind {
//
//        case .text(let messageText):
//            message = messageText
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
//
//        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//            completion(false)
//            return
//        }
//
//        let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
//
//        let collectionMessage: [String: Any] = [
//
//            "id": firstMessage.messageId,
//            "type": firstMessage.kind.messageKindString,
//            "content": message,
//            "date": dateString,
//            "sender_email": currentUserEmail,
//            "is_read": false,
//            "name": name
//        ]
//        let value : [String: Any] = [
//
//            "messages": [
//            message
//            ]
//
//        ]
//
//        print("adding convo: \(conversationID)")
//
//
//        database.child("\(conversationID)").setValue(value) { error, _ in
//
//            guard error == nil else {
//                completion(false)
//                return
//            }
//
//            completion(true)
//        }
//
//    }
//    //fetches and returns all conversations for the user with passed in email
//    public func getAllConversations (for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
//
//
//        database.child("\(email)/conversations").observe(.value) { snapshot in
//
//            guard let value = snapshot.value as? [[String: Any]] else {
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//
//            let conversations: [Conversation] = value.compactMap { dictionary in
//                guard let conversationID = dictionary["id"] as? String,
//                      let name = dictionary["name"] as? String,
//                      let otherUserEmail = dictionary["other_user_email"] as? String,
//                      let latestMessage = dictionary["latest_message"] as? [String: Any],
//                      let date = latestMessage["date"] as? String,
//                      let message = latestMessage["message"] as? String,
//                      let isRead = latestMessage["is_read"] as? Bool else {
//                    return nil
//                }
//
//
//                let latestMessageObject = LatestMessage(date: date, text: message, isRead: isRead)
//
//                return Conversation(id: conversationID, name: name, otherUserEmail: otherUserEmail, latestMessage: latestMessageObject)
//            }
//            completion(.success(conversations))
//        }
//
//    }
//
//    //get all message for a given conversation
//    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
//
//
//
//        database.child("\(id)/messages").observe(.value, with: { snapshot in
//
//            print("This is snapshot value")
//            print(snapshot.value)
//            guard let value = snapshot.value as? [[String: Any]] else {
//                print("Returning value nil")
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//
//            let messages: [Message] = value.compactMap ({ dictionary in
//
//                guard let name = dictionary["name"] as? String else {return nil}
//                guard let isRead = dictionary["is_read"] as? Bool else {
//                    print("This is returning form is_read")
//                    return nil}
//                guard let messageID = dictionary["id"] as? String else {
//                    print("This is returning form id")
//                    return nil}
//                guard let content = dictionary["content"] as? String else {
//                    print("This is returning form content")
//                    return nil}
//                guard let senderEmail = dictionary["sender_email"] as? String else {
//                    print("This is returning form sender_email")
//                    return nil}
//                guard let type = dictionary["type"] as? String else {
//                    print("This is returning form type")
//                    return nil}
//                guard let dateString = dictionary["date"] as? String else {
//                    print("This is returning form date")
//                    return nil}
//                  guard let date = ChatLayoutViewController.dateFormatter.date(from: dateString) else {
//                    print("This is returning form here")
//                    return nil
//                }
//
//
//                let sender = Sender(photoURL: "", senderId: senderEmail, displayName: name)
//
//                return Message(sender: sender, messageId: messageID, sentDate: date, kind: .text(content))
//
//
//            })
//            print("message is here \(messages)")
//            completion(.success(messages))
//
//        })
//
//    }
//
//    ///send a message with target conversation and message
//    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
//
//    }
//}
//
////MARK: - chat app user struct
//
//struct ChatAppUser {
//
//    let firstname: String
//    let lastName: String
//    let emailAddress: String
//
//    var safeEmail: String {
//
//        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//        return safeEmail
//
//
//    }
//
//    var profilePictureFileName: String {
//        return "\(safeEmail)_profile_picture.png"
//    }
//}
