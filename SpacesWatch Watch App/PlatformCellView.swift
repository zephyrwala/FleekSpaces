//
//  PlatformCellView.swift
//  off Charto Watch App
//
//  Created by Mayur P on 14/06/23.
//

import SwiftUI
import SDWebImageSwiftUI






struct PlatformCellView: View {
    @State var platform : Platforms
    
  
    var body: some View {
        HStack {
            

            
            ZStack {
                WebImage(url: URL(string: platform.iconURL ?? "yog"))
                    .resizable()
                    .scaledToFill()
    //                .cornerRadius(10)
                    .clipShape(Circle())
                
                    .frame(width: 60, height: 60)
                .padding()
                Circle()
                            .strokeBorder(Color.gray, lineWidth: 3)
                            .frame(width: 60, height: 60)
            }

            Text(platform.streamingServiceName ?? "loading")
               
        }
        .frame(height: 90)
        
    }
}

struct PlatformCellView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformCellView(platform: Platforms(streamingServiceName: "Babul", iconURL: "https://fleek-space-icons.s3.ap-south-1.amazonaws.com/ott/Netflix_icon.jpg") )
    }
}
