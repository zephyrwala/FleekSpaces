//
//  TestDataModel.swift
//  FleekSpaces
//
//  Created by Mayur P on 01/06/22.
//
//

import Foundation



class MyMovieDataModel: NSObject {
    
    
    static var nowPlaying: NowPlayings?
    static var topRated: TopRated?
    static var movieReviews: Review?
    static var theActors: TheActors?
    static var tvshow: TVshow?
    static var upcoming: Upcoming?
    static var tvEpisodes: Episodes?
    static var streamingPlatform: [StreamingElement]?
    static var recentChat: [RecentMessage]?
   
    
    
}




// MARK: - StreamingElement
class StreamingElement: Codable {
    let updatedAt, createdAt: String?
    let iconURL: String?
    let slug, clearName, id, technicalName: String?
    let justwatchID: Int?
    let monetizationTypes: [MonetizationType]?

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case iconURL = "icon_url"
        case slug
        case clearName = "clear_name"
        case id
        case technicalName = "technical_name"
        case justwatchID = "justwatch_id"
        case monetizationTypes = "monetization_types"
    }

    init(updatedAt: String?, createdAt: String?, iconURL: String?, slug: String?, clearName: String?, id: String?, technicalName: String?, justwatchID: Int?, monetizationTypes: [MonetizationType]?) {
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.iconURL = iconURL
        self.slug = slug
        self.clearName = clearName
        self.id = id
        self.technicalName = technicalName
        self.justwatchID = justwatchID
        self.monetizationTypes = monetizationTypes
    }
}

enum MonetizationType: String, Codable {
    case ads = "ads"
    case buy = "buy"
    case flatrate = "flatrate"
    case free = "free"
    case rent = "rent"
}

typealias Streaming = [StreamingElement]



// MARK: - Episodes
class Episodes: Codable {
    let id, airDate: String?
    let episodes: [Episode]?
    let name, overview: String?
    let episodesID: Int?
    let posterPath: String?
    let seasonNumber: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case airDate = "air_date"
        case episodes, name, overview
        case episodesID = "id"
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }

    init(id: String?, airDate: String?, episodes: [Episode]?, name: String?, overview: String?, episodesID: Int?, posterPath: String?, seasonNumber: Int?) {
        self.id = id
        self.airDate = airDate
        self.episodes = episodes
        self.name = name
        self.overview = overview
        self.episodesID = episodesID
        self.posterPath = posterPath
        self.seasonNumber = seasonNumber
    }
}

// MARK: - Episode
class Episode: Codable {
    let airDate: String?
    let episodeNumber: Int?
    let crew, guestStars: [Crew]?
    let id: Int?
    let name, overview, productionCode: String?
    let seasonNumber: Int?
    let stillPath: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case crew
        case guestStars = "guest_stars"
        case id, name, overview
        case productionCode = "production_code"
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(airDate: String?, episodeNumber: Int?, crew: [Crew]?, guestStars: [Crew]?, id: Int?, name: String?, overview: String?, productionCode: String?, seasonNumber: Int?, stillPath: String?, voteAverage: Double?, voteCount: Int?) {
        self.airDate = airDate
        self.episodeNumber = episodeNumber
        self.crew = crew
        self.guestStars = guestStars
        self.id = id
        self.name = name
        self.overview = overview
        self.productionCode = productionCode
        self.seasonNumber = seasonNumber
        self.stillPath = stillPath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

// MARK: - Crew
class Crew: Codable {
    let department: Department?
    let job: Job?
    let creditID: String?
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment: Department?
    let name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let order: Int?
    let character: String?

    enum CodingKeys: String, CodingKey {
        case department, job
        case creditID = "credit_id"
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case order, character
    }

    init(department: Department?, job: Job?, creditID: String?, adult: Bool?, gender: Int?, id: Int?, knownForDepartment: Department?, name: String?, originalName: String?, popularity: Double?, profilePath: String?, order: Int?, character: String?) {
        self.department = department
        self.job = job
        self.creditID = creditID
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.order = order
        self.character = character
    }
}

enum Department: String, Codable {
    case acting = "Acting"
    case camera = "Camera"
    case creator = "Creator"
    case directing = "Directing"
    case editing = "Editing"
    case production = "Production"
    case writing = "Writing"
}

enum Job: String, Codable {
    case director = "Director"
    case directorOfPhotography = "Director of Photography"
    case editor = "Editor"
    case writer = "Writer"
}


// MARK: - Upcoming
class Upcoming: Codable {
    let dates: UDates?
    let page: Int?
    let results: [UResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(dates: UDates?, page: Int?, results: [UResult]?, totalPages: Int?, totalResults: Int?) {
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Dates
class UDates: Codable {
    let maximum, minimum: String?

    init(maximum: String?, minimum: String?) {
        self.maximum = maximum
        self.minimum = minimum
    }
}

// MARK: - Result
class UResult: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(adult: Bool?, backdropPath: String?, genreIDS: [Int]?, id: Int?, originalLanguage: String?, originalTitle: String?, overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

enum UOriginalLanguage: String, Codable {
    case en = "en"
    case fr = "fr"
    case ja = "ja"
    case ko = "ko"
}

//trending tv


// MARK: - TVshow
class TVshow: Codable {
    let page: Int?
    let results: [TVResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(page: Int?, results: [TVResult]?, totalPages: Int?, totalResults: Int?) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Result
class TVResult: Codable {
    let backdropPath: String?
    let firstAirDate: String?
    let genreIDS: [Int]?
    let id: Int?
    let name: String?
    let originCountry: [String]?
    let originalLanguage, originalName, overview: String?
    let popularity: Double?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id, name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(backdropPath: String?, firstAirDate: String?, genreIDS: [Int]?, id: Int?, name: String?, originCountry: [String]?, originalLanguage: String?, originalName: String?, overview: String?, popularity: Double?, posterPath: String?, voteAverage: Double?, voteCount: Int?) {
        self.backdropPath = backdropPath
        self.firstAirDate = firstAirDate
        self.genreIDS = genreIDS
        self.id = id
        self.name = name
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalName = originalName
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

//tv end
//start

// MARK: - TheActors
class TheActors: Codable {
    let page: Int?
    let results: [ActResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(page: Int?, results: [ActResult]?, totalPages: Int?, totalResults: Int?) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Result
class ActResult: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownFor: [KnownFor]?
    let knownForDepartment: KnownForDepartment?
    let name: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name, popularity
        case profilePath = "profile_path"
    }

    init(adult: Bool?, gender: Int?, id: Int?, knownFor: [KnownFor]?, knownForDepartment: KnownForDepartment?, name: String?, popularity: Double?, profilePath: String?) {
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownFor = knownFor
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.popularity = popularity
        self.profilePath = profilePath
    }
}

// MARK: - KnownFor
class KnownFor: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let mediaType: MediaType?
    let originalLanguage: ActOriginalLanguage?
    let originalTitle, overview, posterPath, releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let firstAirDate, name: String?
    let originCountry: [OriginCountry]?
    let originalName: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
        case name
        case originCountry = "origin_country"
        case originalName = "original_name"
    }

    init(adult: Bool?, backdropPath: String?, genreIDS: [Int]?, id: Int?, mediaType: MediaType?, originalLanguage: ActOriginalLanguage?, originalTitle: String?, overview: String?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?, firstAirDate: String?, name: String?, originCountry: [OriginCountry]?, originalName: String?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.mediaType = mediaType
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.firstAirDate = firstAirDate
        self.name = name
        self.originCountry = originCountry
        self.originalName = originalName
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

enum OriginCountry: String, Codable {
    case jp = "JP"
    case th = "TH"
    case us = "US"
}

enum ActOriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
    case th = "th"
}



enum KnownForDepartment: String, Codable {
    case acting = "Acting"
}


//end

//start

// MARK: - Review
class Review: Codable {
    let id, page: Int?
    let results: [ReResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(id: Int?, page: Int?, results: [ReResult]?, totalPages: Int?, totalResults: Int?) {
        self.id = id
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Result
class ReResult: Codable {
    let author: String?
    let authorDetails: AuthorDetails?
    let content, createdAt, id, updatedAt: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }

    init(author: String?, authorDetails: AuthorDetails?, content: String?, createdAt: String?, id: String?, updatedAt: String?, url: String?) {
        self.author = author
        self.authorDetails = authorDetails
        self.content = content
        self.createdAt = createdAt
        self.id = id
        self.updatedAt = updatedAt
        self.url = url
    }
}

// MARK: - AuthorDetails
class AuthorDetails: Codable {
    let name, username: String?
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }

    init(name: String?, username: String?, avatarPath: String?, rating: Int?) {
        self.name = name
        self.username = username
        self.avatarPath = avatarPath
        self.rating = rating
    }
}


//end

// MARK: - TopRated
class TopRated: Codable {
    let page: Int?
    let results: [TResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(page: Int?, results: [TResult]?, totalPages: Int?, totalResults: Int?) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Result
class TResult: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(adult: Bool?, backdropPath: String?, genreIDS: [Int]?, id: Int?, originalLanguage: String?, originalTitle: String?, overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}


// MARK: - NowPlayings
class NowPlayings: Codable {
    let dates: Dates?
    let page: Int?
    let results: [Results]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(dates: Dates?, page: Int?, results: [Results]?, totalPages: Int?, totalResults: Int?) {
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Dates
class Dates: Codable {
    let maximum, minimum: String?

    init(maximum: String?, minimum: String?) {
        self.maximum = maximum
        self.minimum = minimum
    }
}

// MARK: - Result
class Results: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: OriginalLanguage?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(adult: Bool?, backdropPath: String?, genreIDS: [Int]?, id: Int?, originalLanguage: OriginalLanguage?, originalTitle: String?, overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

enum OriginalLanguage: String, Codable {
    case de = "de"
    case en = "en"
    case fr = "fr"
}
