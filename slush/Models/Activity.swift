//
//  Activity.swift
//  slush
//
//  Created by Aidan Lynde on 12/14/23.
//
import SwiftUI
struct Activity {
    var id: String                // Unique identifier for the activity
    var type: ActivityType        // Type of activity (friend request, join slush, create slush)
    var date: Date                // Timestamp of the activity
    var involvedUserID: String    // ID of the user involved in the activity
    var involvedUserName: String  // Name of the user involved in the activity
    var slushID: String?          // ID of the slush involved, if applicable
    var slushTitle: String?       // Title of the slush, if applicable
    var description: String {     // Computed property to generate a description based on activity type
        switch type {
        case .friendRequest:
            return "\(involvedUserName) sent you a friend request."
        case .joinSlush:
            return "\(involvedUserName) joined your slush '\(slushTitle ?? "")'."
        case .createSlush:
            return "\(involvedUserName) created a new slush '\(slushTitle ?? "")'."
        }
    }
}

enum ActivityType: String {
    case friendRequest = "friendRequest"
    case joinSlush = "joinSlush"
    case createSlush = "createSlush"
}

