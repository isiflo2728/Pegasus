# Pegasus — Resume Bullet Points

- Built a native iOS social app in SwiftUI featuring a dual-feed system (public posts + close friends activity) with interactive post cards supporting likes, reposts, and animated numeric counters using `contentTransition(.numericText())`

- Engineered a custom floating tab bar by bridging UIKit's `UISegmentedControl` into SwiftUI via `UIViewRepresentable` and the Coordinator pattern, rendering SwiftUI tab icons into UIKit using `ImageRenderer` and applying iOS 26 liquid glass effects (`GlassEffect`)

- Designed a polymorphic real-time activity card system with four card types (Running, Listening, On Mac, Watching) modeled as a Swift enum with associated values, rendered via `LazyVStack` for smooth scrolling performance
