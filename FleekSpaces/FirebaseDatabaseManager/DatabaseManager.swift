//
//  DatabaseManager.swift
//  FleekSpaces
//
//  Created by Mayur P on 29/06/22.
//

import Foundation
import FirebaseDatabase
import AVFoundation


//MARK: - Database manager

final class DatabaseManager {
    
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
  
    static func safeEmail(emailAddress: String) -> String {
        
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    
    
}

//MARK: - Account management


extension DatabaseManager {
    
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
           
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            completion(.success(value))
            
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
    
    //MARK: - check if user exists
    
    ///check if email id exists
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
        
        
    }
    
    ///Insert a user to database
    //MARK: - insert user
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        
        database.child(user.safeEmail).setValue([
        
            "first_name": user.firstname,
            "last_name": user.lastName
            
        
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                
                print("failed to write to databse")
                completion(false)
                return
            }
            
            
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                
                if var userCollection = snapshot.value as? [[String: String]] {
                    
                    //apend to dictionary
                    let newElement = [
                    
                        
                            "name": user.firstname + "" + user.lastName,
                            "email": user.safeEmail
                    
                    ]
                    userCollection.append(newElement)
                    
                    self.database.child("users").setValue(userCollection, withCompletionBlock: {error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                        
                    })
                    
                } else {
                    
                    //create an array
                    let newCollection: [[String: String]] = [
                    
                        [
                            "name": user.firstname + "" + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]
                    
                    self.database.child("users").setValue(newCollection, withCompletionBlock: {error, _ in
                        guard error == nil else {
                            return
                        }
                        
                        completion(true)
                        
                    })
                }
                
            })
            
        })
        
    }
    
}

//MARK: - Sending messages / conversation


extension DatabaseManager {
    
    ///Creates a new conversation with target user  email and first message sent
    public func createNewConversation(with otherUserEmail: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
    }
    
    //fetches and returns all conversations for the user with passed in email
    public func getAllConversations (for email: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        
    }
    
    //get all message for a given conversation
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        
    }
    
    ///send a message with target conversation and message
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
        
    }
}

//MARK: - chat app user struct

struct ChatAppUser {
    
    let firstname: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
        
        
    }
    
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}
