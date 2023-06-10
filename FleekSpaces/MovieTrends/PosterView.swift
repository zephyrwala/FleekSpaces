//
//  PosterView.swift
//  FleekSpaces
//
//  Created by Mayur P on 06/06/23.
//

import SwiftUI

struct PosterView: View {
    @State var movie: [MovieWidgetModel]? = nil
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
           
            //meme image
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie?[0].posterURL ?? "yog")"))  { image in
                
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                
            } placeholder: {
                VStack {
                    
                    ProgressView()
                    Text("Cooking up a new movie")
                    
                }
            }
            
            .padding(.bottom)
            
            Button("Gimme another meme! \(movie?[0].posterURL ?? "yo")") {
                
                Task {
                    
                    do {
                      movie = try await MovieService.shared.getMovie()
                    } catch {
                        print(error)
                    }
                    
                }
                
            }
        }.task {
            do {
              movie = try await MovieService.shared.getMovie()
            } catch {
                print(error)
            }
        }
        }
        
        
        
    }


struct PosterView_Previews: PreviewProvider {
    static var previews: some View {
        PosterView()
    }
}
