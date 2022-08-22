//
//  FinalDataModel.swift
//  FleekSpaces
//
//  Created by Mayur P on 20/07/22.
//

import Foundation


class FinalDataModel: NSObject {
    
    
    static var worldWide: [Worldwide]?
    static var ottShow: [OTTshow]?
   
    static var movieDetails: MovieDetail?
    
    static var actorDetails: ActorDetails?
    
    static var tvShow: [TVshowElement]?
    
    static var showDetails: TVshowDetail?
    
    static var ottMovie: [OTTmovie]?
    
    static var episodesList: EpisodesList?
    
    static var episodeDetailData: EpisodeDetailData?
    
    static var similarMovies: SimilarMovies?
    
    static var similarTV: SimilarTV?
    
    static var actorMovie: ActorMovieDetail?
    
    static var searchResult: [SearchResultElement]?
}

//MARK: - Login
class LoginMessage: Codable {
    let message: String?
    let error: String?

    init(message: String?, error: String?) {
        self.message = message
        self.error = error
    }
}

// MARK: - SearchResultElement
class SearchResultElement: Codable {
   
    let type: String?
    let tmdbID: Int?
    let title: String?
    let tmdbRating: Double?
    let posterPath: String?
    let releaseYear: String?
    let genres: [String]?
    let synopsies: String?

    enum CodingKeys: String, CodingKey {
        
        case type
        case tmdbID = "tmdb_id"
        case title
        case tmdbRating = "tmdb_rating"
        case posterPath = "poster_path"
        case releaseYear = "release_year"
        case genres, synopsies
    }

    init(type: String?,tmdbID: Int?, title: String?, tmdbRating: Double?, posterPath: String?, releaseYear: String?, genres: [String]?, synopsies: String?) {
        
        self.type = type
        self.tmdbID = tmdbID
        self.title = title
        self.tmdbRating = tmdbRating
        self.posterPath = posterPath
        self.releaseYear = releaseYear
        self.genres = genres
        self.synopsies = synopsies
    }
}





typealias SearchResult = [SearchResultElement]


// MARK: - ActorMovieDetail
class ActorMovieDetail: Codable {
    let adult: Bool?
    let alsoKnownAs: [String]?
    let biography, gender: String?
    let homepage: String?
    let id: Int?
    let knownForDepartment, name, placeOfBirth: String?
    let popularity: Double?
    let profilePath: String?
//    let externalIDS: ExternalIDS?
    let images: [String]?
    let filmography: ActFilmography?
    let birthDay: String?
//    let deathDay: JSONNull?

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, gender, homepage, id
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
//        case externalIDS = "external_ids"
        case images, filmography
        case birthDay = "birth_day"
//        case deathDay = "death_day"
    }

    init(adult: Bool?, alsoKnownAs: [String]?, biography: String?, gender: String?, homepage: String?, id: Int?, knownForDepartment: String?, name: String?, placeOfBirth: String?, popularity: Double?, profilePath: String?, images: [String]?, filmography: ActFilmography?, birthDay: String?) {
        self.adult = adult
        self.alsoKnownAs = alsoKnownAs
        self.biography = biography
        self.gender = gender
        self.homepage = homepage
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.placeOfBirth = placeOfBirth
        self.popularity = popularity
        self.profilePath = profilePath
//        self.externalIDS = externalIDS
        self.images = images
        self.filmography = filmography
        self.birthDay = birthDay
//        self.deathDay = deathDay
    }
}

// MARK: - Filmography
class ActFilmography: Codable {
    let cast: [ActCast]?
    let crew: [ActCrew]?

    init(cast: [ActCast]?, crew: [ActCrew]?) {
        self.cast = cast
        self.crew = crew
    }
}

// MARK: - Crew
class ActCrew: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
//    let originalLanguage: OriginalLanguage?
    let  overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let creditID, department, job: String?
//    let mediaType: MediaType?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case creditID = "credit_id"
        case department, job
//        case mediaType = "media_type"
    }

    init(adult: Bool?, backdropPath: String?, genreIDS: [Int]?, id: Int?, overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?, creditID: String?, department: String?, job: String?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
      
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.creditID = creditID
        self.department = department
        self.job = job
//        self.mediaType = mediaType
    }
}

// MARK: - Cast
class ActCast: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
//    let originalLanguage: OriginalLanguage?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let character, creditID: String?
    let order: Int?
    let mediaType: MediaType?
//    let originCountry: [OriginCountry]?
    let originalName, firstAirDate, name: String?
    let episodeCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case character
        case creditID = "credit_id"
        case order
        case mediaType = "media_type"
//        case originCountry = "origin_country"
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case name
        case episodeCount = "episode_count"
    }

    init(adult: Bool?, backdropPath: String?, genreIDS: [Int]?, id: Int?, overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?, character: String?, creditID: String?, order: Int?, mediaType: MediaType?, originalName: String?, firstAirDate: String?, name: String?, episodeCount: Int?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
//        self.originalLanguage = originalLanguage
//        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.character = character
        self.creditID = creditID
        self.order = order
        self.mediaType = mediaType
//        self.originCountry = originCountry
        self.originalName = originalName
        self.firstAirDate = firstAirDate
        self.name = name
        self.episodeCount = episodeCount
    }
}

// MARK: - ExternalIDS
class ExternalIDS: Codable {
    let freebaseMid, freebaseID, imdbID: String?
    let tvrageID: Int?
    let facebookID, instagramID, twitterID: String?

    enum CodingKeys: String, CodingKey {
        case freebaseMid = "freebase_mid"
        case freebaseID = "freebase_id"
        case imdbID = "imdb_id"
        case tvrageID = "tvrage_id"
        case facebookID = "facebook_id"
        case instagramID = "instagram_id"
        case twitterID = "twitter_id"
    }

    init(freebaseMid: String?, freebaseID: String?, imdbID: String?, tvrageID: Int?, facebookID: String?, instagramID: String?, twitterID: String?) {
        self.freebaseMid = freebaseMid
        self.freebaseID = freebaseID
        self.imdbID = imdbID
        self.tvrageID = tvrageID
        self.facebookID = facebookID
        self.instagramID = instagramID
        self.twitterID = twitterID
    }
}

// MARK: - Filmography
class Filmography: Codable {
    let cast: [MovCast]?
    let crew: [MovCrew]?

    init(cast: [MovCast]?, crew: [MovCrew]?) {
        self.cast = cast
        self.crew = crew
    }
}

// MARK: - Cast
class MovCast: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
//    let originalLanguage: OriginalLanguage?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let character, creditID: String?
    let order: Int?
//    let mediaType: MediaType?
    let originCountry: [MovOriginCountry]?
    let originalName, firstAirDate, name: String?
    let episodeCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
//        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case character
        case creditID = "credit_id"
        case order
//        case mediaType = "media_type"
        case originCountry = "origin_country"
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case name
        case episodeCount = "episode_count"
    }

    init(adult: Bool?, backdropPath: String?, genreIDS: [Int]?, id: Int?, originalTitle: String?, overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?, character: String?, creditID: String?, order: Int?, originCountry: [MovOriginCountry]?, originalName: String?, firstAirDate: String?, name: String?, episodeCount: Int?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
//        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.character = character
        self.creditID = creditID
        self.order = order
//        self.mediaType = mediaType
        self.originCountry = originCountry
        self.originalName = originalName
        self.firstAirDate = firstAirDate
        self.name = name
        self.episodeCount = episodeCount
    }
}



enum MovOriginCountry: String, Codable {
    case us = "US"
}



// MARK: - Crew
class MovCrew: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: OriginalLanguage?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let creditID, department, job: String?
    let mediaType: MediaType?

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
        case creditID = "credit_id"
        case department, job
        case mediaType = "media_type"
    }

    init(adult: Bool?, backdropPath: String?, genreIDS: [Int]?, id: Int?, originalLanguage: OriginalLanguage?, originalTitle: String?, overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?, creditID: String?, department: String?, job: String?, mediaType: MediaType?) {
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
        self.creditID = creditID
        self.department = department
        self.job = job
        self.mediaType = mediaType
    }
}


// MARK: - SimilarTV
class SimilarTV: Codable {
    let page: Int?
    let results: [SimTVResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(page: Int?, results: [SimTVResult]?, totalPages: Int?, totalResults: Int?) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Result
class SimTVResult: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
   
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
       
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(adult: Bool?, backdropPath: String?, genreIDS: [Int]?, id: Int?, originalTitle: String?, overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
       
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




// MARK: - SimilarMovies
class SimilarMovies: Codable {
    let page: Int?
    let results: [SimResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init(page: Int?, results: [SimResult]?, totalPages: Int?, totalResults: Int?) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Result
class SimResult: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
  
    let overview: String?
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
       
      
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(adult: Bool?, backdropPath: String?, genreIDS: [Int]?, id: Int?, originalTitle: String?, overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        
       
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




// MARK: - EpisodeDetailData
class EpisodeDetailData: Codable {
    let airDate: String?
    let episodeNumber: Int?
    let name, overview: String?
    let id: Int?
    let productionCode: String?
    let runtime, seasonNumber: Int?
    let stillPath: String?
    let voteAverage: Double?
    let voteCount: Int?
   
    let images: [EpisodeImage]?
    let watchProviders: EpisodeWatchProviders?
    
    let casts: [EpisodeCast]?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case name, overview, id
        case productionCode = "production_code"
        case runtime
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case images
        case watchProviders = "watch/providers"
        case casts
    }

    init(airDate: String?, episodeNumber: Int?, name: String?, overview: String?, id: Int?, productionCode: String?, runtime: Int?, seasonNumber: Int?, stillPath: String?, voteAverage: Double?, voteCount: Int?, images: [EpisodeImage]?, watchProviders: EpisodeWatchProviders?, casts: [EpisodeCast]?) {
        self.airDate = airDate
        self.episodeNumber = episodeNumber
        self.name = name
        self.overview = overview
        self.id = id
        self.productionCode = productionCode
        self.runtime = runtime
        self.seasonNumber = seasonNumber
        self.stillPath = stillPath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
       
        self.images = images
        self.watchProviders = watchProviders
        self.casts = casts
    }
}

class EpisodeCast: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment, name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let character, creditID: String?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case character
        case creditID = "credit_id"
        case order
    }

    init(adult: Bool?, gender: Int?, id: Int?, knownForDepartment: String?, name: String?, originalName: String?, popularity: Double?, profilePath: String?, character: String?, creditID: String?, order: Int?) {
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.character = character
        self.creditID = creditID
        self.order = order
    }
}
// MARK: - Image
class EpisodeImage: Codable {
    let aspectRatio: Double?
    let height: Int?
    let iso639_1: String?
    let filePath: String?
    let voteAverage: Double?
    let voteCount, width: Int?

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1 = "iso_639_1"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }

    init(aspectRatio: Double?, height: Int?, iso639_1: String?, filePath: String?, voteAverage: Double?, voteCount: Int?, width: Int?) {
        self.aspectRatio = aspectRatio
        self.height = height
        self.iso639_1 = iso639_1
        self.filePath = filePath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.width = width
    }
}

// MARK: - WatchProviders
class EpisodeWatchProviders: Codable {
    let watchProvidersIN, us: EpisodeIn?

    enum CodingKeys: String, CodingKey {
        case watchProvidersIN = "IN"
        case us = "US"
    }

    init(watchProvidersIN: EpisodeIn?, us: EpisodeIn?) {
        self.watchProvidersIN = watchProvidersIN
        self.us = us
    }
}

// MARK: - In
class EpisodeIn: Codable {
    let link: String?
    let flatrate: [EpisodeFlatrate]?

    init(link: String?, flatrate: [EpisodeFlatrate]?) {
        self.link = link
        self.flatrate = flatrate
    }
}

// MARK: - Flatrate
class EpisodeFlatrate: Codable {
    let displayPriority: Int?
    let logoPath: String?
    let providerID: Int?
    let providerName: String?

    enum CodingKeys: String, CodingKey {
        case displayPriority = "display_priority"
        case logoPath = "logo_path"
        case providerID = "provider_id"
        case providerName = "provider_name"
    }

    init(displayPriority: Int?, logoPath: String?, providerID: Int?, providerName: String?) {
        self.displayPriority = displayPriority
        self.logoPath = logoPath
        self.providerID = providerID
        self.providerName = providerName
    }
}




// MARK: - EpisodesList
class EpisodesList: Codable {
    let updatedAt: String?
    let tmdbID: Int?
    let synopsies, airDate, createdAt: String?
    let episodes: [MyEpisode]?
    let showID: String?
   
   
    let name: String?
    let seasonNumber: Int?

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case tmdbID = "tmdb_id"
        case synopsies
        case airDate = "air_date"
        case createdAt = "created_at"
        case episodes
        case showID = "show_id"
      
       
        case name
        case seasonNumber = "season_number"
    }

    init(updatedAt: String?, tmdbID: Int?, synopsies: String?, airDate: String?, createdAt: String?, episodes: [MyEpisode]?, showID: String?, name: String?, seasonNumber: Int?) {
        self.updatedAt = updatedAt
        self.tmdbID = tmdbID
        self.synopsies = synopsies
        self.airDate = airDate
        self.createdAt = createdAt
        self.episodes = episodes
        self.showID = showID
      
      
        self.name = name
        self.seasonNumber = seasonNumber
    }
}

// MARK: - Episode
class MyEpisode: Codable {
    let backdropPath, airDate: String?
    let episodeNumber: Int?
    let name: String?
    let runtime, id: Int?
    let synopsies: String?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case name, runtime, id, synopsies
    }

    init(backdropPath: String?, airDate: String?, episodeNumber: Int?, name: String?, runtime: Int?, id: Int?, synopsies: String?) {
        self.backdropPath = backdropPath
        self.airDate = airDate
        self.episodeNumber = episodeNumber
        self.name = name
        self.runtime = runtime
        self.id = id
        self.synopsies = synopsies
    }
}


// MARK: - Poster
class Poster: Codable {
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



// MARK: - OTTmovieElement
class OTTmovie: Codable {
    let movieID: String?
    let tmdbID: Int?
    let createdAt, posterURL: String?
    let tmdbRating: Int?
    let imdbID, updatedAt: String?
    let originalLanguage: String?
    let releaseYear: Int?
    let genres: [Genre]?
    let title: String?

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
        case genres, title
    }

    init(movieID: String?, tmdbID: Int?, createdAt: String?, posterURL: String?, tmdbRating: Int?, imdbID: String?, updatedAt: String?, originalLanguage: String?, releaseYear: Int?, genres: [Genre]?, title: String?) {
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
       
    }
}









// MARK: - OTTshow
class OTTshow: Codable {
    let tmdbID: Int?
    let createdAt, showID, posterURL: String?
    let createdBy: [CreatedBy]?
    let tmdbRating: Int?
    let updatedAt: String?
    let originalLanguage: String?
    let releaseYear: Int?
    let genres: [Genre]?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case tmdbID = "tmdb_id"
        case createdAt = "created_at"
        case showID = "show_id"
        case posterURL = "poster_url"
        case createdBy = "created_by"
        case tmdbRating = "tmdb_rating"
        case updatedAt = "updated_at"
        case originalLanguage = "original_language"
        case releaseYear = "release_year"
        case genres, title
    }

    init(tmdbID: Int?, createdAt: String?, showID: String?, posterURL: String?, createdBy: [CreatedBy]?, tmdbRating: Int?, updatedAt: String?, originalLanguage: String?, releaseYear: Int?, genres: [Genre]?, title: String?) {
        self.tmdbID = tmdbID
        self.createdAt = createdAt
        self.showID = showID
        self.posterURL = posterURL
        self.createdBy = createdBy
        self.tmdbRating = tmdbRating
        self.updatedAt = updatedAt
        self.originalLanguage = originalLanguage
        self.releaseYear = releaseYear
        self.genres = genres
        self.title = title
       
    }
}









// MARK: - TVShowDetails
class TVshowDetail: Codable {
    let tmdbID: Int?
    let synopsies, createdAt, showID, posterURL: String?
    let createdBy: [TVCreatedBy]?
    let tmdbRating: Int?
    let updatedAt, originalLanguage: String?
    let releaseYear: Int?
    let firstAirDate: String?
    let genres: [TVGenres]?
    let title, type, lastAirDate: String?
    let images: [TVImage]?
    let trailerUrls: [TVTrailerURL]?
    let productionCountries: [TVProductionCountry]?
    let providerOffers: TVProviderOffers?
    let episodeRuntime: [Int]?
    let castAndCrew: [TVCastAndCrew]?
    let tagline: String?
    let languages: [String]?
    let seasons: [TVSeason]?

    enum CodingKeys: String, CodingKey {
        case tmdbID = "tmdb_id"
        case synopsies
        case createdAt = "created_at"
        case showID = "show_id"
        case posterURL = "poster_url"
        case createdBy = "created_by"
        case tmdbRating = "tmdb_rating"
        case updatedAt = "updated_at"
        case originalLanguage = "original_language"
        case releaseYear = "release_year"
        case firstAirDate = "first_air_date"
        case genres, title, type
        case lastAirDate = "last_air_date"
        case images
        case trailerUrls = "trailer_urls"
        case productionCountries = "production_countries"
        case providerOffers = "provider_offers"
        case episodeRuntime = "episode_runtime"
        case castAndCrew = "cast_and_crew"
        case tagline, languages, seasons
    }

    init(tmdbID: Int?, synopsies: String?, createdAt: String?, showID: String?, posterURL: String?, createdBy: [TVCreatedBy]?, tmdbRating: Int?, updatedAt: String?, originalLanguage: String?, releaseYear: Int?, firstAirDate: String?, genres: [TVGenres]?, title: String?, type: String?, lastAirDate: String?, images: [TVImage]?, trailerUrls: [TVTrailerURL]?, productionCountries: [TVProductionCountry]?, providerOffers: TVProviderOffers?, episodeRuntime: [Int]?, castAndCrew: [TVCastAndCrew]?, tagline: String?, languages: [String]?, seasons: [TVSeason]?) {
        self.tmdbID = tmdbID
        self.synopsies = synopsies
        self.createdAt = createdAt
        self.showID = showID
        self.posterURL = posterURL
        self.createdBy = createdBy
        self.tmdbRating = tmdbRating
        self.updatedAt = updatedAt
        self.originalLanguage = originalLanguage
        self.releaseYear = releaseYear
        self.firstAirDate = firstAirDate
        self.genres = genres
        self.title = title
        self.type = type
        self.lastAirDate = lastAirDate
        self.images = images
        self.trailerUrls = trailerUrls
        self.productionCountries = productionCountries
        self.providerOffers = providerOffers
        self.episodeRuntime = episodeRuntime
        self.castAndCrew = castAndCrew
        self.tagline = tagline
        self.languages = languages
        self.seasons = seasons
    }
}

// MARK: - CastAndCrew
class TVCastAndCrew: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment, name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let character, creditID: String?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case character
        case creditID = "credit_id"
        case order
    }

    init(adult: Bool?, gender: Int?, id: Int?, knownForDepartment: String?, name: String?, originalName: String?, popularity: Double?, profilePath: String?, character: String?, creditID: String?, order: Int?) {
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.character = character
        self.creditID = creditID
        self.order = order
    }
}

// MARK: - CreatedBy
class TVCreatedBy: Codable {
    let name, profilePath: String?
    let id, gender: Int?
    let creditID: String?

    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
        case id, gender
        case creditID = "credit_id"
    }

    init(name: String?, profilePath: String?, id: Int?, gender: Int?, creditID: String?) {
        self.name = name
        self.profilePath = profilePath
        self.id = id
        self.gender = gender
        self.creditID = creditID
    }
}

// MARK: - Genre
class TVGenres: Codable {
    let name: String?
    let id: Int?

    init(name: String?, id: Int?) {
        self.name = name
        self.id = id
    }
}

// MARK: - Image
class TVImage: Codable {
    let posters, backdrops: [TVBackdrop]?

    init(posters: [TVBackdrop]?, backdrops: [TVBackdrop]?) {
        self.posters = posters
        self.backdrops = backdrops
    }
}

// MARK: - Backdrop
class TVBackdrop: Codable {
    let filePath: String?
    let width, height, voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
        case width, height
        case voteCount = "vote_count"
    }

    init(filePath: String?, width: Int?, height: Int?, voteCount: Int?) {
        self.filePath = filePath
        self.width = width
        self.height = height
        self.voteCount = voteCount
    }
}

// MARK: - ProductionCountry
class TVProductionCountry: Codable {
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

// MARK: - ProviderOffers
class TVProviderOffers: Codable {
    let providerOffersIN, us: TVIn?

    enum CodingKeys: String, CodingKey {
        case providerOffersIN = "IN"
        case us = "US"
    }

    init(providerOffersIN: TVIn?, us: TVIn?) {
        self.providerOffersIN = providerOffersIN
        self.us = us
    }
}

// MARK: - In
class TVIn: Codable {
    let link: String?
    let flatrate: [TVFlatrate]?

    init(link: String?, flatrate: [TVFlatrate]?) {
        self.link = link
        self.flatrate = flatrate
    }
}

// MARK: - Flatrate
class TVFlatrate: Codable {
    let displayPriority: Int?
    let logoPath: String?
    let providerID: Int?
    let providerName: String?

    enum CodingKeys: String, CodingKey {
        case displayPriority = "display_priority"
        case logoPath = "logo_path"
        case providerID = "provider_id"
        case providerName = "provider_name"
    }

    init(displayPriority: Int?, logoPath: String?, providerID: Int?, providerName: String?) {
        self.displayPriority = displayPriority
        self.logoPath = logoPath
        self.providerID = providerID
        self.providerName = providerName
    }
}

// MARK: - Season
class TVSeason: Codable {
    let name, posterPath: String?
    let seasonNumber, id: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case id
    }

    init(name: String?, posterPath: String?, seasonNumber: Int?, id: Int?) {
        self.name = name
        self.posterPath = posterPath
        self.seasonNumber = seasonNumber
        self.id = id
    }
}

// MARK: - TrailerURL
class TVTrailerURL: Codable {
    let iso639_1, iso3166_1, name, key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt, id: String?

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }

    init(iso639_1: String?, iso3166_1: String?, name: String?, key: String?, site: String?, size: Int?, type: String?, official: Bool?, publishedAt: String?, id: String?) {
        self.iso639_1 = iso639_1
        self.iso3166_1 = iso3166_1
        self.name = name
        self.key = key
        self.site = site
        self.size = size
        self.type = type
        self.official = official
        self.publishedAt = publishedAt
        self.id = id
    }
}

// MARK: - TVshowElement
class TVshowElement: Codable {
    let tmdbID: Int?
    let createdAt, showID, posterURL: String?
    let createdBy: [CreatedBy]?
    let tmdbRating: Int?
    let updatedAt: String?
    let originalLanguage: TVOriginalLanguage?
    let releaseYear: Int?
    let genres: [TVGenre]?
    let title: String?
    let type: TypeEnum?

    enum CodingKeys: String, CodingKey {
        case tmdbID = "tmdb_id"
        case createdAt = "created_at"
        case showID = "show_id"
        case posterURL = "poster_url"
        case createdBy = "created_by"
        case tmdbRating = "tmdb_rating"
        case updatedAt = "updated_at"
        case originalLanguage = "original_language"
        case releaseYear = "release_year"
        case genres, title, type
    }

    init(tmdbID: Int?, createdAt: String?, showID: String?, posterURL: String?, createdBy: [CreatedBy]?, tmdbRating: Int?, updatedAt: String?, originalLanguage: TVOriginalLanguage?, releaseYear: Int?, genres: [TVGenre]?, title: String?, type: TypeEnum?) {
        self.tmdbID = tmdbID
        self.createdAt = createdAt
        self.showID = showID
        self.posterURL = posterURL
        self.createdBy = createdBy
        self.tmdbRating = tmdbRating
        self.updatedAt = updatedAt
        self.originalLanguage = originalLanguage
        self.releaseYear = releaseYear
        self.genres = genres
        self.title = title
        self.type = type
    }
}

// MARK: - CreatedBy
class CreatedBy: Codable {
    let name: String?
    let profilePath: String?
    let id, gender: Int?
    let creditID: String?

    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
        case id, gender
        case creditID = "credit_id"
    }

    init(name: String?, profilePath: String?, id: Int?, gender: Int?, creditID: String?) {
        self.name = name
        self.profilePath = profilePath
        self.id = id
        self.gender = gender
        self.creditID = creditID
    }
}

// MARK: - Genre
class TVGenre: Codable {
    let name: String?
    let id: Int?

    init(name: String?, id: Int?) {
        self.name = name
        self.id = id
    }
}

enum TVOriginalLanguage: String, Codable {
    case de = "de"
    case en = "en"
    case es = "es"
    case hi = "hi"
    case it = "it"
}

enum TypeEnum: String, Codable {
    case tvShows = "TV Shows"
}




// MARK: - MovieDetails
class ActorDetails: Codable {
    let updatedAt, createdAt, bio: String?
    let posterUrls: [String]?
    let placeOfBirth, fullName, birthDay: String?
    let peopleID: Int?
    let knownForDepartment: String?

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case bio
        case posterUrls = "poster_urls"
        case placeOfBirth = "place_of_birth"
        case fullName = "full_name"
        case birthDay = "birth_day"
        case peopleID = "people_id"
        case knownForDepartment = "known_for_department"
    }

    init(updatedAt: String?, createdAt: String?, bio: String?, posterUrls: [String]?, placeOfBirth: String?, fullName: String?, birthDay: String?, peopleID: Int?, knownForDepartment: String?) {
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.bio = bio
        self.posterUrls = posterUrls
        self.placeOfBirth = placeOfBirth
        self.fullName = fullName
        self.birthDay = birthDay
        self.peopleID = peopleID
        self.knownForDepartment = knownForDepartment
    }
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
    let providerOffers: ProviderOffers?
    let tagline: String?
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

    init(movieID: String?, tmdbID: Int?, createdAt: String?, posterURL: String?, tmdbRating: Int?, imdbID: String?, updatedAt: String?, originalLanguage: String?, releaseYear: Int?, genres: [MovieGenre]?, title: String?, type: String?, productionCountries: [ProductionCountry]?, synopsies: String?, runtime: Int?, budget: Int?, castAndCrew: [CastAndCrew]?, releaseDate: String?, revenue: Int?, providerOffers: ProviderOffers?, tagline: String?, images: [MovieImage]?, trailerUrls: [TrailerURL]?) {
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

// MARK: - ProviderOffers
class ProviderOffers: Codable {
    let providerOffersIN: In?
    let us: Us?

    enum CodingKeys: String, CodingKey {
        case providerOffersIN = "IN"
        case us = "US"
    }

    init(providerOffersIN: In?, us: Us?) {
        self.providerOffersIN = providerOffersIN
        self.us = us
    }
}

// MARK: - In
class In: Codable {
    let link: String?
    let flatrate: [Flatrate]?

    init(link: String?, flatrate: [Flatrate]?) {
        self.link = link
        self.flatrate = flatrate
    }
}

// MARK: - Flatrate
class Flatrate: Codable {
    let displayPriority: Int?
    let logoPath: String?
    let providerID: Int?
    let providerName: String?

    enum CodingKeys: String, CodingKey {
        case displayPriority = "display_priority"
        case logoPath = "logo_path"
        case providerID = "provider_id"
        case providerName = "provider_name"
    }

    init(displayPriority: Int?, logoPath: String?, providerID: Int?, providerName: String?) {
        self.displayPriority = displayPriority
        self.logoPath = logoPath
        self.providerID = providerID
        self.providerName = providerName
    }
}

// MARK: - Us
class Us: Codable {
    let link: String?
    let rent, flatrate, buy, ads: [Flatrate]?

    init(link: String?, rent: [Flatrate]?, flatrate: [Flatrate]?, buy: [Flatrate]?, ads: [Flatrate]?) {
        self.link = link
        self.rent = rent
        self.flatrate = flatrate
        self.buy = buy
        self.ads = ads
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
    let showID: String?
    let tmdbID: Int?
    let createdAt, posterURL: String?
    let tmdbRating: Int?
    let imdbID, updatedAt, originalLanguage: String?
    let releaseYear: Int?
    let genres: [Genre]?
    let title, type: String?

    enum CodingKeys: String, CodingKey {
        case movieID = "movie_id"
        case showID = "show_id"
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

    init(movieID: String?, showID: String?, tmdbID: Int?, createdAt: String?, posterURL: String?, tmdbRating: Int?, imdbID: String?, updatedAt: String?, originalLanguage: String?, releaseYear: Int?, genres: [Genre]?, title: String?, type: String?) {
        self.movieID = movieID
        self.showID = showID
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



