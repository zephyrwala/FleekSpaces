//
//  SpacesWatchModel.swift
//  SpacesWatch Watch App
//
//  Created by Mayur P on 16/06/23.
//

import Foundation

// MARK: - Platform
struct Platforms: Decodable, Identifiable {
    let id = UUID()
    
    let streamingServiceName: String?
   
    let iconURL: String?
   

    enum CodingKeys: String, CodingKey {
        
        case streamingServiceName = "streaming_service_name"
       
        case iconURL = "icon_url"
       
    }
}




// MARK: - OTTDetail
struct OTTDetail: Decodable, Identifiable {
    let id = UUID()
   
    let posterURL: String?
    
    let type: TypeEnum?

    enum CodingKeys: String, CodingKey {
      
        case posterURL = "poster_url"
       
        case type
    }
}



enum TypeEnum: String, Codable {
    case movie = "Movie"
    case tvSeries = "tv_series"
}



// MARK: - TVDetail
struct TVDetail: Decodable, Identifiable {
  
    let id = UUID()
    let posterURL: String?
   
 
    let type: TypeEnum?

    enum CodingKeys: String, CodingKey {
       
        case posterURL = "poster_url"
     
        case type
    }
}




