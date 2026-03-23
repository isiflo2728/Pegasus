//
//  Tab.swift
//  Pegasus
//
//  Created by Johny Vu on 3/21/26.
//

enum CustomTab: String, CaseIterable {
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
