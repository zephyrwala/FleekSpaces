////
////  StorageManager.swift
////  FleekSpaces
////
////  Created by Mayur P on 30/06/22.
////
//
//import Foundation
//import FirebaseStorage
//
//
//final class StorageManager {
//
//
//    static let shared = StorageManager()
//    private let storage = Storage.storage().reference()
//
//
//
//
//    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
//
//
//
//
//    //MARK: - upload picture
//    ///Uploads picture to firebase storage and returns completion of picture url
//    public func uploadProfilePicture(with data:Data, filename: String, completion: @escaping UploadPictureCompletion) {
//
//        storage.child("image/\(filename)").putData(data, metadata: nil) { metadata, error in
//
//
//            guard error == nil else {
//
//                //failed
//
//                print("Failed to upload data to firebase for picture")
//                completion(.failure(StorageErrors.failedToUpload))
//                return
//            }
//
//            self.storage.child("image/\(filename)").downloadURL { url, error in
//
//                guard let url = url else {
//                    print("Failed to get download url")
//                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
//                    return
//                }
//
//
//
//                let urlString = url.absoluteString
//                print("download returned: \(urlString)")
//                completion(.success(urlString))
//            }
//        }
//
//    }
//
//
//
//
//
//
//
//
//    public enum StorageErrors: Error {
//
//        case failedToUpload
//        case failedToGetDownloadUrl
//        case failedtoGetDownloadURL
//    }
//
//
//
//    //MARK: - Download url
//
//
//    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
//
//        let reference = storage.child(path)
//        reference.downloadURL(completion: { url, error in
//            guard let url = url, error == nil else {
//                completion(.failure(StorageErrors.failedToGetDownloadUrl))
//                return
//            }
//
//            completion(.success(url))
//        })
//    }
//
//}
