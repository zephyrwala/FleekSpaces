//
//  ContentView.swift
//  Spaces Charto Watch App
//
//  Created by Mayur P on 13/06/23.
//

import SwiftUI

struct Ocean: Identifiable {
    let name: String
    let image: UIImage
    let id = UUID()
}



struct ContentView: View {
    
 
    
    @State var plats: [Platforms]? = nil
    
    var body: some View {
        
        NavigationView{
        List {
            ForEach(plats ?? [Platforms(streamingServiceName: "test", iconURL: "https://docs-assets.developer.apple.com/published/a151730046f7ac186031a760fe890b92/overview-hero@2x.png")]) { workout in
                
//                Button {
//                    print(workout.streamingServiceName)
//
//                } label: {
//                    PlatformCellView(platform: workout)
//                }

                
                NavigationLink(destination: MovieTabSection(selectedPlatform: workout)) {
                    
                    PlatformCellView(platform: workout)
                }
               
               
            }
           
        }
//        .navigationTitle("Select One:")
        }
        .listStyle(.carousel)
       
       
        .task {
            
            do {
              plats = try await PlatformService.shared.getMovie()
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
