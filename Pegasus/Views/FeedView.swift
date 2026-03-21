//
//  FeedView.swift
//  Pegasus
//
//  Created by Isidoro Flores on 3/11/26.
//

import SwiftUI

// MARK: - Mock Data

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let handle: String
    let timeAgo: String
    let content: String
    let likes: Int
    let replies: Int
    let reposts: Int
    let avatarColor: Color
    // nil means text-only post, non-nil shows a photo placeholder
    let imageColors: [Color]?
}

let mockPosts: [Post] = [
    Post(username: "Jess Monroe", handle: "jessmonroe", timeAgo: "2m", content: "Just shipped the new update. Took three months but it's finally out. Clean, fast, no bloat.", likes: 214, replies: 18, reposts: 42, avatarColor: .indigo, imageColors: [.indigo, .purple]),
    Post(username: "Kai Nakamura", handle: "kainaka", timeAgo: "11m", content: "The best interfaces are the ones you stop noticing. You just use them.", likes: 891, replies: 64, reposts: 203, avatarColor: .orange, imageColors: nil),
    Post(username: "Mara Solis", handle: "marasolis", timeAgo: "34m", content: "Hot take: most apps have 3x too many features and 1/3 the polish they should.", likes: 477, replies: 91, reposts: 118, avatarColor: .pink, imageColors: [.pink, .orange]),
    Post(username: "Dev Patel", handle: "devpatel", timeAgo: "1h", content: "Spent the whole morning on a 12pt spacing fix. Totally worth it.", likes: 133, replies: 7, reposts: 29, avatarColor: .teal, imageColors: nil),
    Post(username: "Lena Fischer", handle: "lenafischer", timeAgo: "2h", content: "Reading old WWDC sessions is still the best way to learn SwiftUI properly. The fundamentals haven't changed.", likes: 562, replies: 43, reposts: 97, avatarColor: .purple, imageColors: [.purple, .blue]),
    Post(username: "Omar Hassan", handle: "omarhassan", timeAgo: "3h", content: "Deleted 400 lines of code today. The feature works better now.", likes: 1204, replies: 88, reposts: 341, avatarColor: .green, imageColors: nil),
]

// MARK: - Activity Card Models

enum ActivityCard: Identifiable {
    case running(user: String, avatarColor: Color, distance: String, pace: String, duration: String, heartRate: Int, ringProgress: Double)
    case listening(user: String, avatarColor: Color, song: String, artist: String, album: String, albumColor: Color)
    case onMac(user: String, avatarColor: Color, app: String, timeAgo: String)
    case watching(user: String, avatarColor: Color, title: String, episode: String, artColor: Color)

    var id: String {
        switch self {
        case .running(let u, _, _, _, _, _, _): return "run-\(u)"
        case .listening(let u, _, _, _, _, _): return "listen-\(u)"
        case .onMac(let u, _, _, _): return "mac-\(u)"
        case .watching(let u, _, _, _, _): return "watch-\(u)"
        }
    }
}

let mockActivityCards: [ActivityCard] = [
    .running(user: "Kai Nakamura", avatarColor: .orange, distance: "4.2 mi", pace: "7'42\"", duration: "32:24", heartRate: 158, ringProgress: 0.78),
    .listening(user: "Mara Solis", avatarColor: .pink, song: "Nights", artist: "Frank Ocean", album: "Blonde", albumColor: Color(red: 0.85, green: 0.75, blue: 0.6)),
    .onMac(user: "Dev Patel", avatarColor: .teal, app: "Xcode", timeAgo: "3m ago"),
    .watching(user: "Lena Fischer", avatarColor: .purple, title: "Severance", episode: "S2 · E6", artColor: Color(red: 0.15, green: 0.15, blue: 0.35)),
]

// MARK: - FeedView

struct FeedView: View {
    @State private var selectedFeed = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Feed picker
                Picker("Feed", selection: $selectedFeed) {
                    Text("Public").tag(0)
                    Text("Close Friends").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

                Divider()

                ScrollView {
                    if selectedFeed == 0 {
                        // Public feed
                        LazyVStack(spacing: 0) {
                            ForEach(mockPosts) { post in
                                PostRow(post: post)
                                Divider()
                                    .padding(.leading, 72)
                            }
                        }
                        .padding(.top, 8)
                    } else {
                        // Close friends activity feed
                        LazyVStack(spacing: 12) {
                            ForEach(mockActivityCards) { card in
                                ActivityCardView(card: card)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Home")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Pegasus")
                        .font(.system(size: 17, weight: .semibold))
                }
                #if os(iOS)
                ToolbarItem(placement: .topBarLeading) {
                    Circle()
                        .fill(Color.indigo)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text("J")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white)
                        )
                }
                #endif
            }
        }
    }
}

// MARK: - Activity Card View

struct ActivityCardView: View {
    let card: ActivityCard

    var body: some View {
        switch card {
        case .running(let user, let avatarColor, let distance, let pace, let duration, let heartRate, let ringProgress):
            RunningCard(user: user, avatarColor: avatarColor, distance: distance, pace: pace, duration: duration, heartRate: heartRate, ringProgress: ringProgress)
        case .listening(let user, let avatarColor, let song, let artist, let album, let albumColor):
            ListeningCard(user: user, avatarColor: avatarColor, song: song, artist: artist, album: album, albumColor: albumColor)
        case .onMac(let user, let avatarColor, let app, let timeAgo):
            OnMacCard(user: user, avatarColor: avatarColor, app: app, timeAgo: timeAgo)
        case .watching(let user, let avatarColor, let title, let episode, let artColor):
            WatchingCard(user: user, avatarColor: avatarColor, title: title, episode: episode, artColor: artColor)
        }
    }
}

// MARK: - Card Header

struct CardHeader: View {
    let user: String
    let avatarColor: Color
    let label: String
    let icon: String
    let iconColor: Color

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(avatarColor.gradient)
                .frame(width: 36, height: 36)
                .overlay(
                    Text(String(user.prefix(1)))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                )
            VStack(alignment: .leading, spacing: 1) {
                Text(user)
                    .font(.system(size: 14, weight: .semibold))
                HStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(iconColor)
                    Text(label)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
    }
}

// MARK: - Running Card

struct RunningCard: View {
    let user: String
    let avatarColor: Color
    let distance: String
    let pace: String
    let duration: String
    let heartRate: Int
    let ringProgress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardHeader(user: user, avatarColor: avatarColor, label: "Outdoor Run · Live", icon: "figure.run", iconColor: .green)

            HStack(spacing: 16) {
                // Activity ring
                ZStack {
                    Circle()
                        .stroke(Color.green.opacity(0.2), lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: ringProgress)
                        .stroke(Color.green, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Image(systemName: "figure.run")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.green)
                }
                .frame(width: 56, height: 56)

                // Stats
                VStack(spacing: 8) {
                    HStack(spacing: 20) {
                        StatBlock(value: distance, label: "Distance")
                        StatBlock(value: pace, label: "Avg Pace")
                        StatBlock(value: duration, label: "Time")
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(.red)
                        Text("\(heartRate) BPM")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct StatBlock: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.system(size: 15, weight: .semibold))
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Listening Card

struct ListeningCard: View {
    let user: String
    let avatarColor: Color
    let song: String
    let artist: String
    let album: String
    let albumColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardHeader(user: user, avatarColor: avatarColor, label: "Listening on Apple Music", icon: "music.note", iconColor: .pink)

            HStack(spacing: 12) {
                // Album art placeholder
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(albumColor.gradient)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 20, weight: .light))
                            .foregroundStyle(.white.opacity(0.7))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(song)
                        .font(.system(size: 15, weight: .semibold))
                    Text(artist)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    Text(album)
                        .font(.system(size: 12))
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                // Animated bars indicator
                HStack(alignment: .bottom, spacing: 3) {
                    ForEach([0.6, 1.0, 0.4, 0.8], id: \.self) { h in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.pink)
                            .frame(width: 3, height: 16 * h)
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - On Mac Card

struct OnMacCard: View {
    let user: String
    let avatarColor: Color
    let app: String
    let timeAgo: String

    var body: some View {
        HStack(spacing: 12) {
            CardHeader(user: user, avatarColor: avatarColor, label: "Active on Mac · \(timeAgo)", icon: "laptopcomputer", iconColor: .blue)

            Spacer()

            Text(app)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(.tertiarySystemBackground))
                .clipShape(Capsule())
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Watching Card

struct WatchingCard: View {
    let user: String
    let avatarColor: Color
    let title: String
    let episode: String
    let artColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardHeader(user: user, avatarColor: avatarColor, label: "Watching on Apple TV", icon: "appletv.fill", iconColor: .primary)

            HStack(spacing: 12) {
                // Show art placeholder
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(artColor.gradient)
                    .frame(width: 80, height: 56)
                    .overlay(
                        Image(systemName: "play.rectangle.fill")
                            .font(.system(size: 20, weight: .light))
                            .foregroundStyle(.white.opacity(0.6))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                    Text(episode)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - PostRow

struct PostRow: View {
    let post: Post
    @State private var liked = false
    @State private var reposted = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            // Avatar
            Circle()
                .fill(post.avatarColor.gradient)
                .frame(width: 44, height: 44)
                .overlay(
                    Text(String(post.username.prefix(1)))
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                )

            VStack(alignment: .leading, spacing: 4) {

                // Name + handle + time
                HStack(spacing: 4) {
                    Text(post.username)
                        .font(.system(size: 15, weight: .semibold))
                    Text("·")
                        .foregroundStyle(.tertiary)
                    Text(post.timeAgo)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button {
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                }

                // Post content
                Text(post.content)
                    .font(.system(size: 15))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                // Photo (if post has one)
                if let colors = post.imageColors {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 32, weight: .light))
                                .foregroundStyle(.white.opacity(0.6))
                        )
                        .padding(.top, 4)
                }

                // Action bar
                HStack(spacing: 32) {
                    ActionButton(icon: "bubble.left", count: post.replies, active: false, activeColor: .blue) {}

                    ActionButton(icon: "arrow.2.squarepath", count: post.reposts, active: reposted, activeColor: .green) {
                        reposted.toggle()
                    }

                    ActionButton(icon: liked ? "heart.fill" : "heart", count: post.likes + (liked ? 1 : 0), active: liked, activeColor: .red) {
                        liked.toggle()
                    }

                    Spacer()

                    Button {
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - ActionButton

struct ActionButton: View {
    let icon: String
    let count: Int
    let active: Bool
    let activeColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                Text(count.formatted())
                    .font(.system(size: 13))
                    .contentTransition(.numericText())
            }
            .foregroundStyle(active ? activeColor : .secondary)
            .animation(.spring(duration: 0.3), value: active)
        }
    }
}

#Preview {
    FeedView()
}
