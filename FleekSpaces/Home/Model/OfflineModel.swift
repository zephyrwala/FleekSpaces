//
//  OfflineModel.swift
//  FleekSpaces
//
//  Created by Mayur P on 02/06/22.
//

import Foundation
import UIKit

struct Logos {
    let posterImage : UIImage
    let bookName: String
    let author: String
}

struct TextLogos {
    let posterImage : UIImage
    let postername: String
}


struct SeasonNumbers {
    
    let seasons: String
    
    static let slideCollection: [SeasonNumbers] = [
        
        SeasonNumbers(seasons: "Season 1"),
        SeasonNumbers(seasons: "Season 2"),
        SeasonNumbers(seasons: "Season 3"),
        SeasonNumbers(seasons: "Season 4"),
        SeasonNumbers(seasons: "Season 5"),
        SeasonNumbers(seasons: "Season 6"),
        
        ]
    
}

struct MovieGenres {
    
    let genreName: String
    
}


struct Slide {
    
    let imageName: String
    let title: String
    let description: String
    
    static let slideCollection: [Slide] = [
    
        Slide(imageName: "a1", title: "Trending Movies & TV Shows", description: "Discover the latest and greatest of Movies and TV shows on the streaming platforms."),
        Slide(imageName: "a2", title: "Find New Content", description: "Find out new and interesting content on all the OTT platforms."),
        Slide(imageName: "a3", title: "Stay in touch", description: "Stay in touch with all the happening content on your favourite streaming platform.")
        
    
    
    ]
}
