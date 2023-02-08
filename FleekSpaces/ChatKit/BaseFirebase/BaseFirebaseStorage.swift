//
//  BaseFirebaseStorage.swift
//  FleekSpaces
//
//  Created by Mayur P on 22/09/22.
//

import Foundation
import FirebaseStorage

public enum StorageErrors: Error {
    case failedToUpload
    case failedToGetDownloadUrl
}



final class StorageManager {
    
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    
    
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)

        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }

            completion(.success(url))
        })
    }
    
}
