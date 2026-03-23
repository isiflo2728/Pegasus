//
//  Post.swift
//  Pegasus
//
//  Created by Johny Vu on 3/21/26.
//

import Foundation
import SwiftUI

// Created a protocol that acts as the basis to all posts
protocol PostProtocol: Identifiable {
    var id: UUID { get }
    var username: String { get }
    var handle: String { get }
    var timeAgo: String { get }
    var content: String { get }
    var likes: Int { set get }
    var replies: Int { set get }
    var reposts: Int { set get }
    var avatarColor: Color { get }
    var imageColors: [Color]? { get }
}

// Below will contain all the different types of posts and their fields to be implimented in the future
// Polls, Slideshows, Infographics, etc.

struct BasicPost: PostProtocol {
    var id: UUID
    var username: String
    var handle: String
    var timeAgo: String
    var content: String
    var likes: Int = 0
    var replies: Int = 0
    var reposts: Int = 0
    var avatarColor: Color = .blue
    var imageColors: [Color]? = nil
}
