//
//  MemeView.swift
//  FleekSpaces
//
//  Created by Mayur P on 04/06/23.
//

import SwiftUI

struct MemeView: View {
    @State var meme: Meme? = nil
    
    var body: some View {
        VStack {
            Text(meme?.title ?? "want a meme?")
                .font(.subheadline)
                .padding()
            
            //meme image
            AsyncImage(url: meme?.url) { image in
                
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                
            } placeholder: {
                VStack {
                    
                    ProgressView()
                    Text("Cooking up a new meme")
                    
                }
            }

          
            .padding(.bottom)
            
            Button("Gimme another meme!") {
                
                Task {
                    
                    do {
                      meme = try await MemeService.shared.getMeme()
                    } catch {
                        print(error)
                    }
                    
                }
                
            }
        }.task {
            do {
              meme = try await MemeService.shared.getMeme()
            } catch {
                print(error)
            }
        }
    }
}

struct MemeView_Previews: PreviewProvider {
    static var previews: some View {
        MemeView()
    }
}
