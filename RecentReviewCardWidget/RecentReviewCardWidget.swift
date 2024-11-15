//
//  RecentReviewCardWidget.swift
//  RecentReviewCardWidget
//
//  Created by 김윤우 on 11/15/24.
//

import WidgetKit
import SwiftUI
import Cosmos

struct Provider: TimelineProvider {
    
    // 위젯 최초 렌더링
    func placeholder(in context: Context) -> SimpleEntry {
        createEntry()
    }
    
    // 위젯 갤러리 미리보기 화면
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = createEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        // 5시간 동안 1시간 간격으로 타임라인 생성
        for hourOffset in 0 ..< 5 {
            let _ = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = createEntry()
            entries.append(entry)
        }
        
        // 마지막 엔트리 시각 이후 자동 갱신하지 않는 설정
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func createEntry() -> SimpleEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.reviewCardWidget.FoodieLog")
        
        let rating = sharedDefaults?.double(forKey: "reviewRating") ?? 0.0
        let restaurantName = sharedDefaults?.string(forKey: "restaurantName") ?? ""
        let imagePath = sharedDefaults?.string(forKey: "reviewImage") ?? ""
        
        let reviewImage = loadImage(from: imagePath)
        let data = WidgetData(rating: rating, restaurantsName: restaurantName)
        
        return SimpleEntry(date: Date(), reviewImage: reviewImage, data: data)
    }
    
    private func loadImage(from path: String) -> Image? {
        let fileURL = URL(fileURLWithPath: path)
        if let imageData = try? Data(contentsOf: fileURL), let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}

struct WidgetData {
    let rating: Double
    let restaurantsName: String
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let reviewImage: Image?
    let data: WidgetData
}

struct RecentReviewCardWidgetEntryView: View {
    var entry: Provider.Entry
    var body: some View {
        ZStack {
            if let reviewImage = entry.reviewImage {
                reviewImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 169, height: 169)
                    .clipped()
            } else {
                Color.gray
            }
            
            VStack {
                Spacer()
                ratingView(data: entry.data)
            }
        }
        .frame(width: 169, height: 169)
        .cornerRadius(20)
    }
}

func ratingView(data: WidgetData) -> some View {
    VStack(alignment: .center, spacing: 4) {
        Text(data.restaurantsName)
            .lineLimit(1)
            .font(.caption)
            .foregroundColor(.black)
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                if Double(index) < data.rating {
                    if data.rating - Double(index) < 1 && data.rating - Double(index) > 0 {
                        Image(systemName: "star.leadinghalf.filled")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.orange)
                    } else {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.orange)
                    }
                } else {
                    Image(systemName: "star")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.orange)
                }
            }
        }
        .frame(width: 100)
    }
    .padding(10)
    .background(Color.white.opacity(0.9))
    .cornerRadius(10)
    .padding([.leading, .bottom, .trailing], 8)
}

struct RecentReviewCardWidget: Widget {
    let kind: String = "RecentReviewCardWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                RecentReviewCardWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                RecentReviewCardWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Recent Review Widget")
        .description("Displays the most recent restaurant review.")
    }
}
