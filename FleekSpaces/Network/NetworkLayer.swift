//
//  NetworkLayer.swift
//  FleekSpaces
//
//  Created by Mayur P on 01/06/22.
//


//

import Foundation
import UIKit

enum APIerror : Error {
    case badURL
    case jsonDecodeError
}


class NetworkURL {
    
    func theBestNetworkCall<T: Codable>(_ type: T.Type, url: URL?, completion: @escaping(Result<T, Error>, _ yourMessage: String) -> (Void)) {
        
        //url
        guard let myURL = url else {return}
        
        //make data task
        let dataTask = URLSession.shared.dataTask(with: myURL) { myData, myResponse, myError in
            
            //decoder
            print(String(data: myData!, encoding: .utf8))
            let decoder = JSONDecoder()
            
            //do-try-catch - decode the data
            
            do {
                
                let decodedData = try decoder.decode(T.self, from: myData!)
                completion(.success(decodedData), "🎉 Data has been passed Successfully")
                
            } catch {
                
                print("decoding error")
               print(myError)
                completion(.failure(APIerror.jsonDecodeError), "💩 Shit the bed")
                
            }
            
            
            
        }
        
        //task.resume
        dataTask.resume()
        
  
        
    }
    
    
    

    
    
}
