//
//  CreatePostView.swift
//  Pegasus
//
//  Created by Isidoro Flores on 3/20/26.
//

import SwiftUI

 struct CreatePostView: View {
    @State private var postType: PostType = .feed

    enum PostType: String, CaseIterable, Hashable {
        case feed = "Feed"
        case story = "Story"
        case song = "Song"
    }
                                                                                                                                                                                                                
    var body: some View {
        ZStack {
            switch postType {
            case .feed: FeedPostEditor().transition(.opacity)
            case .story: StoryPostEditor().transition(.opacity)
            case .song: SongPostEditor().transition(.opacity)
            }
        }
        .animation(.smooth(duration: 0.35, extraBounce: 0), value: postType)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            ZStack(alignment: .trailing) {
                GlassEffectContainer(spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        GeometryReader { geo in
                            CustomTabBar(size: geo.size, activeTab: $postType) { type in
                                Text(type.rawValue)
                                    .font(.system(size: 14, weight: .medium))
                                    .frame(maxWidth: .infinity)
                            }
                            .glassEffect(.regular, in: .capsule)
                            .frame(width: geo.size.width, height: geo.size.height)
                        }
                        Color.clear.frame(width: 55, height: 55)
                    }
                }
                .frame(height: 55)

                Button {
                    // confirm post action
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 22, weight: .medium))
                        .frame(width: 55, height: 55)
                        .contentShape(Rectangle())
                }
                .glassEffect(.regular.interactive(), in: .capsule)
                .animation(.smooth(duration: 0.55, extraBounce: 0), value: postType)
                .buttonStyle(.plain)
                .tint(.primary)
            }
            .padding(.horizontal, 20)
        }
    }
}

 
#Preview {
    CreatePostView()
}
