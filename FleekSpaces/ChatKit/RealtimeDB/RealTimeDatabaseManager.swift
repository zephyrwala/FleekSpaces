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
        
        database.child(email).observeSingleEvent(of: .value) { snapshot in
            
            
            guard let foundEmail = snapshot.value as? String else {
                completion(false)
                return
                
            }
            
            completion(true)
        }
        
    }
    
    
    public func insertUser(with user: ChatAppUser) {
        
        
        database.child(user.email).setValue([
            "name": user.name,
            "uid": user.uid,
            "profileImageUrl": user.profileImageUrl
            
        ])
        
    }
    
}

struct ChatAppUser {
    
    let name: String
    let email: String
    let uid: String
    let profileImageUrl: String
    
    
}
