//
//  SlushModel.swift
//  slush
//
//  Created by Kareem Benaissa on 9/17/23.
//

import Foundation
import SwiftUI

// Represents an individual member in a Slush transaction
struct SlushMember: Identifiable, Codable {
    var id: String  // This could be the user ID
    var username: String
    var amount: Double?  // This might be nil if the amount hasn't been set yet
    var profileImageURL: URL?
    var paymentStatus: PaymentStatus  // Enum to represent if they've paid or not
}

// Enum to represent the payment status of a Slush member
enum PaymentStatus: String, Codable {
    case paid
    case pending
    case notPaid  // or any other statuses you might need
}

// Represents the entire Slush transaction
struct Slush: Identifiable, Codable {
    var id: String  // Unique identifier for the Slush
    var name: String?
    var category: String?
    var location: String?
    var brand: String?
    var members: [SlushMember]
    var paymentType: PaymentType  // Enum to represent payment types like manual or fixed rate
    var totalAmount: Double?
    var description: String?
    var tip: Double?  // Optional tip percentage
    var splitType: SplitType  // Enum to represent how the Slush is split
    var allowedPaymentForms: [PaymentForm]
    var shareLink: URL?
    var permissions: SlushPermissions  // Enum to represent permissions like 'all friends', 'invite only', etc.
}

// Enum to represent how the Slush is split between members
enum SplitType: String, Codable {
    case manual
    case fixedRate
    case fractional  // Add other types as needed
}

// Enum to represent allowed forms of payment in a Slush
enum PaymentForm: String, Codable {
    case venmo
    case cashapp
    case zelle
    case applePay
    case cash
    case bank  // Add other forms as needed
}
enum PaymentType: String, Codable {
    case manual
    case fixedRate
    // Add other types as needed
}


// Enum to represent the permissions settings of a Slush
enum SlushPermissions: String, Codable {
    case allFriends
    case inviteOnly  // Add other permissions as needed
}

// Use this to provide default values for a new Slush creation
extension Slush {
    static var new: Slush {
        Slush(id: UUID().uuidString,
              name: nil,
              category: nil,
              location: nil,
              brand: nil,
              members: [],
              paymentType: .manual,  // Ensure that .manual is a case of PaymentType
              totalAmount: nil,
              description: nil,
              tip: nil,
              splitType: .manual,  // Ensure that .manual is a case of SplitType
              allowedPaymentForms: [],
              shareLink: nil,
              permissions: .allFriends)  // Ensure that .allFriends is a case of SlushPermissions
    }
}


