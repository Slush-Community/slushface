//
//  Conversation.swift
//  slush
//
//  Created by Aidan Lynde on 12/16/23.
//

import SwiftUI
struct Conversation: Identifiable, Codable {
    var id: String = UUID().uuidString
    var participants: [String]  // User IDs of participants
    var messages: [Message]
}

