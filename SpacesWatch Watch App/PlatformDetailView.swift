//
//  PlatformDetailView.swift
//  off Charto Watch App
//
//  Created by Mayur P on 14/06/23.
//

import SwiftUI

struct PlatformDetailView: View {
    @State var selectedPlatform : Platforms
    @State var ott: [OTTDetail]? = nil
    var body: some View {
        
      
           
               
        
        NavigationView {
            List {
                ForEach(ott ?? [OTTDetail(posterURL: "as", type: .movie)]) { ottchosen in
                    
                   PlatformDetailCellView(ottSelected: ottchosen)
                    
                }
            }
            
            .listStyle(CarouselListStyle())
            
            .task {
                do {
                    ott = try await OTTService.shared.getMovie(ottNames: selectedPlatform.streamingServiceName!)
                } catch {
                    print(error)
                }
        }
            .navigationTitle("Movies")
            .navigationBarTitleDisplayMode(.inline)
        }
           
    }
}

struct PlatformDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformDetailView(selectedPlatform: Platforms(streamingServiceName: "test", iconURL: "test"))
    }
}
