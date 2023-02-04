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
