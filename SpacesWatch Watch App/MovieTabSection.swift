//
//  MovieTabSection.swift
//  SpacesWatch Watch App
//
//  Created by Mayur P on 17/06/23.
//

import SwiftUI

struct MovieTabSection: View {
    
    @State var selectedPlatform : Platforms
    @State private var selection: Tab = .metrics
    enum Tab {
    case controls, metrics
    }
    
    
    var body: some View {
        TabView(selection: $selection) {
            
            PlatformDetailView(selectedPlatform: selectedPlatform).tag(Tab.metrics)
            
            
            TVDetailView(selectedPlatform: selectedPlatform).tag(Tab.controls)
        }
        
    }
}

struct MovieTabSection_Previews: PreviewProvider {
    static var previews: some View {
        MovieTabSection(selectedPlatform: Platforms(streamingServiceName: "test", iconURL: "test"))
    }
}
