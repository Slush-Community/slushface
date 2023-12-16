//
//  Message.swift
//  slush
//
//  Created by Aidan Lynde on 12/16/23.
//

import SwiftUI
import FirebaseFirestore
struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var senderID: String
    var receiverID: String
    var timestamp: Date
    
    
    init(id: String = UUID().uuidString, text: String, senderID: String, receiverID: String, timestamp: Date) {
        self.id = id
        self.text = text
        self.senderID = senderID
        self.receiverID = receiverID
        self.timestamp = timestamp
    }

    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.text = dictionary["text"] as? String ?? ""
        self.senderID = dictionary["senderID"] as? String ?? ""
        self.receiverID = dictionary["receiverID"] as? String ?? ""
        self.timestamp = (dictionary["timestamp"] as? Timestamp)?.dateValue() ?? Date()
    }
    var dictionaryRepresentation: [String: Any] {
        return [
            "id": id,
            "text": text,
            "senderID": senderID,
            "receiverID": receiverID,
            "timestamp": timestamp
        ]
    }
}

