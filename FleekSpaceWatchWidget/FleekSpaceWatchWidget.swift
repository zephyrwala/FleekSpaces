//
//  FleekSpaceWatchWidget.swift
//  FleekSpaceWatchWidget
//
//  Created by Mayur P on 17/06/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), titles: String())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task{
            let meme = try await MovieWatchService.shared.getMovie()
            let entry = SimpleEntry(date: Date(), titles: meme[0].title ?? "loading")
            completion(entry)
        }
        
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        Task {
            do {
                let meme = try await MovieWatchService.shared.getMovie()
                let entry = SimpleEntry(date: .now, titles: meme[0].title ?? "loading")
                
                let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 15 * 60)))
                completion(timeline)
                
            }catch {
                print(error)
            }
        }
      
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let titles: String
}

struct FleekSpaceWatchWidgetEntryView : View {
    @AppStorage("ott") var ottName = ""
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        
        switch family {
            
        case .accessoryRectangular:
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("🤔 What to watch?")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12, weight: .bold))
                    
                    Text("\(entry.titles)")
                        .font(.system(size: 15, weight: .bold))
                        .multilineTextAlignment(.leading)
                    
                    
                    
                    Text("📺 \(ottName)")
                      .font(.caption)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
        default :
            Text(entry.titles)
                .font(.title)
            
        }
    }
    
    @main
    struct FleekSpaceWatchWidget: Widget {
        let kind: String = "FleekSpaceWatchWidget"
        
        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                FleekSpaceWatchWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("Fleek Spaces")
            .description("Keep a track of all the trending movies")
            .supportedFamilies([.accessoryRectangular])
        }
    }
    
    struct FleekSpaceWatchWidget_Previews: PreviewProvider {
        static var previews: some View {
            FleekSpaceWatchWidgetEntryView(entry: SimpleEntry(date: Date(), titles: String()))
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        }
    }
}
