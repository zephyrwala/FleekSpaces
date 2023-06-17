//
//  TVDetailView.swift
//  SpacesWatch Watch App
//
//  Created by Mayur P on 17/06/23.
//

import SwiftUI

struct TVDetailView: View {
    @State var selectedPlatform : Platforms
    @State var ott: [TVDetail]? = nil
    var body: some View {
        
      
           
               
        
        NavigationView {
            List {
                ForEach(ott ?? [TVDetail(posterURL: "as", type: .tvSeries)]) { ottchosen in
                    
                   TVDetailCellView(ottSelected: ottchosen)
                    
                }
            }
            
            .listStyle(CarouselListStyle())
            
            .task {
                do {
                    ott = try await OTTService.shared.getTVshows(ottNames: selectedPlatform.streamingServiceName!)
                } catch {
                    print(error)
                }
        }
            .navigationTitle("Tv Shows")
            .navigationBarTitleDisplayMode(.inline)
        }
           
    }
}

struct TVDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TVDetailView(selectedPlatform: Platforms(streamingServiceName: "test", iconURL: "test"))
    }
}
