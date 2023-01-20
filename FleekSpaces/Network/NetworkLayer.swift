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
            print("Messagers")
            print("\(myData) datadata")
//            print(String(data: myData!, encoding: .utf8))
            let decoder = JSONDecoder()
            //TODO: - safe data for no data fix
            guard let safeData = myData else {return}
            //do-try-catch - decode the data
            
            do {
                
                let decodedData = try decoder.decode(T.self, from: safeData)
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
    
    
    //dujDT
    
    
    func testCalls<T: Codable>(_ type: T.Type, url: URL?, completion: @escaping(Result<T, Error>) -> (Void)) {
        
        
    }
    
    func getCall<T: Codable>(_ type: T.Type, url: URL?, request: String, completion: @escaping(Result<T, Error>) -> (Void)) {
        
        //dujdt
        
        
        //url
        guard let myUrl = url else {return}
        
        
        //request type
        var request = URLRequest(url: myUrl)
        request.httpMethod = "\(request)"
        
        
        //urlsession
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in
            
            guard let safeData = data else {return}
            
            let decoder = JSONDecoder()
            
            
            //do-try-catch
            
            do {
                let decodedData = try decoder.decode(T.self, from: safeData)
                completion(.success(decodedData))
            } catch {
                print(err)
                completion(.failure(APIerror.jsonDecodeError))
            }
            
        }
        dataTask.resume()
        
    }
    
    
    
    
    
    func testing<T: Codable>(_ type: T.Type, url: URL?, completion: @escaping(Result<T, Error>) -> (Void)) {
        
        
        guard let safeURL = url else {return}
        
        
        var request = URLRequest(url: safeURL)
        request.httpMethod = "GET"
        
        
        let dataTask = URLSession.shared.dataTask(with: request) { myData, myResponse, myErr in
            
            
            guard let safeData = myData else {return}
            
            let decoder = JSONDecoder()
            
            
            //do-try-catch
            
            do {
                
                let decodedData = try decoder.decode(T.self, from: safeData)
                completion(.success(decodedData))
                print("Data decoded succesfully")
                
            } catch {
                print(myErr)
                completion(.failure(APIerror.jsonDecodeError))
            }
            
        }
        dataTask.resume()
        
        
    }
    
    
    
    
    func getPostsCall<T: Codable>(_ type: T.Type, url: URL?, completion: @escaping(Result<T, Error>) -> (Void)) {
        
        guard let safeURL = url else {return}
        
        var request = URLRequest(url: safeURL)
        request.httpMethod = "POST"

        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in
            
            guard let safeData = data else {return}
            
            let decoder = JSONDecoder()
            
            //do-try-catch
            
            do {
                
                let decodedData = try decoder.decode(T.self, from: safeData)
                completion(.success(decodedData))
                
            } catch {
                print(err)
                completion(.failure(APIerror.jsonDecodeError))
                
            }
            
        }
        dataTask.resume()
        
        
        
    }
    
    
    
    func registerCalls<T: Codable>(_ type: T.Type, url: URL?, completion: @escaping(Result<T, Error>, _ yourMessage: String) -> (Void)) {
        
        //url
        guard let myURL = url else {return}
        
        var request = URLRequest(url: myURL)
            request.httpMethod = "GET"

     
        //make data task
        let dataTask = URLSession.shared.dataTask(with: request) { myData, myResponse, myError in
            
            //decoder
            print("Register calls")
            guard let safeData = myData else {return}
            
            print(String(data: safeData, encoding: .utf8))
            let decoder = JSONDecoder()
            
            //do-try-catch - decode the data
            
            do {
                
                let decodedData = try decoder.decode(T.self, from: safeData)
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
    
    func loginCalls<T: Codable>(_ type: T.Type, url: URL?, completion: @escaping(Result<T, Error>, _ yourMessage: String) -> (Void)) {
        
        //url
        guard let myURL = url else {return}
        
        var request = URLRequest(url: myURL)
            request.httpMethod = "POST"
        
//        request.addValue(<#T##String#>, forHTTPHeaderField: "Authorization")

     //request.addValue("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNDYwOGZjMDQ3NTU0NDA4ZGI1ZDk4ODQzZWU2MzJjNjIiLCJleHAiOjE2NjcxMDc3NzIsInBob25lX251bWJlciI6Ijk5ODg3NzY2NTMifQ.Ge8jKm6UBCmDUzMbOxgo8ezPr31ngypvkxsJX4lH1pA", forHTTPHeaderField: "Authorization")
        //make data task
        let dataTask = URLSession.shared.dataTask(with: request) { myData, myResponse, myError in
            
            //decoder
            print("Login calls")
            guard let safeData = myData else {return}
            
            print(String(data: safeData, encoding: .utf8))
            let decoder = JSONDecoder()
            
            //do-try-catch - decode the data
            
            do {
                
                let decodedData = try decoder.decode(T.self, from: safeData)
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
    
    
    
    func tokenCalls<T: Codable>(_ type: T.Type, url: URL?, token: String, methodType: String, completion: @escaping(Result<T, Error>, _ yourMessage: String) -> (Void)) {
        
        //url
        guard let myURL = url else {return}
        
        var request = URLRequest(url: myURL)
            request.httpMethod = methodType
        
        request.addValue(token, forHTTPHeaderField: "Authorization")

     //request.addValue("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNDYwOGZjMDQ3NTU0NDA4ZGI1ZDk4ODQzZWU2MzJjNjIiLCJleHAiOjE2NjcxMDc3NzIsInBob25lX251bWJlciI6Ijk5ODg3NzY2NTMifQ.Ge8jKm6UBCmDUzMbOxgo8ezPr31ngypvkxsJX4lH1pA", forHTTPHeaderField: "Authorization")
        //make data task
        let dataTask = URLSession.shared.dataTask(with: request) { myData, myResponse, myError in
         
            
            
            //decoder
            print("token calls")
            guard let safeData = myData else {return}
            
            print("token get")
            print(String(data: safeData, encoding: .utf8))
            let decoder = JSONDecoder()
            
            
            //do-try-catch - decode the data
            
            do {
                
                let decodedData = try decoder.decode(T.self, from: safeData)
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



