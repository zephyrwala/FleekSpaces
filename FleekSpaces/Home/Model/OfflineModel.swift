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
    
        Slide(imageName: "a1", title: "Trending Movies & Trending TV Shows", description: "This is the detailed view of all the things on the top and many other thigns to come. This is the detailed view of all the things on the top and many other thigns to come."),
        Slide(imageName: "a2", title: "Customise Your Feed", description: "This is the detailed view of all the things on the top and many other thigns to come. This is the detailed view of all the things on the top and many other thigns to come."),
        Slide(imageName: "a3", title: "Get The Latest Movie Details", description: "This is the detailed view of all the things on the top and many other thigns to come. This is the detailed view of all the things on the top and many other thigns to come.")
        
    
    
    ]
}
