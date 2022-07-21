//
//  FinalDataModel.swift
//  FleekSpaces
//
//  Created by Mayur P on 20/07/22.
//

import Foundation


class FinalDataModel: NSObject {
    
    
    static var worldWide: [Worldwide]?
   
   
    static var movieDetails: MovieDetail?
    
}




// MARK: - MovieDetail
class MovieDetail: Codable {
    let movieID: String?
    let tmdbID: Int?
    let createdAt, posterURL: String?
    let tmdbRating: Int?
    let imdbID, updatedAt, originalLanguage: String?
    let releaseYear: Int?
    let genres: [MovieGenre]?
    let title, type: String?
    let productionCountries: [ProductionCountry]?
    let synopsies: String?
    let runtime, budget: Int?
    let castAndCrew: [CastAndCrew]?
    let releaseDate: String?
    let revenue: Int?
    let providerOffers, tagline: String?
    let images: [MovieImage]?
    let trailerUrls: [TrailerURL]?

    enum CodingKeys: String, CodingKey {
        case movieID = "movie_id"
        case tmdbID = "tmdb_id"
        case createdAt = "created_at"
        case posterURL = "poster_url"
        case tmdbRating = "tmdb_rating"
        case imdbID = "imdb_id"
        case updatedAt = "updated_at"
        case originalLanguage = "original_language"
        case releaseYear = "release_year"
        case genres, title, type
        case productionCountries = "production_countries"
        case synopsies, runtime, budget
        case castAndCrew = "cast_and_crew"
        case releaseDate = "release_date"
        case revenue
        case providerOffers = "provider_offers"
        case tagline, images
        case trailerUrls = "trailer_urls"
    }

    init(movieID: String?, tmdbID: Int?, createdAt: String?, posterURL: String?, tmdbRating: Int?, imdbID: String?, updatedAt: String?, originalLanguage: String?, releaseYear: Int?, genres: [MovieGenre]?, title: String?, type: String?, productionCountries: [ProductionCountry]?, synopsies: String?, runtime: Int?, budget: Int?, castAndCrew: [CastAndCrew]?, releaseDate: String?, revenue: Int?, providerOffers: String?, tagline: String?, images: [MovieImage]?, trailerUrls: [TrailerURL]?) {
        self.movieID = movieID
        self.tmdbID = tmdbID
        self.createdAt = createdAt
        self.posterURL = posterURL
        self.tmdbRating = tmdbRating
        self.imdbID = imdbID
        self.updatedAt = updatedAt
        self.originalLanguage = originalLanguage
        self.releaseYear = releaseYear
        self.genres = genres
        self.title = title
        self.type = type
        self.productionCountries = productionCountries
        self.synopsies = synopsies
        self.runtime = runtime
        self.budget = budget
        self.castAndCrew = castAndCrew
        self.releaseDate = releaseDate
        self.revenue = revenue
        self.providerOffers = providerOffers
        self.tagline = tagline
        self.images = images
        self.trailerUrls = trailerUrls
    }
}

// MARK: - CastAndCrew
class CastAndCrew: Codable {
    let castID: Int?
    let character: String?
    let gender: Int?
    let creditID: String?
    let knownForDepartment: String?
    let originalName: String?
    let popularity: Int?
    let name: String?
    let profilePath: String?
    let id: Int?
    let adult: Bool?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case castID = "cast_id"
        case character, gender
        case creditID = "credit_id"
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case popularity, name
        case profilePath = "profile_path"
        case id, adult, order
    }

    init(castID: Int?, character: String?, gender: Int?, creditID: String?, knownForDepartment: String?, originalName: String?, popularity: Int?, name: String?, profilePath: String?, id: Int?, adult: Bool?, order: Int?) {
        self.castID = castID
        self.character = character
        self.gender = gender
        self.creditID = creditID
        self.knownForDepartment = knownForDepartment
        self.originalName = originalName
        self.popularity = popularity
        self.name = name
        self.profilePath = profilePath
        self.id = id
        self.adult = adult
        self.order = order
    }
}



// MARK: - Genre
class MovieGenre: Codable {
    let name: String?
    let id: Int?

    init(name: String?, id: Int?) {
        self.name = name
        self.id = id
    }
}

// MARK: - Image
class MovieImage: Codable {
    let posters, backdrops: [Backdrop]?

    init(posters: [Backdrop]?, backdrops: [Backdrop]?) {
        self.posters = posters
        self.backdrops = backdrops
    }
}

// MARK: - Backdrop
class Backdrop: Codable {
    let width: Int?
    let filePath: String?
    let height: Int?

    enum CodingKeys: String, CodingKey {
        case width
        case filePath = "file_path"
        case height
    }

    init(width: Int?, filePath: String?, height: Int?) {
        self.width = width
        self.filePath = filePath
        self.height = height
    }
}

// MARK: - ProductionCountry
class ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }

    init(iso3166_1: String?, name: String?) {
        self.iso3166_1 = iso3166_1
        self.name = name
    }
}

// MARK: - TrailerURL
class TrailerURL: Codable {
    let site: String?
    let size: Int?
    let iso3166_1, name: String?
    let official: Bool?
    let id, publishedAt, type, iso639_1: String?
    let key: String?

    enum CodingKeys: String, CodingKey {
        case site, size
        case iso3166_1 = "iso_3166_1"
        case name, official, id
        case publishedAt = "published_at"
        case type
        case iso639_1 = "iso_639_1"
        case key
    }

    init(site: String?, size: Int?, iso3166_1: String?, name: String?, official: Bool?, id: String?, publishedAt: String?, type: String?, iso639_1: String?, key: String?) {
        self.site = site
        self.size = size
        self.iso3166_1 = iso3166_1
        self.name = name
        self.official = official
        self.id = id
        self.publishedAt = publishedAt
        self.type = type
        self.iso639_1 = iso639_1
        self.key = key
    }
}


// MARK: - WorldwideElement
class Worldwide: Codable {
    let movieID: String?
    let tmdbID: Int?
    let createdAt, posterURL: String?
    let tmdbRating: Int?
    let imdbID, updatedAt, originalLanguage: String?
    let releaseYear: Int?
    let genres: [Genre]?
    let title, type: String?

    enum CodingKeys: String, CodingKey {
        case movieID = "movie_id"
        case tmdbID = "tmdb_id"
        case createdAt = "created_at"
        case posterURL = "poster_url"
        case tmdbRating = "tmdb_rating"
        case imdbID = "imdb_id"
        case updatedAt = "updated_at"
        case originalLanguage = "original_language"
        case releaseYear = "release_year"
        case genres, title, type
    }

    init(movieID: String?, tmdbID: Int?, createdAt: String?, posterURL: String?, tmdbRating: Int?, imdbID: String?, updatedAt: String?, originalLanguage: String?, releaseYear: Int?, genres: [Genre]?, title: String?, type: String?) {
        self.movieID = movieID
        self.tmdbID = tmdbID
        self.createdAt = createdAt
        self.posterURL = posterURL
        self.tmdbRating = tmdbRating
        self.imdbID = imdbID
        self.updatedAt = updatedAt
        self.originalLanguage = originalLanguage
        self.releaseYear = releaseYear
        self.genres = genres
        self.title = title
        self.type = type
    }
}

// MARK: - Genre
class Genre: Codable {
    let name: String?
    let id: Int?

    init(name: String?, id: Int?) {
        self.name = name
        self.id = id
    }
}



