//
//  SpacesNetworkService.swift
//  SpacesWatch Watch App
//
//  Created by Mayur P on 16/06/23.
//

//

import Foundation
import SwiftUI


final class PlatformService {
    
    
    static let shared = PlatformService()
    let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_available_streaming_services/")!
    
    
    private init() {
        
    }
    
    public func getMovie() async throws -> [Platforms] {
        
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let movie = try JSONDecoder().decode([Platforms].self, from: data)
        let randoMovie = movie.shuffled()
        print("movie stuff \(movie)")
        let uro = URL(string: "\(movie[0].iconURL)")
        print("URLO - \(uro)")
        return randoMovie
        
        
    }
    
    
}



class OTTService {
    
    
    static let shared = OTTService()
//    var ottName = "YouTube"
//
//
//
    private init() {

    }
//
//    init(ottName: String = "YouTube") {
//        self.ottName = ottName
//    }
    
    //MARK: - Get Movies
    public func getMovie(ottNames: String) async throws -> [OTTDetail] {
        
//
//        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_ott_trending/?ott_name=\(ottNames)&type=movie")!
        
        var components = URLComponents()
            components.scheme = "https"
            components.host = "api-space-dev.getfleek.app"
            components.path = "/shows/get_ott_trending"
            components.queryItems = [
                URLQueryItem(name: "ott_name", value: ottNames),
                URLQueryItem(name: "type", value: "movie")
            ]

            // Getting a URL from our components is as simple as
            // accessing the 'url' property.
            let url = components.url
        print(url)
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        let movie = try JSONDecoder().decode([OTTDetail].self, from: data)
        let randoMovie = movie.shuffled()
        print("movie stuff \(movie)")
        let uro = URL(string: "\(movie[0].posterURL)")
        print("URLO - \(uro)")
        return randoMovie
        
        
    }
    
    
    //MARK: - Get TV shows
    
    public func getTVshows(ottNames: String) async throws -> [TVDetail] {
        
//
//        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_ott_trending/?ott_name=\(ottNames)&type=movie")!
        
        var components = URLComponents()
            components.scheme = "https"
            components.host = "api-space-dev.getfleek.app"
            components.path = "/shows/get_ott_trending"
            components.queryItems = [
                URLQueryItem(name: "ott_name", value: ottNames),
                URLQueryItem(name: "type", value: "tv_series")
            ]

            // Getting a URL from our components is as simple as
            // accessing the 'url' property.
            let url = components.url
        print(url)
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        let movie = try JSONDecoder().decode([TVDetail].self, from: data)
        let randoMovie = movie.shuffled()
        print("movie stuff \(movie)")
        let uro = URL(string: "\(movie[0].posterURL)")
        print("URLO - \(uro)")
        return randoMovie
        
        
    }
    
    
}



