//
//  RecentReviewCardWidgetLiveActivity.swift
//  RecentReviewCardWidget
//
//  Created by 김윤우 on 11/15/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct RecentReviewCardWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct RecentReviewCardWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RecentReviewCardWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension RecentReviewCardWidgetAttributes {
    fileprivate static var preview: RecentReviewCardWidgetAttributes {
        RecentReviewCardWidgetAttributes(name: "World")
    }
}

extension RecentReviewCardWidgetAttributes.ContentState {
    fileprivate static var smiley: RecentReviewCardWidgetAttributes.ContentState {
        RecentReviewCardWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: RecentReviewCardWidgetAttributes.ContentState {
         RecentReviewCardWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: RecentReviewCardWidgetAttributes.preview) {
   RecentReviewCardWidgetLiveActivity()
} contentStates: {
    RecentReviewCardWidgetAttributes.ContentState.smiley
    RecentReviewCardWidgetAttributes.ContentState.starEyes
}
