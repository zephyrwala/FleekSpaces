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
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    
}

struct FleekSpacesWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        
        ZStack {
            if widgetFamily == .systemMedium {
                Image("yo")
                    .resizable()
                    .scaledToFill()
                   
            } else if widgetFamily == .systemSmall {
                Image("bop")
                    .resizable()
                    .frame(width: 260)
                
                Text(entry.date, style: .time)
                    .padding(.trailing)
                    .padding(.trailing, 10)
                
            } else if widgetFamily == .systemLarge {
                
                Image("bro")
                    .resizable()
                    .scaledToFill()
                   
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
        .description("Now we can do our own widgets!")
    }
}

struct FleekSpacesWidget_Previews: PreviewProvider {
    static var previews: some View {
        FleekSpacesWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
