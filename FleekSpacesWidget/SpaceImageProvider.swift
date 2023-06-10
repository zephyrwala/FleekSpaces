////
////  SpaceImageProvider.swift
////  FleekSpaces
////
////  Created by Mayur P on 03/06/23.
////
//
//import Foundation
//import SwiftUI
//
//enum ApodImageResponse {
//
//    case Success(image: UIImage, title: String)
//        case Failure
//
//}
//
//
//
//
//
//// MARK: - ApodAPIResponseElement
//struct ApodApiResponse: Decodable {
//
//    let posterURL: String?
//
//
//    enum CodingKeys: String, CodingKey {
//
//        case posterURL = "poster_url"
//
//    }
//
//
//}
//
//class ApodImageProvider {
//
//    static func getImageFromApi(completion: ((ApodImageResponse) -> Void)?) {
//        print("HEYOyo")
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.timeZone = TimeZone(abbreviation: "UTC")
//        let date = Date()
//        let urlString = "https://api-space-dev.getfleek.app/shows/get_ott_trending/?ott_name=Netflix&type=movie"
//
//        let url = URL(string: urlString)!
//        let urlRequest = URLRequest(url: url)
//        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
//            parseResponseAndGetImage(data: data, urlResponse: urlResponse, error: error, completion: completion)
//        }
//        print("HEYO")
//        task.resume()
//    }
//
//    static func parseResponseAndGetImage(data: Data?, urlResponse: URLResponse?, error: Error?, completion: ((ApodImageResponse) -> Void)?) {
//
//        guard error == nil, let content = data else {
//            print("error getting data from API")
//            let response = ApodImageResponse.Failure
//            completion?(response)
//            return
//        }
//
//        var apodApiResponse: [ApodApiResponse]
//        do {
//            apodApiResponse = try JSONDecoder().decode([ApodApiResponse].self, from: content)
//        } catch {
//            print("error parsing URL from data")
//            let response = ApodImageResponse.Failure
//            completion?(response)
//            return
//        }
//
//        guard let safeURL = apodApiResponse[0].posterURL else {return}
//        let url = URL(string: "https://image.tmdb.org/t/p/original/\(apodApiResponse[0].posterURL)")!
//        let urlRequest = URLRequest(url: url)
//        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
//            parseImageFromResponse(data: data, urlResponse: urlResponse, error: error, completion: completion)
//        }
//        task.resume()
//
//    }
//
//    static func parseImageFromResponse(data: Data?, urlResponse: URLResponse?, error: Error?, completion: ((ApodImageResponse) -> Void)?) {
//
//        guard error == nil, let content = data else {
//            print("error getting image data")
//            let response = ApodImageResponse.Failure
//            completion?(response)
//            return
//        }
//
//        let image = UIImage(data: content)!
//        let response = ApodImageResponse.Success(image: image, title: "Test")
//        completion?(response)
//    }
//}



//
//  ApodImageProvider.swift
//  ApodWidgetExtension
//
//  Created by SchwiftyUI on 12/7/20.
//

import Foundation
import SwiftUI

enum ApodImageResponse {
    case Success(image: UIImage, title: String)
    case Failure
}

struct ApodApiResponse: Decodable {
    var url: String
    var title: String
}

class ApodImageProvider {
    static func getImageFromApi(completion: ((ApodImageResponse) -> Void)?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = Date()
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=eaRYg7fgTemadUv1bQawGRqCWBgktMjolYwiRrHK&date=\(formatter.string(from: date))"
        
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            parseResponseAndGetImage(data: data, urlResponse: urlResponse, error: error, completion: completion)
        }
        task.resume()
    }
    
    static func parseResponseAndGetImage(data: Data?, urlResponse: URLResponse?, error: Error?, completion: ((ApodImageResponse) -> Void)?) {
        
        guard error == nil, let content = data else {
            print("error getting data from API")
            let response = ApodImageResponse.Failure
            completion?(response)
            return
        }
        
        var apodApiResponse: ApodApiResponse
        do {
            apodApiResponse = try JSONDecoder().decode(ApodApiResponse.self, from: content)
        } catch {
            print("error parsing URL from data")
            let response = ApodImageResponse.Failure
            completion?(response)
            return
        }
        
        let url = URL(string: apodApiResponse.url)!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            parseImageFromResponse(data: data, urlResponse: urlResponse, error: error, apodApiResponse: apodApiResponse, completion: completion)
        }
        task.resume()
        
    }
    
    static func parseImageFromResponse(data: Data?, urlResponse: URLResponse?, error: Error?, apodApiResponse: ApodApiResponse, completion: ((ApodImageResponse) -> Void)?) {
        
        guard error == nil, let content = data else {
            print("error getting image data")
            let response = ApodImageResponse.Failure
            completion?(response)
            return
        }
        
        let image = UIImage(data: content)!
        let response = ApodImageResponse.Success(image: image, title: apodApiResponse.title)
        completion?(response)
    }
}
