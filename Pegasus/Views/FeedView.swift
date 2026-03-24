//
//  FeedView.swift
//  Pegasus
//
//  Created by Isidoro Flores on 3/11/26.
//  Modified by Johny Vu on 3/21/26.

import SwiftUI

// MARK: - Mock Data

// Use the Post Protocol Model and use the different Post structures to define the data
let mockPosts: [any PostProtocol] = [
    BasicPost(id: UUID(), username: "Jess Monroe", handle: "jessmonroe", timeAgo: "2m", content: "Just shipped the new update. Took three months but it's finally out. Clean, fast, no bloat.", likes: 214, replies: 18, reposts: 42, avatarColor: .indigo, imageColors: [.indigo, .purple]),
    BasicPost(id: UUID(), username: "Kai Nakamura", handle: "kainaka", timeAgo: "11m", content: "The best interfaces are the ones you stop noticing. You just use them.", likes: 891, replies: 64, reposts: 203, avatarColor: .orange, imageColors: nil),
    BasicPost(id: UUID(), username: "Mara Solis", handle: "marasolis", timeAgo: "34m", content: "Hot take: most apps have 3x too many features and 1/3 the polish they should.", likes: 477, replies: 91, reposts: 118, avatarColor: .pink, imageColors: [.pink, .orange]),
    BasicPost(id: UUID(), username: "Dev Patel", handle: "devpatel", timeAgo: "1h", content: "Spent the whole morning on a 12pt spacing fix. Totally worth it.", likes: 133, replies: 7, reposts: 29, avatarColor: .teal, imageColors: nil),
    BasicPost(id: UUID(), username: "Lena Fischer", handle: "lenafischer", timeAgo: "2h", content: "Reading old WWDC sessions is still the best way to learn SwiftUI properly. The fundamentals haven't changed.", likes: 562, replies: 43, reposts: 97, avatarColor: .purple, imageColors: [.purple, .blue]),
    BasicPost(id: UUID(), username: "Omar Hassan", handle: "omarhassan", timeAgo: "3h", content: "Deleted 400 lines of code today. The feature works better now.", likes: 1204, replies: 88, reposts: 341, avatarColor: .green, imageColors: nil),
]

// MARK: - Activity Card Models

// Use the Activity Protocol Model and use the different Activity structures to define the data
let mockActivityCards: [any ActivityProtocol] = [
    RunningActivity(user: "Kai Nakamura", avatarColor: .orange, distance: "4.2 mi", pace: "7'42\"", heartRate: 158, duration: "32:24", ringProgress: 0.78),
    ListeningActivity(user: "Mara Solis", avatarColor: .pink, song: "Nights", artist: "Frank Ocean", album: "Blonde", albumColor: Color(red: 0.85, green: 0.75, blue: 0.6)),
    MacActivity(user: "Dev Patel", avatarColor: .teal, app: "Xcode", timeAgo: "3m ago"),
    WatchingActivity(user: "Lena Fischer", avatarColor: .purple, title: "Severance", episode: "S2 · E6", artColor: Color(red: 0.15, green: 0.15, blue: 0.35)),
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
                            ForEach(mockPosts, id: \.id) { post in
                                PostRow(post: post)
                                Divider()
                                    .padding(.leading, 72)
                            }
                        }
                        .padding(.top, 8)
                    } else {
                        // Close friends activity feed
                        LazyVStack(spacing: 12) {
                            ForEach(mockActivityCards, id: \.id) { card in
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
    let card: any ActivityProtocol

    var body: some View {
        // Use type casting to assign the cards to their designated views
        // Wrap everything in a group container to not piss off SwiftUI :/
        // Returns single view type
        Group {
            if let run = card as? RunningActivity {
                RunningCard(activity: run)
            } else if let music = card as? ListeningActivity {
                ListeningCard(activity: music)
            } else if let mac = card as? MacActivity {
                OnMacCard(activity: mac)
            } else if let watch = card as? WatchingActivity {
                WatchingCard(activity: watch)
            } else {
                EmptyView()
            }
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
    let activity: RunningActivity

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardHeader(user: activity.user, avatarColor: activity.avatarColor, label: "Outdoor Run · Live", icon: "figure.run", iconColor: .green)

            HStack(spacing: 16) {
                // Activity ring
                ZStack {
                    Circle()
                        .stroke(Color.green.opacity(0.2), lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: activity.ringProgress)
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
                        StatBlock(value: activity.distance, label: "Distance")
                        StatBlock(value: activity.pace, label: "Avg Pace")
                        StatBlock(value: activity.duration, label: "Time")
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(.red)
                        Text("\(activity.heartRate) BPM")
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
    let activity: ListeningActivity

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardHeader(user: activity.user, avatarColor: activity.avatarColor, label: "Listening on Apple Music", icon: "music.note", iconColor: .pink)

            HStack(spacing: 12) {
                // Album art placeholder
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(activity.albumColor.gradient)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 20, weight: .light))
                            .foregroundStyle(.white.opacity(0.7))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(activity.song)
                        .font(.system(size: 15, weight: .semibold))
                    Text(activity.artist)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    Text(activity.album)
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
    let activity: MacActivity
    var body: some View {
        HStack(spacing: 12) {
            CardHeader(user: activity.user, avatarColor: activity.avatarColor, label: "Active on Mac · \(activity.timeAgo)", icon: "laptopcomputer", iconColor: .blue)

            Spacer()

            Text(activity.app)
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
    let activity: WatchingActivity

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardHeader(user: activity.user, avatarColor: activity.avatarColor, label: "Watching on Apple TV", icon: "appletv.fill", iconColor: .primary)

            HStack(spacing: 12) {
                // Show art placeholder
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(activity.artColor.gradient)
                    .frame(width: 80, height: 56)
                    .overlay(
                        Image(systemName: "play.rectangle.fill")
                            .font(.system(size: 20, weight: .light))
                            .foregroundStyle(.white.opacity(0.6))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(activity.title)
                        .font(.system(size: 15, weight: .semibold))
                    Text(activity.episode)
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
    let post: any PostProtocol
    
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
                
                // Seperated the main content from the post action buttons
                // Keeping the double tap over the entire container causes the main like button itself to have a slight delay in the animation
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
                }
                .onTapGesture(count: 2) {
                    liked.toggle()
                }
                
                // Action bar
                // Keeping the action bar seperate from the double tap container removes the delayed interaction
                HStack(spacing: 32) {
                    ActionButton(icon: "bubble.left", count: post.replies, active: false, activeColor: .blue) {}

                    ActionButton(icon: "arrow.2.squarepath", count: post.reposts, active: reposted, activeColor: .green) {
                        reposted.toggle()
                    }

                    ActionButton(icon: liked ? "heart.fill" : "heart", count: post.likes + (liked ? 1 : 0), active: liked, activeColor: .red) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                            liked.toggle()
                        }
                    }
                    .sensoryFeedback(.impact(weight: .medium), trigger: liked)

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
                    .contentTransition(.symbolEffect(.replace))
                    .symbolEffect(.bounce, value: active)
                Text(count.formatted())
                    .font(.system(size: 14))
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
