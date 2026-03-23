//
//  Activity.swift
//  Pegasus
//
//  Created by Johny Vu on 3/21/26.
//

import Foundation
import SwiftUI


// Created protocol to act as a basis for the rest of the different types of stricts that entails all the different activities
protocol ActivityProtocol: Identifiable {
    var user: String { get }
    var avatarColor: Color { get }
    var typePrefix: String { get }
}

// Acts as a computed property and creates the id based off the given type prefix and username
extension ActivityProtocol {
    var id: String { "\(typePrefix)-\(user)" }
}

// All different types of activies and their fields can be found below

struct RunningActivity: ActivityProtocol {
    var user: String
    var typePrefix: String { "run" }
    var avatarColor: Color
    var distance: String
    var pace: String
    var heartRate: Int
    var duration: String
    var ringProgress: Double
}

struct ListeningActivity: ActivityProtocol {
    var user: String
    var typePrefix: String { "listen" }
    var avatarColor: Color
    var song: String
    var artist: String
    var album: String
    var albumColor: Color
}

struct MacActivity: ActivityProtocol {
    var user: String
    var typePrefix: String { "mac" }
    var avatarColor: Color
    var app: String
    var timeAgo: String
}

struct WatchingActivity: ActivityProtocol {
    var user: String
    var typePrefix: String { "watch" }
    var avatarColor: Color
    var title: String
    var episode: String
    var artColor: Color
}
