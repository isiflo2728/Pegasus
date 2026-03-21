//
//  ContentView.swift
//  Pegasus
//
//  Created by Isidoro Flores on 3/10/26.
//

//Custom Tab Bar testing


enum CustomTab: String, CaseIterable, Hashable {
    case home = "Home"
    case messages = "Messages"
    case searchs = "Search"

    var symbol: String {
        switch self {
        case .home: return "house"
        case .messages: return "message"
        case .searchs: return "magnifyingglass"
        }
    }
    var actionSymbol: String {
        switch self{
        case .home: return "plus"
        case .messages: return "square.and.pencil"
        case .searchs: return "line.3.horizontal.decrease.circle"
        }
    }
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

import SwiftUI

struct HomeView: View {
    @State private var activeTab: CustomTab = .home

    @State private var showView: Bool = false// tracks user interaction


    var body: some View {
        TabView(selection: $activeTab) {
            Tab.init(value: .home){
                FeedView()
                //add this to every view
                .safeAreaBar(edge: .bottom, spacing: 0, content: {
                    Text(".")
                        .blendMode(.destinationOver)
                        .frame(height: 55)
                })
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            Tab.init(value: .messages){
                MessageView()
                .safeAreaBar(edge: .bottom, spacing: 0, content: {
                    Text(".")
                        .blendMode(.destinationOver)
                        .frame(height: 55)
                })
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            Tab.init(value: .searchs){
                SearchView()
                .safeAreaBar(edge: .bottom, spacing: 0, content: {
                    Text(".")
                        .blendMode(.destinationOver)
                        .frame(height: 55)
                })
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0){
            CustomTabBarView()
                .padding(.horizontal, 20)
        }
        .fullScreenCover(isPresented: $showView) {
            switch activeTab {
            case .home:
                CreatePostView()
            case .messages:
                ComposeView()
            case .searchs:
                FilterView()
            }
        }
    }

@ViewBuilder
func CustomTabBarView() -> some View {
    ZStack(alignment: .trailing) {
        GlassEffectContainer(spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                GeometryReader { geo in
                    CustomTabBar(size: geo.size, activeTab: $activeTab) { tab in
                        VStack(spacing: 3) {
                            Image(systemName: tab.symbol)
                                .font(.title3)
                            Text(tab.rawValue)
                                .font(.system(size: 10))
                                .fontWeight(.medium)
                        }
                        .symbolVariant(.fill)
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
            showView = true
        } label: {
            ZStack {
                ForEach(CustomTab.allCases, id: \.rawValue) { tab in
                    Image(systemName: tab.actionSymbol)
                        .font(.system(size: 22, weight: .medium))
                        .blurFade(activeTab == tab)
                }
            }
            .frame(width: 55, height: 55)
            .contentShape(Rectangle())
        }
        .glassEffect(.regular.interactive(), in: .capsule)
        .animation(.smooth(duration: 0.55, extraBounce: 0), value: activeTab)
        .buttonStyle(.plain)
        .tint(.primary)
    }
}
}
//Blur fade in/out

extension View {
    @ViewBuilder

    func blurFade (_ status: Bool) -> some View {
        self
            .compositingGroup()
            .blur(radius: status ? 0 : 10)
            .opacity(status ? 1 : 0)
    }
}

#Preview {
    HomeView()
}
