//
//  MovieService.swift
//  FleekSpaces
//
//  Created by Mayur P on 06/06/23.
//



import Foundation
import Combine




final class MovieService {
    
  
    static let shared = MovieService()
    let ottPlatforms = ["YouTube", "Netflix", "Hotstar", "Zee5", "Voot", "Amazon Prime Video", "Sony Liv", "Alt Balaji"]
    //Amazon Prime Video
//    let ottPlatforms = ["Amazon Prime Video"]
   
//    let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_ott_trending/?ott_name=YouTube&type=movie")!
    
    
    private init() {
        
    }
    
    public func getMovie() async throws -> [MovieWidgetModel] {
        
        let mainOTT = ottPlatforms.randomElement()
        UserDefaults.standard.set(mainOTT, forKey: "ott")
        var components = URLComponents()
            components.scheme = "https"
            components.host = "api-space-dev.getfleek.app"
            components.path = "/shows/get_ott_trending"
            components.queryItems = [
                URLQueryItem(name: "ott_name", value: mainOTT),
                URLQueryItem(name: "type", value: "tv_series")
            ]

            // Getting a URL from our components is as simple as
            // accessing the 'url' property.
            let url = components.url
//        let url = URL(string: "https://api-space-dev.getfleek.app/shows/get_ott_trending/?ott_name=\(mainOTT!)&type=movie")!
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        let movie = try JSONDecoder().decode([MovieWidgetModel].self, from: data)
        let randoMovies = movie.shuffled()
        
        print("movie stuff \(movie)")
        return randoMovies
        
    }
    
    
}
