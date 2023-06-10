//
//  MovieModel.swift
//  FleekSpaces
//
//  Created by Mayur P on 06/06/23.
//


import Foundation

// MARK: - MovieWidElement
struct MovieWidgetModel: Codable {
    let movieID: String?
    let tmdbID: Int?
    let createdAt, posterURL: String?
    let tmdbRating: Int?
    let imdbID, updatedAt: String?
  
    let releaseYear: Int?
   
    let title: String?
    

    enum CodingKeys: String, CodingKey {
        case movieID = "movie_id"
        case tmdbID = "tmdb_id"
        case createdAt = "created_at"
        case posterURL = "poster_url"
        case tmdbRating = "tmdb_rating"
        case imdbID = "imdb_id"
        case updatedAt = "updated_at"
       
        case releaseYear = "release_year"
        case title
    }
}

