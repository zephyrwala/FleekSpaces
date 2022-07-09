//
//  ChatUser.swift
//  FleekSpaces
//
//  Created by Mayur P on 06/07/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore


struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, profileImageUrl: String
}
