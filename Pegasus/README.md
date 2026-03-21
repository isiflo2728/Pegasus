# Pegasus — iOS Social App

A native iOS social networking app built with SwiftUI. Think Twitter/X meets Apple activity sharing — users can post text, stories, and songs, while also seeing a real-time activity feed of what their close friends are doing (workouts, music, shows, apps).

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI Framework | SwiftUI (iOS 26+) |
| Navigation | `TabView` + custom bottom bar |
| UIKit Bridge | `UIViewRepresentable` + `Coordinator` |
| State Management | `@State` / `@Binding` |
| Data | Mock data (no backend yet) |
| Testing | Swift Testing framework |
| Build | Xcode, iOS 26 minimum deployment |

> **Note:** The app uses `glassEffect()` and `safeAreaBar()` which are iOS 26-only APIs. Make sure your simulator/device targets iOS 26+.

---

## Project Structure

```
Pegasus/
├── PegasusApp.swift              # @main entry point → launches HomeView
├── HomeView.swift                # Root tab shell + floating action button
├── Assets.xcassets/              # App icons, colors, image assets
│
├── Views/
│   ├── FeedView.swift            # Dual-feed: public posts + close friends activity
│   ├── MessageView.swift         # Messages tab (stub)
│   ├── SearchView.swift          # Search tab (stub)
│   │
│   ├── SubViews/
│   │   ├── CreatePostView.swift  # Post type picker (Feed / Story / Song)
│   │   ├── ComposeView.swift     # New message composer (empty)
│   │   ├── FilterView.swift      # Search filter sheet (stub)
│   │   └── ProfileView.swift     # User profile page (stub)
│   │
│   └── Nested Sub Views/
│       ├── FeedPostEditor.swift  # Feed post creation editor (stub)
│       ├── StoryPostEditor.swift # Story creation editor (stub)
│       └── SongPostEditor.swift  # Song post creation editor (stub)
│
└── Helpers/
    └── CustomTabBar.swift        # Generic UIKit segmented control → SwiftUI bridge
```

---

## Navigation Flow

```
PegasusApp
 └── HomeView  (tab bar + FAB overlay)
      ├── FeedView
      │    ├── Public Feed  (text posts with likes/reposts/replies)
      │    └── Close Friends Feed  (activity cards: running, listening, watching, on Mac)
      ├── MessageView  (stub)
      ├── SearchView  (stub)
      └── Modals
           ├── CreatePostView → FeedPostEditor | StoryPostEditor | SongPostEditor
           ├── ComposeView  (new message)
           └── FilterView   (search filters)
```

---

## Data Models

All models currently live in `FeedView.swift` with mock data. These need to be extracted into a dedicated `Models/` layer before connecting a backend.

### `Post`
```swift
struct Post: Identifiable {
    let id: UUID
    let username: String
    let handle: String
    let timeAgo: String
    let content: String
    let likes: Int
    let replies: Int
    let reposts: Int
    let avatarColor: Color
    let imageColors: [Color]?  // nil = text-only post
}
```

### `ActivityCard` (enum with associated values)
```swift
enum ActivityCard: Identifiable {
    case running(user:, avatarColor:, distance:, pace:, duration:, heartRate:, ringProgress:)
    case listening(user:, avatarColor:, song:, artist:, album:, albumColor:)
    case onMac(user:, avatarColor:, app:, timeAgo:)
    case watching(user:, avatarColor:, title:, episode:, artColor:)
}
```

### Supporting Enums
```swift
enum CustomTab: String, CaseIterable, Hashable { case home, messages, searchs }
enum PostType: String, CaseIterable, Hashable  { case feed, story, song }
```

---

## Key Architectural Patterns

### 1. Generic Tab Bar Bridge (`CustomTabBar.swift`)
The custom tab bar uses `UIViewRepresentable` to wrap a `UISegmentedControl` and expose it to SwiftUI. It is **fully generic** — it works with any `enum` that is `RawRepresentable + CaseIterable`. It uses `ImageRenderer` to render SwiftUI `View`s into UIKit images for the segment labels. This component is reused in both `HomeView` (main tabs) and `CreatePostView` (post type selector).

### 2. Polymorphic Activity Card Rendering
`ActivityCard` is a Swift enum with associated values — each case carries the data for a different activity type. A `switch` statement in `ActivityCardView` dispatches rendering to the right card subview. This keeps the feed rendering type-safe and easy to extend with new card types.

### 3. Dual-Feed System
`FeedView` contains two independent feeds behind a segmented picker:
- **Public Feed** — traditional `Post` list (text, optional image gradient, engagement stats)
- **Close Friends Activity Feed** — `ActivityCard` list showing real-time activity (workouts, music, shows)

### 4. Glass Morphism + iOS 26 UI
The tab bar and action buttons use `.glassEffect()` (iOS 26+). Safe area content uses `.safeAreaBar()`. Animations use `Animation.smooth(duration:extraBounce:)` for modern feel. Post interaction counters use `.contentTransition(.numericText())` for smooth number updates.

### 5. State Management (current)
All state is local `@State` in each view. There is no shared state, view model layer, or observable store yet. This is a known gap to address before backend work begins.

---

## What's Built vs. What Needs Work

### Done
- Core tab navigation shell
- Feed display with mock data (both post types)
- Custom generic tab bar component
- Post creation flow routing (type picker → editor)
- Activity card rendering (running, listening, watching, on Mac)
- Like / repost interaction with animated counters

### Stubs (structure exists, logic missing)
- Message tab & compose screen
- Search tab & filter sheet
- Profile view
- FeedPostEditor, StoryPostEditor, SongPostEditor

### Not Started
- Authentication (Sign In with Apple, or otherwise)
- Backend / API networking layer
- Data persistence (CoreData, SwiftData, Firebase, or REST)
- Real user accounts & relationships (follow, close friends)
- Push notifications
- Image / media upload & display
- HealthKit integration (real workout data)
- MusicKit integration (real listening data)

---

## What to Build Next (Recommended Order)

1. **Extract models** — Move `Post`, `ActivityCard`, and enums out of `FeedView.swift` into a `Models/` folder.
2. **Add ViewModels** — Introduce `@Observable` view models (`FeedViewModel`, `AuthViewModel`) so views aren't holding business logic.
3. **Auth layer** — Implement Sign In with Apple or email/password. Gate `HomeView` behind an auth check in `PegasusApp`.
4. **Networking layer** — Add a `Services/` or `API/` folder with a client (URLSession or a thin Firebase wrapper). Wire up to the view models.
5. **Persistence** — Decide on SwiftData vs. Firebase Firestore vs. a custom backend.
6. **Fill in stubs** — Profile, Messages, Search, and the three post editors can be built in parallel once auth and data layers exist.
7. **Real activity data** — Integrate HealthKit for workouts and MusicKit for now-playing once the core feed is wired up.

---

## Running the Project

1. Open `Pegasus.xcodeproj` in Xcode.
2. Select an iOS 26 simulator (or physical device on iOS 26+).
3. Build & run (`Cmd+R`). No API keys or environment setup needed — everything is mocked.

---

## Testing

- **Unit tests:** `PegasusTests/` — currently template only, needs coverage for models and view models once those exist.
- **UI tests:** `PegasusUITests/` — currently template only, good target for critical flows (auth, post creation, feed loading).
