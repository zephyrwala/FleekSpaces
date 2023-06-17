//
//  FleekSpacesWidget.swift
//  FleekSpacesWidget
//
//  Created by Mayur P on 13/07/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        
        SimpleEntry(date: Date(), memeData: Data(), memeData2: Data(), memeData3: Data(), memeData4: Data(), titles: String())
        
    }


    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        Task {
            
            let meme = try await MovieService.shared.getMovie()
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://image.tmdb.org/t/p/w500\(meme[0].posterURL ?? "yog")")!)
            let (data2, _) = try await URLSession.shared.data(from: URL(string: "https://image.tmdb.org/t/p/w500\(meme[1].posterURL ?? "yog")")!)
            let (data3, _) = try await URLSession.shared.data(from: URL(string: "https://image.tmdb.org/t/p/w500\(meme[2].posterURL ?? "yog")")!)
            let (data4, _) = try await URLSession.shared.data(from: URL(string: "https://image.tmdb.org/t/p/w500\(meme[3].posterURL ?? "yog")")!)
            
            let entry = SimpleEntry(date: .now, memeData: data, memeData2: data2, memeData3: data3, memeData4: data4, titles: meme[0].title ?? "loading")
            completion(entry)
            
        }
       
    }


    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
 
        Task {
            do {
                let meme = try await MovieService.shared.getMovie()
                let (data, _) = try await URLSession.shared.data(from: URL(string: "https://image.tmdb.org/t/p/w500\(meme[0].posterURL ?? "yog")")!)
                let (data2, _) = try await URLSession.shared.data(from: URL(string: "https://image.tmdb.org/t/p/w500\(meme[1].posterURL ?? "yog")")!)
                let (data3, _) = try await URLSession.shared.data(from: URL(string: "https://image.tmdb.org/t/p/w500\(meme[2].posterURL ?? "yog")")!)
                let (data4, _) = try await URLSession.shared.data(from: URL(string: "https://image.tmdb.org/t/p/w500\(meme[3].posterURL ?? "yog")")!)
                
                let entry = SimpleEntry(date: .now, memeData: data, memeData2: data2, memeData3: data3, memeData4: data4, titles: meme[0].title ?? "loading")
                
                let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 15 * 60)))
                completion(timeline)
            } catch {
                print(error)
            }
            
        }
        
    }
    
}




struct SimpleEntry: TimelineEntry {
    let date: Date
    let memeData: Data
    let memeData2: Data
    let memeData3: Data
    let memeData4: Data
    let titles: String
}



struct FleekSpacesWidgetEntryView : View {
    @AppStorage("ott") var ottName = ""
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    

    var body: some View {
            
        
        switch family {
            
        
        case .systemSmall :
            ZStack {
                if let image = UIImage(data: entry.memeData) {
                    
                    Image(uiImage: UIImage(data: entry.memeData)!)
                        .resizable()
                    .scaledToFill()
                    .opacity(0.5)
                    
                   
                    

                    LinearGradient(gradient: .init(colors: [.black, .blue]), startPoint: .top, endPoint: .bottom)
                        .opacity(0.8)
                   
                    VStack {
                        
                        
                        Text("🍿 Movie Suggestion")
                            .font(.caption)
                            .padding(.top)
                            .foregroundColor(.white)
                            .opacity(0.8)
                        
                        Image(uiImage: UIImage(data: entry.memeData)!)
                            .resizable()
                            .cornerRadius(6)
                        .scaledToFit()
                        .padding()
                        
                        .frame(width: 100)
                        .shadow(radius: 9)
                      
                        
                        
                    }
                       
                    
                } else {
                    Text("Failed to display a name ...")
                }
               
//                        .padding()
                   
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .systemMedium :
            ZStack {
                
              
                
                if let image = UIImage(data: entry.memeData) {
                    

                    Image(uiImage: UIImage(data: entry.memeData)!)
                        .resizable()
                    .scaledToFill()
                    .opacity(0.9)
                    
                    
                    
                    LinearGradient(gradient: .init(colors: [.black, .indigo]), startPoint: .top, endPoint: .bottom)
                        .opacity(0.9)
//                        .blendMode(.destinationOver)

                  
                    LinearGradient(gradient: .init(colors: [.black, .clear]), startPoint: .top, endPoint: .center)
                        .opacity(0.6)
                    VStack(alignment: .center, spacing: 3) {
                        Text("🔥 Trending on \(ottName)")
                            .font(.caption)
                            .padding(.top, 36)
                            .foregroundColor(.white)
                            .opacity(0.8)
                            
                           
                        HStack(spacing: 10) {
                            Image(uiImage: UIImage(data: entry.memeData)!)
                                .resizable()
                                .cornerRadius(6)
                            .scaledToFit()
                            .padding()
                            
                            .frame(width: 100)
                            .shadow(radius: 9)
                            
                            
                            
                            Image(uiImage: UIImage(data: entry.memeData2)!)
                                .resizable()
                                .cornerRadius(6)
                            .scaledToFit()
                            .padding()
                            .cornerRadius(30)
                            .frame(width: 100)
                            .shadow(radius: 9)

                            Image(uiImage: UIImage(data: entry.memeData3)!)
                                .resizable()
                                .cornerRadius(6)
                            .scaledToFit()
                            .padding()
                            .cornerRadius(30)
                            .frame(width: 100)
                            .shadow(radius: 9)
                            
                        }.padding(.bottom)
                    }
                    
                   
                
//
//                    VStack(alignment: .trailing) {
//                        HStack (){
//
//                            Image("spalogo")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 36, height: 36)
//                                .padding()
//                        }
//
//
//
//                        Text(entry.titles)
//                                .font(.caption)
//                                .padding()
//
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(.white)
//                    }
                } else {
                    Text("Failed to display a name ...")
                }
               
//                        .padding()
                   
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .systemLarge :
            
            ZStack {
                if let image = UIImage(data: entry.memeData) {
                    

                    Image(uiImage: UIImage(data: entry.memeData)!)
                        .resizable()
                    .scaledToFill()
//                    .blur(radius: 21)
                    .opacity(0.9)
                    
                 
                 
                    
                    VStack(alignment: .leading, spacing: 0) {
                     

                       
                        ZStack {
                            
                            
                            
                            LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]), startPoint: .bottom, endPoint: .top)
                               
                                .frame(maxWidth: .infinity, maxHeight: .infinity).opacity(0.90)
//                                .blendMode(.lighten)
                                
                            
                            
                            
                            HStack {
                                Image(uiImage: UIImage(data: entry.memeData)!)
                                    .resizable()
                                    .frame(width: 115, height: 155)
                                    .cornerRadius(9)
                                    .scaledToFit()
                                    .shadow(radius: 12)
                                .padding(.top, 90)
                                .padding(.leading, 36)
                                
                                
                                Spacer()
                                VStack(spacing: 10) {
                                    Text("🤔")
                                        .font(.caption)
                                       
                                    Text("What to watch?")
                                        .font(.caption)
                                        .foregroundColor(.yellow)
                                    Text(entry.titles)
                                        .font(.title2)
                                        .padding(.leading)
                                        .padding(.trailing)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                }.opacity(0.6)
                                    .frame(width: 200)
                                    .padding(.top,100)
                                
                            }
                        }
                           
                        
//                        LinearGradient(gradient: .init(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top)
//
//                            .frame(maxWidth: .infinity, maxHeight: 300).opacity(0.91)
                      
//                        Spacer()
                        
                        ZStack {
//                            Color(.black)
//                                .frame(maxWidth: .infinity, maxHeight: 290).opacity(0.9)
                            
                           
                            
                            LinearGradient(gradient: .init(colors: [.black, .black]), startPoint: .top, endPoint: .bottom)
                               
                                .frame(maxWidth: .infinity, maxHeight: 260).opacity(0.9)
                                .background(.ultraThinMaterial)

                                
                            
                            
                            VStack(spacing: 0) {
                                Text("🔥 Trending on \(ottName)")
                                    .font(.caption)
//                                    .padding(.top, 36)
                                    .foregroundColor(.white)
                                    .opacity(0.8)
                                
                                HStack(spacing: 10) {
                                    Image(uiImage: UIImage(data: entry.memeData2)!)
                                        .resizable()
                                        .cornerRadius(6)
                                    .scaledToFit()
                                    .padding()
                                    
                                    .frame(width: 105)
                                    
                                    
                                    
                                    Image(uiImage: UIImage(data: entry.memeData3)!)
                                        .resizable()
                                        .cornerRadius(6)
                                    .scaledToFit()
                                    .padding()
                                    .cornerRadius(30)
                                    .frame(width: 105)

                                    Image(uiImage: UIImage(data: entry.memeData4)!)
                                        .resizable()
                                        .cornerRadius(6)
                                    .scaledToFit()
                                    .padding()
                                    .cornerRadius(30)
                                    .frame(width: 105)
                                    
                                }.padding(.bottom, 60)
                            }
                        }
                     
                    }
                
                } else {
                    Text("Failed to display a name ...")
                }
               
//                        .padding()
                   
                
            }
            
        default:
            ZStack {
                if let image = UIImage(data: entry.memeData) {
                    
                    Image(uiImage: UIImage(data: entry.memeData)!)
                        .resizable()
                    .scaledToFill()
                    
                   

                   
                        Text(entry.titles)
                        .font(.system(size: 9))
                            .padding()
                            .scaledToFit()
                            .multilineTextAlignment(.leading)
                } else {
                    Text("Failed to display a name ...")
                }
               
//                        .padding()
                   
                
            }
        }
          
            
           
            
        }
        
    }


@main
struct FleekSpacesWidget: Widget {
    let kind: String = "FleekSpacesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FleekSpacesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Fleek Spaces Widgets")
        .description("Keep a track of all the trending movies")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct FleekSpacesWidget_Previews: PreviewProvider {
    static var previews: some View {
        FleekSpacesWidgetEntryView(entry: SimpleEntry(date: Date(), memeData: Data(), memeData2: Data(), memeData3: Data(), memeData4: Data(), titles: String()))
                    .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
