//
//  RealTimeDatabaseManager.swift
//  FleekSpaces
//
//  Created by Mayur P on 22/01/23.
//

import Foundation
import FirebaseDatabase

final class RealTimeDatabaseManager {
    
    
    static let shared = RealTimeDatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    
    
}

//MARK: - Check user + Create user

extension RealTimeDatabaseManager {
    
    
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        
        var safeEmails = email.replacingOccurrences(of: ".", with: "-")
        safeEmails = safeEmails.replacingOccurrences(of: "@", with: "-")
        
        
        database.child(safeEmails).observeSingleEvent(of: .value) { snapshot in
            
            
            
            
            guard let foundEmail = snapshot.value as? String else {
                completion(false)
                return
                
            }
            
            completion(true)
        }
        
    }
    
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        
        database.child("users").observeSingleEvent(of: .value) { snapshot  in
            
            
            guard let value = snapshot.value as? [[String: String]] else {
                
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            completion(.success(value))
        }
    }
    
    
    
    //MARK: - Fetch New DB users
    
    public func fetchDBUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        
        
        self.database.child("users").observeSingleEvent(of: .value) { snapshot in
            
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            completion(.success(value))
        }
       
        
        
    }
    
    
    //MARK: - Insert New User
    
    public func insertUser(with user: ChatAppUser, completion: @escaping(Bool) -> Void) {
        
        //FIXME: - create the child with number after this!
        
        //FIXME: - This is making duplicate users collection
        
        database.child(user.safeEmail).setValue([
            "name": user.name,
            "uid": user.uid,
            "profileImageUrl": user.profileImageUrl
            
        ]) { error, _ in
            
            //check error
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            
            
            
            //MARK: - This is making users > collection
            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                
                if var usersCollection = snapshot.value as? [[String: String]] {
                    let newElement =  [
                        "name": user.name,
                        "email": user.safeEmail,
                        "profileImageUrl": user.profileImageUrl
                    ]
                    
                    
                    //apepnd to user dictionary
                    usersCollection.append(newElement)
                    
                    self.database.child("users").setValue(usersCollection) { error, _ in
                        
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    }
                        
                    
                } else {
                    // create that array
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.name,
                            "email": user.safeEmail,
                            "profileImageUrl": user.profileImageUrl
                        
                        
                        ]
                        
                    ]
                    
                    self.database.child("users").setValue(newCollection) { error, _ in
                        
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    }
                }
     
            }
            //Pass true if no error
            completion(true)
            
            
        }
        
    }
    
}

//MARK: - Sending messages / conversations

//schema

/*
 
 conversation => [
    "asdasd" {
    "messages": [
 
        "id": String,
        "type": text, photo, video
        "content": String,
        "date": Date(),
        "sender_email": String,
        "isRead": true/false
 
 
 ]
 
 }
 
 
    [
        "conversation_id": "aksjdhkajshd"
        "other_user_email":
        "latest_message" => {
 
            "date": Date()
            "latest_message": "message"
            "is_read": true/false
 
            }
    ],
 ]
 
 */

extension RealTimeDatabaseManager {
    
    /// Creates a new conversation with target user email and first message sent
    public func createNewConversation(with otherUserEmail: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        var defaults = UserDefaults.standard
        guard let currentEmail = defaults.string(forKey: "email") else {return}
        
        //TODO: - Safe email for current email
        //FIXME: - safe email for other user email is needed
        let safeEmail = RealTimeDatabaseManager.safeEmail(emailAddress: currentEmail)
        
        let ref = database.child("\(safeEmail)")
        
        ///we go into the node of the email ID - to create conversation
        ref.observeSingleEvent(of: .value) { snapshot in
            
            
            ///checking if the user exists - which it should - we are just being 100% sure > to dig in its node
            guard var userNode = snapshot.value as? [String: Any] else {
                
                completion(false)
                print("user not found")
                return
            }
            
            
            ///creating date params here
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            
            //we get the content out of this
            var message = ""
            switch firstMessage.kind {
                
            //handling text type kind over here
            case .text(let messageText):
                message = messageText
                //this message is used below in the newconvo json
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            ///this is the new conversation block that we are checking if exists or else append the existing one.
            ///
            //MARK: - New Conversation Data is created here!
            let conversationID = "conversation_\(firstMessage.messageId)"
            //just making conversation id as a constant
            let newConversationData: [String: Any] = [
                "id": conversationID,
                    "other_user_email": otherUserEmail,
                    "latest_message": [
                    
                            "date": dateString,
                            "message": message,
                            "is_read": false
                    
                    ]
            ]
            
            ///this goes in ---
            
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                ///conversation node exists for current user and append the message here
                
                
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode) { [weak self] error, _ in
                    
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    
                    self?.finishCreatingConversation(conversationID: conversationID, firstMessage: firstMessage, completion: completion)
                    
                }
                
            } else {
                ///create a new conversation node in the above email id node.
                ///append the conversations data
                userNode["conversations"] = [
                    
                    newConversationData
                
                ]
                
                /// goes in this --- which goes in ---
                
                
            //this
                ref.setValue(userNode) { [weak self] error, _ in
                    
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    
                    self?.finishCreatingConversation(conversationID: conversationID, firstMessage: firstMessage, completion: completion)
                    
                    
                }
            }
            
        }

    }
    
    
    //MARK: - Finish creating conversations
    /// this helps in tracking real time conversations - so that we dont have to query the thread every single time.
    private func finishCreatingConversation(conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        /*
         
         {
         
            "id": String,
            "type": text, photo, video,
            "content": String,
            "date": Date(),
            "sender_email": String
         
         
         }

         */
        
        ///creating date params here
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        
        //we get the content out of this
        var message = ""
        switch firstMessage.kind {
            
        //handling text type kind over here
        case .text(let messageText):
            message = messageText
            //this message is used below in the newconvo json
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        guard let myEmail = UserDefaults.standard.string(forKey: "email") else {
           
            completion(false)
            return
        }

        //safe email
        let currentUserEmail = RealTimeDatabaseManager.safeEmail(emailAddress: myEmail)
        
        ///new collection message
        
        let collectionMessage: [String: Any] = [
        
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": currentUserEmail,
            "is_read": false
            
        ]
 
        ///pass this value
        let value: [String: Any] = [
        
            "messsages": [
            
                collectionMessage
            
            ]
        ]
        
        ///value passed in conversations - with above value
        database.child("\(conversationID)").setValue(value) { err, _ in
            guard err == nil else {
                completion(false)
                return
            }
            
        }
        
    }
    
    
    //MARK: - Get All Conversations
    
    /// Fetches and returns all conversation for the user with passed in email
    public func getAllConversations(for email: String, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
    
    /// Gets all messages for a given conversation
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
    
    /// Sends a message with target conversation and message
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
        
    }
    
    
    
}

struct ChatAppUser {
    
    let name: String
    let email: String
    let uid: String
    let profileImageUrl: String
    
    
    //computed property to get the safe email
    
    var safeEmail: String {
        
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        return safeEmail
        
    }
}


public enum DatabaseError: Error {
    case failedToFetch
}
