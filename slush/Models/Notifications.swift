//
//  Notifications.swift
//  slush
//
//  Created by Aidan Lynde on 12/16/23.
//

import Foundation
import SwiftUI

enum NotificationType: String, Codable {
    case paymentRequest
    case verification
    case promotion
    case info
}

enum NotificationAction: String, Codable {
    case slushNow
    case verifyNow
    case learnMore
    case join
    case decline
}

struct Notification: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var type: NotificationType
    var amount: Double?  // For payment requests
    var action: NotificationAction?
    var expires: Date?  // For time-sensitive notifications

    // You may need a custom init if you have complex logic to initialize the model
}


