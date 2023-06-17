//
//  TVDetailCellView.swift
//  SpacesWatch Watch App
//
//  Created by Mayur P on 17/06/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct TVDetailCellView: View {
    
    @State var ottSelected : TVDetail
    var body: some View {
        
        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(ottSelected.posterURL!)" ?? "https://image.tmdb.org/t/p/w500/qRyy2UmjC5ur9bDi3kpNNRCc5nc.jpg"))
//            .placeholder(Image(systemName: "rays"))
            .placeholder(content: {
                ProgressView()
            })
            .resizable()
            .scaledToFill()
            .cornerRadius(18)
            .padding(12)
            .cornerRadius(20)
            .listRowPlatterColor(.clear)
    }
}

struct TVDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        TVDetailCellView(ottSelected: TVDetail(posterURL: "https://image.tmdb.org/t/p/w500/qAZ0pzat24kLdO3o8ejmbLxyOac.jpg", type: .tvSeries))
    }
}
