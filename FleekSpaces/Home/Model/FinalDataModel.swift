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










// MARK: - TVshowDetail
class TVshowDetail: Codable {
    let tmdbID: Int?
    let createdAt, showID, posterURL: String?
    let createdBy: [TVCreatedBy]?
    let tmdbRating: Int?
    let updatedAt, originalLanguage: String?
    let releaseYear: Int?
    let genres: [TVDetailGenre]?
    let title, type: String?
    let productionCountries: [TVProductionCountry]?
    let synopsies: String?
    let episodeRuntime: [Int]?
    let lastAirDate: String?
    let castAndCrew: [TVCastAndCrew]?
    let languages: [String]?
    let providerOffers: TVProviderOffers?
    let tagline: String?
    let images: [TVImage]?
    let seasons: [TVSeason]?
    let trailerUrls: [TVTrailerURL]?
    let firstAirDate: String?

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
        case productionCountries = "production_countries"
        case synopsies
        case episodeRuntime = "episode_runtime"
        case lastAirDate = "last_air_date"
        case castAndCrew = "cast_and_crew"
        case languages
        case providerOffers = "provider_offers"
        case tagline, images, seasons
        case trailerUrls = "trailer_urls"
        case firstAirDate = "first_air_date"
    }

    init(tmdbID: Int?, createdAt: String?, showID: String?, posterURL: String?, createdBy: [TVCreatedBy]?, tmdbRating: Int?, updatedAt: String?, originalLanguage: String?, releaseYear: Int?, genres: [TVDetailGenre]?, title: String?, type: String?, productionCountries: [TVProductionCountry]?, synopsies: String?, episodeRuntime: [Int]?, lastAirDate: String?, castAndCrew: [TVCastAndCrew]?, languages: [String]?, providerOffers: TVProviderOffers?, tagline: String?, images: [TVImage]?, seasons: [TVSeason]?, trailerUrls: [TVTrailerURL]?, firstAirDate: String?) {
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
        self.productionCountries = productionCountries
        self.synopsies = synopsies
        self.episodeRuntime = episodeRuntime
        self.lastAirDate = lastAirDate
        self.castAndCrew = castAndCrew
        self.languages = languages
        self.providerOffers = providerOffers
        self.tagline = tagline
        self.images = images
        self.seasons = seasons
        self.trailerUrls = trailerUrls
        self.firstAirDate = firstAirDate
    }
}

// MARK: - CastAndCrew
class TVCastAndCrew: Codable {
    let character: String?
    let gender: Int?
    let creditID: String?
    let knownForDepartment: String?
    let originalName: String?
    let popularity: Int?
    let name, profilePath: String?
    let id: Int?
    let adult: Bool?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case character, gender
        case creditID = "credit_id"
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case popularity, name
        case profilePath = "profile_path"
        case id, adult, order
    }

    init(character: String?, gender: Int?, creditID: String?, knownForDepartment: String?, originalName: String?, popularity: Int?, name: String?, profilePath: String?, id: Int?, adult: Bool?, order: Int?) {
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
class TVDetailGenre: Codable {
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
    let providerOffersIN: TVIn?
    let us: TVUs?

    enum CodingKeys: String, CodingKey {
        case providerOffersIN = "IN"
        case us = "US"
    }

    init(providerOffersIN: TVIn?, us: TVUs?) {
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

// MARK: - Us
class TVUs: Codable {
    let link: String?
    let flatrate, buy: [Flatrate]?

    init(link: String?, flatrate: [Flatrate]?, buy: [Flatrate]?) {
        self.link = link
        self.flatrate = flatrate
        self.buy = buy
    }
}

// MARK: - Season
class TVSeason: Codable {
    let name: String?
    let seasonNumber, id: Int?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case name
        case seasonNumber = "season_number"
        case id
        case posterPath = "poster_path"
    }

    init(name: String?, seasonNumber: Int?, id: Int?, posterPath: String?) {
        self.name = name
        self.seasonNumber = seasonNumber
        self.id = id
        self.posterPath = posterPath
    }
}

// MARK: - TrailerURL
class TVTrailerURL: Codable {
    let site: String?
    let size: Int?
    let iso3166_1, name: String?
    let official: Bool?
    let id, type, publishedAt, iso639_1: String?
    let key: String?

    enum CodingKeys: String, CodingKey {
        case site, size
        case iso3166_1 = "iso_3166_1"
        case name, official, id, type
        case publishedAt = "published_at"
        case iso639_1 = "iso_639_1"
        case key
    }

    init(site: String?, size: Int?, iso3166_1: String?, name: String?, official: Bool?, id: String?, type: String?, publishedAt: String?, iso639_1: String?, key: String?) {
        self.site = site
        self.size = size
        self.iso3166_1 = iso3166_1
        self.name = name
        self.official = official
        self.id = id
        self.type = type
        self.publishedAt = publishedAt
        self.iso639_1 = iso639_1
        self.key = key
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



