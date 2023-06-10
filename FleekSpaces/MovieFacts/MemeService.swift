//
//  MemeService.swift
//  FleekSpaces
//
//  Created by Mayur P on 04/06/23.
//

import Foundation


final class MemeService {
    
    
    static let shared = MemeService()
    let url = URL(string: "https://meme-api.com/gimme/moviedetails")!
    
    
    private init() {
        
    }
    
    public func getMeme() async throws -> Meme {
        
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let meme = try JSONDecoder().decode(Meme.self, from: data)
        
        return meme
        
        
    }
    
    
}
